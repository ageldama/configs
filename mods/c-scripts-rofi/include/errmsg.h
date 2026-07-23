#ifndef ERRMSG_H
#define ERRMSG_H

#include "externc.h"

#define ERRMSG_MALLOC malloc
#define ERRMSG_FREE free

EXTERN char *errmsg_fmt_alloc (const char *fmt, ...);

#define ERRMSG_WARN_IF(fp_out, p_errmsg)                                      \
  if (NULL != p_errmsg)                                                       \
    {                                                                         \
      fputs (p_errmsg, fp_out);                                               \
      fputs ("\n", fp_out);                                                   \
      ERRMSG_FREE (p_errmsg);                                                 \
    }

#define ERRMSG_FAIL_IF(fp_out, p_errmsg)                                      \
  if (NULL != p_errmsg)                                                       \
    {                                                                         \
      ERRMSG_WARN_IF (fp_out, p_errmsg);                                      \
      exit (EXIT_FAILURE);                                                    \
    }

#endif /* ERRMSG_H */
