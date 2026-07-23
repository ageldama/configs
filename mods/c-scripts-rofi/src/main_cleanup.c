#include "main.h"
#include "file_find.h"

void
cleanup (void)
{
  if (p_regex != NULL)
    {
      file_find_regex_free (p_regex);
      free (p_regex);
      p_regex = NULL;
    }

  if (script_files != NULL)
    {
      utarray_free (script_files);
      script_files = NULL;
    }

  if (p_db != NULL)
    {
      db_free (p_db);
      p_db = NULL;
    }

  if (composed_cmdline != NULL)
    {
      free (composed_cmdline);
      composed_cmdline = NULL;
    }

  argp_free_internal (&argp);
}
