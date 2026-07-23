#include "errmsg.h"
#include "file_find.h"
#include "macrofun.h"
#include "main.h"
#include <string.h>

void
compile_file_regex_or_not (void)
{
  if (NULL == argp.file_regex)
    return;

  p_regex = malloc (sizeof (regex_t));

  char *errmsg = file_find_regex_compile (p_regex, argp.file_regex);
  ERRMSG_FAIL_IF (stderr, errmsg);
}

void
list_script_files (void)
{
  UTARRAY_STR_NEW (script_files);

  file_find_args_t file_find_args = {
    .dir_matcher = NULL,
    .dir_matcher_closure = NULL,
    .file_matcher
    = p_regex == NULL ? file_find_only_file : file_find_file_with_regex,
    .file_matcher_closure = p_regex == NULL ? NULL : p_regex,
    .recurse = true,
  };

  file_find_list_multiple (script_files, argp_get_script_dirs_owned (&argp),
                           &file_find_args);

  db_sort_by_last_epoch_desc (p_db, script_files);
}
