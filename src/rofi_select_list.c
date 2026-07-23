#include "macrofun.h"
#include "rofi.h"
#include "utarray.h"
#include <assert.h>
#include <stdio.h>

typedef struct
{
  UT_array *list;
  char *run_alt_tag;
  is_run_alt_fn is_run_alt;
  void *callback_data;
} rofi_select_list_write_data;

void
rofi_write_list (const int fd, void *closure)
{
  rofi_select_list_write_data *p_data = (rofi_select_list_write_data *)closure;

  char **pp_item = NULL;
  while ((pp_item = (char **)utarray_next (p_data->list, pp_item)))
    {
      fd_write (fd, *pp_item);
      if (p_data->is_run_alt (*pp_item, p_data->callback_data))
        {
          fd_write (fd, p_data->run_alt_tag);
        }
      fd_write (fd, "\n");
    }
}

char *
rofi_select_list (const rofi_select_list_opts_t *p_opts, UT_array *list,
                  rofi_select_list_callbacks_t *p_callbacks,
                  void *callback_data, rofi_select_list_result_t *p_result)
{
  int selected_row = 0;

#define ROFI_SELECT_LIST_SELECTED_ROW_STR_LEN 8192
  char *selected_row_str = malloc (ROFI_SELECT_LIST_SELECTED_ROW_STR_LEN);

  UT_array *cmdv;

l_reselect:
  cmdv = NULL;
  UTARRAY_STR_NEW (cmdv);

  UTARRAY_PUSH_BACK_LITERAL (cmdv, "rofi");
  if (p_opts->common.ignorecase)
    {
      UTARRAY_PUSH_BACK_LITERAL (cmdv, "-i");
    }
  if (p_opts->common.addopts != NULL)
    {
      utarray_push_back (cmdv, &(p_opts->common.addopts));
    }
  UTARRAY_PUSH_BACK_LITERAL (cmdv, "-dmenu");
  UTARRAY_PUSH_BACK_LITERAL (cmdv, "-p");
  utarray_push_back (cmdv, &(p_opts->common.prompt));

  UTARRAY_PUSH_BACK_LITERAL (cmdv, "-sep");
  UTARRAY_PUSH_BACK_LITERAL (cmdv, "\n");

  UTARRAY_PUSH_BACK_LITERAL (cmdv, "-kb-accept-alt");
  UTARRAY_PUSH_BACK_LITERAL (cmdv, "");
  UTARRAY_PUSH_BACK_LITERAL (cmdv, "-kb-custom-1");
  UTARRAY_PUSH_BACK_LITERAL (cmdv, "Shift+Return");

  UTARRAY_PUSH_BACK_LITERAL (cmdv, "-format");
  UTARRAY_PUSH_BACK_LITERAL (cmdv, "i");

  if (p_opts->use_markup)
    {
      UTARRAY_PUSH_BACK_LITERAL (cmdv, "-markup-rows");
    }

  UTARRAY_PUSH_BACK_LITERAL (cmdv, "-selected-row");
  snprintf (selected_row_str, ROFI_SELECT_LIST_SELECTED_ROW_STR_LEN, "%d",
            selected_row);
  utarray_push_back (cmdv, &(selected_row_str));

  rofi_select_list_write_data data = {
    .list = list,
    .is_run_alt = p_callbacks->is_run_alt,
    .run_alt_tag = p_opts->run_alt_tag,
    .callback_data = callback_data,
  };

  rofi_result_t result;
  char *errmsg = rofi_run (cmdv, rofi_write_list, &data, &result);
  utarray_free (cmdv);

  if (NULL != errmsg)
    {
      utarray_free (cmdv);
      free (selected_row_str);
      return errmsg;
    }

#define ROFI_SELECT_LIST_MAGIC_EXITCODE 256
  if (NULL == p_result)
    {
      ROFI_FREE (result.stdout_text);
    }
  else
    {
      memcpy (&(p_result->base), &result, sizeof (rofi_result_t));
      if (p_result->base.exitcode != 0)
        {
          if (p_result->base.exitcode > ROFI_SELECT_LIST_MAGIC_EXITCODE)
            {
              p_result->base.alt = true;
              p_result->canceled = false;
            }
          else
            {
              p_result->base.alt = false;
              p_result->canceled = true;
            }
        }

      if (!(p_result->canceled))
        {
          unsigned int nth = atoi (p_result->base.stdout_text);
          char **pp_cmd = (char **)utarray_eltptr (list, nth);
          assert (pp_cmd != NULL);
          char *cmd = *pp_cmd;
          if (p_result->base.alt)
            {
              p_callbacks->toggle_run_alt (cmd, callback_data);
              selected_row = nth;
              rofi_free_result (&(p_result->base));
              goto l_reselect;
            }
          else
            {
              p_result->selected = ROFI_STRDUP (cmd);
            }
        }
    }

  free (selected_row_str);
  return NULL; // OK
}
