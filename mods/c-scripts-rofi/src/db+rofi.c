#include "db.h"
#include "rofi.h"

bool
db_rofi_is_run_alt (char *cmd, void *closure)
{
  db_t *p_db = (db_t *)closure;
  return db_is_run_alt (p_db, cmd);
}

bool
db_rofi_toggle_run_alt (char *cmd, void *closure)
{
  db_t *p_db = (db_t *)closure;
  return db_toggle_run_alt (p_db, cmd);
}
