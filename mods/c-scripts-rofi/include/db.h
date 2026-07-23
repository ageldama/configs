#ifndef DB_H
#define DB_H

#include "externc.h"
#include "utarray.h"
#include "uthash.h"
#include <stdbool.h>
#include <time.h>

#define DB_MALLOC malloc
#define DB_FREE free

#define DB_CMD_MAX 8192

#define DB_MAGIC "C-SCRIPTS-ROFI-1.0"

typedef struct
{
  char *cmd; /* Key */
  time_t last_epoch;
  bool run_alt;
  /* Required for uthash */
  UT_hash_handle hh;
} db_cmd_entry_t;

typedef struct
{
  db_cmd_entry_t *p_cmd_hash;
} db_t;

EXTERN db_t *db_init (void);

EXTERN void db_free (db_t *p_db);

EXTERN void db_add (db_t *p_db, db_cmd_entry_t *p_entry);
EXTERN void db_add_args_copying (db_t *p_db, const char *cmd,
                                 time_t last_epoch, bool run_alt);

EXTERN char *db_save_to_filename (db_t *p_db, const char *filename);

EXTERN char *db_load_from_filename (db_t *p_db, const char *filename);

EXTERN db_cmd_entry_t *db_get (db_t *p_db, const char *cmd);

EXTERN time_t db_set_last_epoch (db_t *p_db, const char *cmd,
                                 time_t last_epoch);

EXTERN time_t db_upd_last_epoch (db_t *p_db, const char *cmd);

EXTERN time_t db_get_last_epoch (db_t *p_db, const char *cmd);

EXTERN bool db_set_run_alt (db_t *p_db, const char *cmd, bool run_alt);

EXTERN bool db_toggle_run_alt (db_t *p_db, const char *cmd);

EXTERN bool db_is_run_alt (db_t *p_db, const char *cmd);

EXTERN long long file_size (const char *filename);

EXTERN void db_sort_by_last_epoch_desc (db_t *p_db, UT_array *cmd_list);

#endif /* DB_H */
