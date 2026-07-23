#include "errmsg.h"
#include "main.h"
#include <string.h>

void
load_or_not (void)
{
  if (argp_load_db_allowed (&argp))
    {
      char *load_errmsg = db_load_from_filename (p_db, argp.db_file);
      ERRMSG_WARN_IF (stderr, load_errmsg);
    }
}

void
save_or_not (void)
{
  if (argp_save_db_allowed (&argp))
    {
      char *save_errmsg = db_save_to_filename (p_db, argp.db_file);
      ERRMSG_WARN_IF (stderr, save_errmsg);
    }
}

void
upd_last_epoch_of_selected (void)
{
  db_upd_last_epoch (p_db, select_script_result.selected);
}

void
print_or_not (void)
{
  if (!argp.print)
    return;
  if (NULL != composed_cmdline)
    fputs (composed_cmdline, stdout);
  else
    fputs (select_script_result.selected, stdout);
  fputs ("\n", stdout);
}
