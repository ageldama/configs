#ifndef STRS_H
#define STRS_H

#include "externc.h"
#include "utarray.h"

#define STRS_MALLOC malloc
#define STRS_FREE free

#define STRS_TILDE_EXPAND_MAX 8192

EXTERN char *str_trim_both_alloc (const char *str);

EXTERN void str_split_into (const char *str, const char *delim,
                            UT_array *dstarray);

EXTERN UT_array *str_split (const char *str, const char *delim);

EXTERN void str_expand_tilde (const char *str, char *outp,
                              const size_t outp_size);

EXTERN char *str_expand_tilde_alloc (const char *str);

EXTERN int str_hello(void);

#endif /* STRS_H */
