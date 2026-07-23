#ifndef SCRIPTS_ROFI_MAIN_H
#define SCRIPTS_ROFI_MAIN_H

#include "externc.h"

#include "argp.h"
#include "db.h"
#include "rofi.h"

#include "utarray.h"

#include <regex.h>
#include <stdio.h>

extern argp_t argp;
extern db_t *p_db;
extern regex_t *p_regex;
extern UT_array *script_files;
extern rofi_select_list_result_t select_script_result;
extern char *composed_cmdline;

EXTERN void cleanup (void);
EXTERN void load_or_not (void);
EXTERN void save_or_not (void);
EXTERN void dump_all_or_not (FILE *fp);
EXTERN void compile_file_regex_or_not (void);
EXTERN void list_script_files (void);
EXTERN void select_script (void);
EXTERN void print_or_not (void);
EXTERN void exec_or_not (void);
EXTERN void upd_last_epoch_of_selected (void);
EXTERN void compose_cmdline (void);

#endif /* SCRIPTS_ROFI_MAIN_H */
