#include "macrofun.h"
#include "rofi.h"
#include "utarray.h"

char *
rofi_show_error (const char *message)
{
  UT_array *cmdv = NULL;
  UTARRAY_STR_NEW (cmdv);

  char *cmdv_[] = { "rofi", "-e", (char *)message };
  utarray_push_back (cmdv, &cmdv_[0]);
  utarray_push_back (cmdv, &cmdv_[1]);
  utarray_push_back (cmdv, &cmdv_[2]);

  rofi_result_t result;
  char *errmsg = rofi_run (cmdv, rofi_write_nothing, NULL, &result);
  if (NULL != errmsg)
    {
      utarray_free (cmdv);
      return errmsg;
    }

  ROFI_FREE (result.stdout_text);
  utarray_free (cmdv);

  return NULL; // OK
}

void
rofi_write_nothing (const int fd, void *closure)
{
  (void)fd;
  (void)closure;
}
