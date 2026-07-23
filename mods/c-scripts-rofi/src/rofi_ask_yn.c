#include "macrofun.h"
#include "rofi.h"
#include "utarray.h"
#include <stdio.h>

typedef struct
{
  char *label_y;
  char *label_n;
} rofi_ask_yn_write_data;

void
rofi_write_labels_yn (const int fd, void *closure)
{
  rofi_ask_yn_write_data *p_data = (rofi_ask_yn_write_data *)closure;
  fd_write_sep (fd, p_data->label_y, '\n');
  fd_write_sep (fd, p_data->label_n, '\n');
}

char *
rofi_ask_yn (const rofi_ask_yn_opts_t *yn_opts, rofi_ask_yn_result_t *p_result)
{
  UT_array *cmdv = NULL;
  UTARRAY_STR_NEW (cmdv);

  UTARRAY_PUSH_BACK_LITERAL (cmdv, "rofi");
  if (yn_opts->common.ignorecase)
    {
      UTARRAY_PUSH_BACK_LITERAL (cmdv, "-i");
    }
  if (yn_opts->common.addopts != NULL)
    {
      utarray_push_back (cmdv, &(yn_opts->common.addopts));
    }
  UTARRAY_PUSH_BACK_LITERAL (cmdv, "-dmenu");
  UTARRAY_PUSH_BACK_LITERAL (cmdv, "-p");
  utarray_push_back (cmdv, &(yn_opts->common.prompt));

  UTARRAY_PUSH_BACK_LITERAL (cmdv, "-sep");
  UTARRAY_PUSH_BACK_LITERAL (cmdv, "\n");
  UTARRAY_PUSH_BACK_LITERAL (cmdv, "-format");
  UTARRAY_PUSH_BACK_LITERAL (cmdv, "i");

  rofi_ask_yn_write_data data = {
    .label_y = yn_opts->label_y,
    .label_n = yn_opts->label_n,
  };

  rofi_result_t result;
  char *errmsg = rofi_run (cmdv, rofi_write_labels_yn, &data, &result);
  if (NULL != errmsg)
    {
      utarray_free (cmdv);
      return errmsg;
    }

  if (NULL == p_result)
    {
      ROFI_FREE (result.stdout_text);
    }
  else
    {
      memcpy (&(p_result->base), &result, sizeof (rofi_result_t));
      if (p_result->base.exitcode != 0)
        {
          p_result->canceled = true;
        }
      else
        {
          p_result->canceled = false;

          int yn_idx = atoi (p_result->base.stdout_text);
          p_result->answer_yes = yn_idx == 0;
        }
    }
  utarray_free (cmdv);

  return NULL; // OK
}
