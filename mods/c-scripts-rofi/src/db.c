#include "db.h"
#include "errmsg.h"
#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>

db_t *
db_init (void)
{
  db_t *p_db = DB_MALLOC (sizeof (db_t));
  p_db->p_cmd_hash = NULL;
  return p_db;
}

void
db_free (db_t *p_db)
{
  db_cmd_entry_t *p_cmd_hash = p_db->p_cmd_hash;

  if (p_cmd_hash != NULL)
    {
      db_cmd_entry_t *p_curr;
      db_cmd_entry_t *p_tmp;

      HASH_ITER (hh, p_cmd_hash, p_curr, p_tmp)
      {
        HASH_DEL (p_cmd_hash, p_curr);
        DB_FREE (p_curr->cmd);
        DB_FREE (p_curr);
      }
    }

  DB_FREE (p_db);
}

void
db_add (db_t *p_db, db_cmd_entry_t *p_entry)
{
  db_cmd_entry_t *p_found = NULL;

  HASH_FIND_STR (p_db->p_cmd_hash, p_entry->cmd, p_found);
  if (p_found == NULL)
    {
      HASH_ADD_STR (p_db->p_cmd_hash, cmd, p_entry);
    }
  else
    {
      p_found->run_alt = p_entry->run_alt;
      p_found->last_epoch = p_entry->last_epoch;
    }
}

void
db_add_args_copying (db_t *p_db, const char *cmd, time_t last_epoch,
                     bool run_alt)
{
  db_cmd_entry_t *p_entry = DB_MALLOC (sizeof (db_cmd_entry_t));
  memset (p_entry, 0, sizeof (db_cmd_entry_t));
  //
  size_t cmd_len = strnlen (cmd, DB_CMD_MAX);
  char *cmd2 = DB_MALLOC (cmd_len + 1);
  memset (cmd2, 0, cmd_len + 1);
  strncpy (cmd2, cmd, cmd_len);
  //
  p_entry->cmd = cmd2;
  p_entry->run_alt = run_alt;
  p_entry->last_epoch = last_epoch;
  //
  db_add (p_db, p_entry);
}

char *
db_save_to_filename (db_t *p_db, const char *filename)
{
  FILE *fp = NULL;
  fp = fopen (filename, "wb");
  if (NULL == fp)
    {
      return errmsg_fmt_alloc ("[ERROR] %s %s filename=%s", __func__,
                               strerror (errno), filename);
    }

  // magic
  size_t db_magic_len = strnlen (DB_MAGIC, DB_CMD_MAX);
  fwrite (DB_MAGIC, db_magic_len, 1, fp);

  // total
  size_t tot_entry = HASH_COUNT (p_db->p_cmd_hash);
  fwrite (&tot_entry, sizeof (tot_entry), 1, fp);

  // foreach:entry
  db_cmd_entry_t *p_curr;
  db_cmd_entry_t *p_tmp;

  HASH_ITER (hh, p_db->p_cmd_hash, p_curr, p_tmp)
  {
    // entry: [cmd-len, cmd]
    size_t cmd_len = strnlen (p_curr->cmd, DB_CMD_MAX);
    fwrite (&cmd_len, sizeof (cmd_len), 1, fp);
    fwrite (p_curr->cmd, cmd_len, 1, fp);

    // entry: last_epoch, run_alt
    fwrite (&(p_curr->last_epoch), sizeof (p_curr->last_epoch), 1, fp);
    fputc (p_curr->run_alt ? 1 : 0, fp);
  }

  fclose (fp);

  // OK: no errmsg
  return NULL;
}

