#ifndef MACROFUN_H
#define MACROFUN_H

#define CAT__(a, b) a##b
#define CAT(a, b) CAT__ (a, b)
#define GENSYM(prefix) CAT (prefix, __LINE__)

#define UTARRAY_PUSH_BACK_LITERAL(arr, val)                                   \
  char *GENSYM (s) = (val);                                                   \
  utarray_push_back (arr, &GENSYM (s))

#define TOGGLEF(place) place = !(place)

#define FREE_AND_NULLFIFY(place, free_fn)                                     \
  do                                                                          \
    {                                                                         \
      free_fn (place);                                                        \
      place = NULL;                                                           \
    }                                                                         \
  while (0)

#define FREE_AND_NULLIFY_UNLESS_NULL(place, free_fn)                          \
  if (NULL != place)                                                          \
  FREE_AND_NULLFIFY (place, free_fn)

#define FREE_AND_STRDUP(place, val, free_fn, strdup_fn)                       \
  do                                                                          \
    {                                                                         \
      FREE_AND_NULLIFY_UNLESS_NULL (place, free_fn);                          \
      place = strdup_fn (val);                                                \
    }                                                                         \
  while (0)

#define UTARRAY_STR_NEW(utarray_ptr) utarray_new (utarray_ptr, &ut_str_icd)

#endif /* MACROFUN_H */
