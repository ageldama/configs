#ifndef FILE_FIND_H
#define FILE_FIND_H

#include "externc.h"
#include "utarray.h"
#include <regex.h>
#include <stdbool.h>
#include <stdio.h>
#include <sys/stat.h>

typedef bool (*file_find_matcher) (const char *abs_path, const char *dirname,
                                   const char *name, const struct stat *p_stat,
                                   void *closure);

typedef struct
{
  file_find_matcher dir_matcher;
  void *dir_matcher_closure;
  file_find_matcher file_matcher;
  void *file_matcher_closure;
  bool recurse;
} file_find_args_t;

EXTERN void file_find_list (UT_array *dstarray, const char *dirname,
                            file_find_args_t *p_args);

EXTERN void file_find_list_multiple (UT_array *dstarray,
                                     const UT_array *dirnames,
                                     file_find_args_t *p_args);

EXTERN bool file_find_only_file (const char *abs_path, const char *dirname,
                                 const char *name, const struct stat *p_stat,
                                 void *closure);

EXTERN char *file_find_regex_compile (regex_t *p_regex, const char *pattern);

EXTERN void file_find_regex_free (regex_t *p_regex);

EXTERN bool file_find_file_with_regex (const char *abs_path,
                                       const char *dirname, const char *name,
                                       const struct stat *p_stat,
                                       void *closure);

#endif /* FILE_FIND_H */
