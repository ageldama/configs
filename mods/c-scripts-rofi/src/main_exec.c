#include "errmsg.h"
#include "exec.h"
#include "macrofun.h"
#include "main.h"
#include "strs.h"
#include <assert.h>
#include <string.h>

char *composed_cmdline = NULL;

#define COMPOSED_CMDLINE_MAX 8192

void
compose_cmdline (void)
{
  assert (composed_cmdline == NULL);
  composed_cmdline = malloc (COMPOSED_CMDLINE_MAX);
  memset (composed_cmdline, 0, COMPOSED_CMDLINE_MAX);

  int added_count = 0;
  char *cmd = select_script_result.selected;

  if (db_is_run_alt (p_db, cmd) && NULL != argp.term_command)
    {
      strncat (composed_cmdline, argp.term_command, COMPOSED_CMDLINE_MAX);
      added_count++;
    }

  if (NULL != argp.exec_wrapper)
    {
      if (added_count > 0)
        strncat (composed_cmdline, " ", 1);
      strncat (composed_cmdline, argp.exec_wrapper, COMPOSED_CMDLINE_MAX);
      added_count++;
    }

  if (added_count > 0)
    strncat (composed_cmdline, " ", 1);

  strncat (composed_cmdline, cmd, COMPOSED_CMDLINE_MAX);
}

void
exec_or_not (void)
{
  if (!argp.execute)
    return;

  assert (composed_cmdline != NULL);

  //
  UT_array *cmdv = str_split (composed_cmdline, " ");

  char *exec_errmsg = exec_vp (cmdv);
  ERRMSG_FAIL_IF (stderr, exec_errmsg);

  //
  utarray_free (cmdv);
  cmdv = NULL;
}
