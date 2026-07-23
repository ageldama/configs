#include "errmsg.h"
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *
errmsg_fmt_alloc (const char *fmt, ...)
{
  char *errmsg = NULL;
  va_list ap;

  va_start (ap, fmt);
  int errmsg_len = vasprintf (&errmsg, fmt, ap);
  va_end (ap);

  if (errmsg_len < 0)
    {
      errmsg = strdup ("[ERROR] INTERNAL ERROR");
    }

  char *errmsg_copy = ERRMSG_MALLOC (errmsg_len + 1);
  errmsg_copy[errmsg_len] = '\0';
  strncpy (errmsg_copy, errmsg, errmsg_len);
  free (errmsg);

  return errmsg_copy;
}
