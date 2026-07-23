#include <ctype.h>
#include <string.h>
#include <wordexp.h>

#include "macrofun.h"
#include "strs.h"

char *
str_trim_both_alloc (const char *str)
{
  if (str == NULL)
    return NULL;

  while (*str && isspace ((unsigned char)*str))
    {
      str++;
    }

  size_t len = strlen (str);
  while (len > 0 && isspace ((unsigned char)str[len - 1]))
    {
      len--;
    }

  char *new_str = (char *)STRS_MALLOC (len + 1);
  if (new_str == NULL)
    {
      return NULL;
    }

  memcpy (new_str, str, len);
  new_str[len] = '\0';

  return new_str;
}

UT_array *
str_split (const char *str, const char *delim)
{
  if (str == NULL)
    {
      return NULL;
    }

  UT_array *results = NULL;
  UTARRAY_STR_NEW (results);

  str_split_into (str, delim, results);

  return results;
}

void
str_split_into (const char *str, const char *delim, UT_array *dstarray)
{
  char *saveptr;
  char *str_copy = strdup (str);

  char *token = strtok_r ((char *)str_copy, delim, &saveptr);
  while (token != NULL)
    {
      if (strlen (token) > 0)
        {
          utarray_push_back (dstarray, &token);
        }
      token = strtok_r (NULL, delim, &saveptr);
    }

  free (str_copy);
}

void
str_expand_tilde (const char *str, char *outp, const size_t outp_size)
{
  wordexp_t wexp;

  if (wordexp (str, &wexp, WRDE_NOCMD) == 0)
    {
      memset (outp, 0, outp_size);
      strncpy (outp, wexp.we_wordv[0], outp_size);
      wordfree (&wexp);
    }
}

char *
str_expand_tilde_alloc (const char *str)
{
  char *buf = STRS_MALLOC (STRS_TILDE_EXPAND_MAX);
  str_expand_tilde (str, buf, STRS_TILDE_EXPAND_MAX - 1);
  return buf;
}


int str_hello(void) { return 42; }
