#include "db+rofi.h"
#include "errmsg.h"
#include "main.h"
#include "rofi.h"

rofi_select_list_opts_t select_script_opts;

rofi_select_list_result_t select_script_result;

rofi_select_list_callbacks_t select_script_callbacks = {
  .is_run_alt = db_rofi_is_run_alt,
  .toggle_run_alt = db_rofi_toggle_run_alt,
};

void
select_script (void)
{
  select_script_opts.common.prompt = "Select a script to run (Shift-Enter == "
                                     "toggle:terminal)";
  select_script_opts.common.ignorecase = argp.ignorecase;
  select_script_opts.common.addopts = NULL;
  select_script_opts.use_markup = argp.use_markup;
  select_script_opts.run_alt_tag = argp.run_alt_tag;

  char *errmsg = rofi_select_list (&select_script_opts, script_files,
                                   &select_script_callbacks, p_db,
                                   &select_script_result);
  ERRMSG_FAIL_IF (stderr, errmsg);

  rofi_free_result (&(select_script_result.base));
}
