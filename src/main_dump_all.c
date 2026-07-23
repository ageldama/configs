#include "main.h"

void
dump_all_or_not (FILE *fp)
{
  if (!argp.dump_and_exit)
    return;

  fprintf (fp, "--- DB ---\n");

  unsigned int count = HASH_COUNT (p_db->p_cmd_hash);
  fprintf (fp, "* tot = \t%u\n", count);

  db_cmd_entry_t *curr;
  db_cmd_entry_t *tmp;

  HASH_ITER (hh, p_db->p_cmd_hash, curr, tmp)
  {
    printf ("%s : last=%ld alt=%d\n", curr->cmd, curr->last_epoch,
            curr->run_alt);
  }

  exit (EXIT_SUCCESS);
}