char *
db_load_from_filename (db_t *p_db, const char *filename)
{
  // magic_len
  const size_t db_magic_len = strnlen (DB_MAGIC, DB_CMD_MAX);
  long long fsize = file_size (filename);
  if (fsize < 0LL)
    {
      return errmsg_fmt_alloc ("[ERROR] %s: %s filename=%s", __func__,
                               strerror (errno), filename);
    }

  if (fsize < (long long)db_magic_len)
    {
      return errmsg_fmt_alloc ("[ERROR] %s: Invalid DB File magic! "
                               "(filename=%s  atleast=%zu actual=%lld)",
                               __func__, filename, db_magic_len, fsize);
    }

  //
  FILE *fp = NULL;
  fp = fopen (filename, "rb");
  if (NULL == fp)
    {
      return errmsg_fmt_alloc ("[ERROR] %s: %s filename=%s", __func__,
                               strerror (errno), filename);
    }

  // magic
  char *db_magic_buf = DB_MALLOC (db_magic_len);
  fread (db_magic_buf, db_magic_len, 1, fp);

  if (strncmp (DB_MAGIC, db_magic_buf, db_magic_len) != 0)
    {
      DB_FREE (db_magic_buf);
      return errmsg_fmt_alloc ("[ERROR] %s: magic mismatch, filename=%s",
                               __func__, filename);
    }

  DB_FREE (db_magic_buf);

  // total
  size_t tot_entry = 0;
  fread (&tot_entry, sizeof (tot_entry), 1, fp);

  // for:entry
  char *cmd = DB_MALLOC (DB_CMD_MAX);

  for (size_t idx = 0; tot_entry > idx; idx++)
    {
      // entry: [cmd_len, cmd]
      size_t cmd_len = 0;
      fread (&cmd_len, sizeof (cmd_len), 1, fp);

      fread (cmd, cmd_len, 1, fp);
      cmd[cmd_len] = 0;

      // entry: last_epoch, run_alt
      time_t last_epoch = 0;
      fread (&last_epoch, sizeof (last_epoch), 1, fp);

      char run_alt_ch = fgetc (fp);

      //
      db_add_args_copying (p_db, cmd, last_epoch, run_alt_ch > 0);
    }

  DB_FREE (cmd);

  // ok: no error
  return NULL;
}

long long
file_size (const char *filename)
{
  struct stat st;
  if (stat (filename, &st) == 0)
    {
      return st.st_size;
    }
  return -1; // error
}

db_cmd_entry_t *
db_get (db_t *p_db, const char *cmd)
{
  db_cmd_entry_t *p_found = NULL;
  HASH_FIND_STR (p_db->p_cmd_hash, cmd, p_found);
  return p_found;
}

time_t
db_get_last_epoch (db_t *p_db, const char *cmd)
{
  db_cmd_entry_t *p_entry = db_get (p_db, cmd);
  if (p_entry != NULL)
    {
      return p_entry->last_epoch;
    }
  else
    {
      return 0;
    }
}

time_t
db_set_last_epoch (db_t *p_db, const char *cmd, time_t last_epoch)
{
  db_cmd_entry_t *p_entry = db_get (p_db, cmd);
  if (p_entry != NULL)
    {
      p_entry->last_epoch = last_epoch;
      return p_entry->last_epoch;
    }
  else
    {
      db_add_args_copying (p_db, cmd, last_epoch, /*run_alt*/ false);
      return last_epoch;
    }
}

time_t
db_upd_last_epoch (db_t *p_db, const char *cmd)
{
  return db_set_last_epoch (p_db, cmd, time (NULL));
}

bool
db_is_run_alt (db_t *p_db, const char *cmd)
{
  db_cmd_entry_t *p_entry = db_get (p_db, cmd);
  if (p_entry != NULL)
    {
      return p_entry->run_alt;
    }
  else
    {
      return false;
    }
}

bool
db_set_run_alt (db_t *p_db, const char *cmd, bool run_alt)
{
  db_cmd_entry_t *p_entry = db_get (p_db, cmd);
  if (p_entry != NULL)
    {
      p_entry->run_alt = run_alt;
      return p_entry->run_alt;
    }
  else
    {
      db_add_args_copying (p_db, cmd, /*last_epoch*/ 0, run_alt);
      return run_alt;
    }
}

bool
db_toggle_run_alt (db_t *p_db, const char *cmd)
{
  bool curr = db_is_run_alt (p_db, cmd);
  return db_set_run_alt (p_db, cmd, !curr);
}

db_t *p_db_sort = NULL;

int
compare_cmd_by_last_epoch_inv (const void *_a, const void *_b)
{
  const char *a = *(const char *const *)_a;
  const char *b = *(const char *const *)_b;
  const time_t a_epoch = db_get_last_epoch (p_db_sort, a);
  const time_t b_epoch = db_get_last_epoch (p_db_sort, b);
  return (b_epoch > a_epoch) - (b_epoch < a_epoch);
}

void
db_sort_by_last_epoch_desc (db_t *p_db, UT_array *cmd_list)
{
  assert (NULL == p_db_sort);
  p_db_sort = p_db;
  utarray_sort (cmd_list, compare_cmd_by_last_epoch_inv);
  p_db_sort = NULL;
}
