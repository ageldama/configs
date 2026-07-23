#ifndef ROFI_H
#define ROFI_H

#include "externc.h"
#include "utarray.h"
#include <stdbool.h>

#define ROFI_MALLOC malloc
#define ROFI_FREE free
#define ROFI_STRDUP strdup

typedef void (*rofi_write_fn) (const int fd, void *closure);

EXTERN ssize_t fd_write (int fd, const char *s);
EXTERN ssize_t fd_write_sep (int fd, const char *s, char sep);

EXTERN char *fd_slurp_alloc (int fd);

typedef struct
{
  int exitcode;
  bool alt;
  char *stdout_text;
} rofi_result_t;

EXTERN void rofi_free_result (rofi_result_t *p_result);

EXTERN char *rofi_run (UT_array *cmdv, rofi_write_fn write_fn,
                       void *write_closure, rofi_result_t *p_result);

EXTERN char *rofi_show_error (const char *message);

EXTERN void rofi_write_nothing (const int fd, void *closure);

typedef struct
{
  char *prompt;
  bool ignorecase;
  char *addopts;
} rofi_common_opts_t;

typedef struct
{
  rofi_common_opts_t common;
  char *label_y;
  char *label_n;
} rofi_ask_yn_opts_t;

typedef struct
{
  rofi_result_t base;
  bool canceled;
  bool answer_yes;
} rofi_ask_yn_result_t;

EXTERN char *rofi_ask_yn (const rofi_ask_yn_opts_t *yn_opts,
                          rofi_ask_yn_result_t *p_result);

typedef struct
{
  rofi_common_opts_t common;
  bool use_markup;
  char *run_alt_tag;
} rofi_select_list_opts_t;

typedef bool (*is_run_alt_fn) (char *cmd, void *closure);
typedef bool (*toggle_run_alt_fn) (char *cmd, void *closure);

typedef struct
{
  is_run_alt_fn is_run_alt;
  toggle_run_alt_fn toggle_run_alt;
} rofi_select_list_callbacks_t;

typedef struct
{
  rofi_result_t base;
  bool canceled;
  char *selected;
} rofi_select_list_result_t;

EXTERN char *rofi_select_list (const rofi_select_list_opts_t *p_opts,
                               UT_array *list,
                               rofi_select_list_callbacks_t *p_callbacks,
                               void *callback_data,
                               rofi_select_list_result_t *p_result);

#endif /* ROFI_H */
