#ifndef ARGP_H
#define ARGP_H

#include "externc.h"
#include "utarray.h"
#include <stdbool.h>
#include <stdio.h>

#define ARGP_MALLOC malloc
#define ARGP_STRDUP strdup
#define ARGP_FREE free

#define SCRIPT_ROFI_NO_DB_FILE "~/.no-db-c-scripts-rofi"
#define SCRIPT_ROFI_DB_FILE "~/.c-scripts-rofi.hist"
#define SCRIPT_ROFI_XTERM_COMMAND "x-terminal-emulator -e"
#define SCRIPT_ROFI_SCRIPT_DIRS                                               \
  "~/local/scripts:~/local/bin:~/.screenlayout:~/P/v3/bin"
#define SCRIPT_ROFI_RUN_ALT_TAG " <span color='#FF69B4'>[TERM]</span>"

typedef struct
{
  bool print;
  bool save;
  bool execute;

  char *script_dirs;
  UT_array *__script_dirs_cache;

  char *db_file;
  char *term_command;
  bool dump_and_exit;
  char *exec_wrapper;
  char *file_regex;

  bool ignorecase;
  char *no_db_flag_file;
  char *run_alt_tag;
  bool use_markup;
} argp_t;

EXTERN void argp_init (argp_t *p_argp);
EXTERN void argp_parse (int argc, char *argv[], argp_t *p_argp);
EXTERN void argp_free_internal (argp_t *p_argp);

EXTERN void argp_print_usage (argp_t *p_argp, FILE *fp);

EXTERN bool argp_load_db_allowed (argp_t *p_argp);
EXTERN bool argp_save_db_allowed (argp_t *p_argp);

EXTERN void argp_set_script_dirs (argp_t *p_argp, char *script_dirs);
EXTERN UT_array *argp_get_script_dirs_owned (argp_t *p_argp);

#endif /* ARGP_H */
