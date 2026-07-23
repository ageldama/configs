#include "rofi.h"
#include "errmsg.h"
#include "exec.h"
#include "utstring.h"
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

ssize_t
fd_write (int fd, const char *s)
{
  return write (fd, s, strlen (s));
}

ssize_t
fd_write_sep (int fd, const char *s, char sep)
{
  ssize_t written = fd_write (fd, s);
  char buf[1];
  buf[0] = sep;
  written += write (fd, buf, 1);
  return written;
}

#define fd_slurp_buflen 4096

char *
fd_slurp_alloc (int fd)
{
  UT_string *sbuf;
  utstring_new (sbuf);

  char *buf = malloc (fd_slurp_buflen);
  ssize_t nread;

  while ((nread = read (fd, buf, fd_slurp_buflen)) > 0)
    {
      utstring_bincpy (sbuf, buf, nread);
    }

  //
  size_t result_len = utstring_len (sbuf);
  char *result = ROFI_MALLOC (result_len + 1);
  result[result_len] = '\0';

  strncpy (result, utstring_body (sbuf), result_len);

  free (buf);
  utstring_free (sbuf);

  return result;
}

void
rofi_free_result (rofi_result_t *p_result)
{
  if (NULL == p_result)
    return;

  if (NULL != p_result->stdout_text)
    {
      ROFI_FREE (p_result->stdout_text);
      p_result->stdout_text = NULL;
    }
}

char *
rofi_run (UT_array *cmdv, rofi_write_fn write_fn, void *write_closure,
          rofi_result_t *p_result)
{
  int p_to_c[2]; // parent => child
  int c_to_p[2]; // child => parent

  if (pipe (p_to_c) == -1 || pipe (c_to_p) == -1)
    {
      return errmsg_fmt_alloc ("[ERROR] %s = %s", __func__, strerror (errno));
    }

  pid_t pid = fork ();

  if (pid == 0)
    {
      // CHILD

      close (p_to_c[1]); // where parent writes.
      close (c_to_p[0]); // where parent reads.

      dup2 (p_to_c[0], STDIN_FILENO);
      close (p_to_c[0]);

      dup2 (c_to_p[1], STDOUT_FILENO);
      close (c_to_p[1]);

      char *exec_errmsg = exec_vp (cmdv);
      ERRMSG_FAIL_IF (stderr, exec_errmsg);
    }

  // Parent
  close (p_to_c[0]); // where child reads.
  close (c_to_p[1]); // where child writes.

  write_fn (p_to_c[1], write_closure);
  close (p_to_c[1]);

  int wstatus = 0;
  pid_t result = waitpid (pid, &wstatus, 0);
  (void)result;

  char *stdout_text = fd_slurp_alloc (c_to_p[0]);
  close (c_to_p[0]);

  p_result->stdout_text = stdout_text;
  p_result->alt = false;
  p_result->exitcode = wstatus;

  return NULL; // OK.
}
