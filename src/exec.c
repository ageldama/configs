#include "exec.h"
#include "errmsg.h"
#include "utarray.h"
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// TODO handle string contains "\0"
char *
exec_vp (UT_array *cmdv)
{
  size_t cmdv_len = utarray_len (cmdv);
  char **args = malloc ((cmdv_len + 1) * sizeof (char *));

  size_t idx = 0;
  char **pp_cmd = NULL;
  while ((pp_cmd = (char **)utarray_next (cmdv, pp_cmd)))
    {
      args[idx] = *pp_cmd;
      idx++;
    }

  args[cmdv_len] = NULL;
  int rc = execvp (args[0], args);
  (void)rc;

  /*l_err:*/
  free (args);
  return errmsg_fmt_alloc ("[ERROR] %s = %s", __func__, strerror (errno));
}
