#include "argp.h"
#include "macrofun.h"
#include "strs.h"
#include "utarray.h"
#include <getopt.h>
#include <sys/stat.h>
#include <unistd.h>

#define ARGP_FREE_AND_NULLIFY_UNLESS_NULL(place, free_fn)                     \
  FREE_AND_NULLIFY_UNLESS_NULL (place, free_fn)

#define ARGP_FREE_AND_NULLIFY_UNLESS_NULL_1(place)                            \
  FREE_AND_NULLIFY_UNLESS_NULL (place, ARGP_FREE)

#define ARGP_TOGGLE TOGGLEF

#define ARGP_FREE_AND_STRDUP(place, val)                                      \
  FREE_AND_STRDUP (place, val, ARGP_FREE, strdup)

void
argp_free_internal (argp_t *p_argp)
{
  if (NULL == p_argp)
    return;

  if (NULL != p_argp->__script_dirs_cache)
    {
      utarray_free (p_argp->__script_dirs_cache);
      p_argp->__script_dirs_cache = NULL;
    }

  ARGP_FREE_AND_NULLIFY_UNLESS_NULL_1 (p_argp->script_dirs);
  ARGP_FREE_AND_NULLIFY_UNLESS_NULL_1 (p_argp->db_file);
  ARGP_FREE_AND_NULLIFY_UNLESS_NULL_1 (p_argp->term_command);
  ARGP_FREE_AND_NULLIFY_UNLESS_NULL_1 (p_argp->exec_wrapper);
  ARGP_FREE_AND_NULLIFY_UNLESS_NULL_1 (p_argp->file_regex);
  ARGP_FREE_AND_NULLIFY_UNLESS_NULL_1 (p_argp->no_db_flag_file);
  ARGP_FREE_AND_NULLIFY_UNLESS_NULL_1 (p_argp->run_alt_tag);
}

void
argp_init (argp_t *p_argp)
{
  memset (p_argp, 0, sizeof (argp_t));

  p_argp->print = false;
  p_argp->save = false;
  p_argp->execute = false;

  p_argp->script_dirs = ARGP_STRDUP (SCRIPT_ROFI_SCRIPT_DIRS);
  p_argp->__script_dirs_cache = NULL;

  p_argp->db_file = str_expand_tilde_alloc (SCRIPT_ROFI_DB_FILE);
  p_argp->term_command = ARGP_STRDUP (SCRIPT_ROFI_XTERM_COMMAND);

  p_argp->dump_and_exit = false;

  p_argp->exec_wrapper = NULL;
  p_argp->file_regex = NULL;

  p_argp->ignorecase = true;

  p_argp->no_db_flag_file = str_expand_tilde_alloc (SCRIPT_ROFI_NO_DB_FILE);
  p_argp->run_alt_tag = ARGP_STRDUP (SCRIPT_ROFI_RUN_ALT_TAG);

  p_argp->use_markup = true;
}

void
argp_parse (int argc, char *argv[], argp_t *p_argp)
{
  while (1)
    {
      int option_index = 0;
      static struct option long_options[]
          = { { "help", no_argument, 0, 'h' },
              { "print", no_argument, 0, 'p' },
              { "save", no_argument, 0, 's' },
              { "execute", no_argument, 0, 'e' },
              { "dump-and-exit", no_argument, 0, 'P' },
              { "script-dirs", required_argument, 0, 'S' },
              { "db-file", required_argument, 0, 'D' },
              { "term-command", required_argument, 0, 'T' },
              { "exec-wrapper", required_argument, 0, 'W' },
              { "file-regex", required_argument, 0, '/' },
              { "run-alt-tag", required_argument, 0, 'A' },
              { "markup", no_argument, 0, 'm' },
              { "ignorecase", no_argument, 0, 'i' },
              { 0, 0, 0, 0 } };
      static char *opts = "?hpsePS:D:T:W:/:iA:m";

      int opt = getopt_long (argc, argv, opts, long_options, &option_index);
      if (-1 == opt)
        break;

      switch (opt)
        {
        case 'p':
          ARGP_TOGGLE (p_argp->print);
          break;

        case 's':
          ARGP_TOGGLE (p_argp->save);
          break;

        case 'e':
          ARGP_TOGGLE (p_argp->execute);
          break;

        case 'P':
          ARGP_TOGGLE (p_argp->dump_and_exit);
          break;

        case 'S':
          argp_set_script_dirs (p_argp, optarg);
          break;

        case 'D':
          ARGP_FREE_AND_STRDUP (p_argp->db_file, optarg);
          break;

        case 'T':
          ARGP_FREE_AND_STRDUP (p_argp->term_command, optarg);
          break;

        case 'W':
          ARGP_FREE_AND_STRDUP (p_argp->exec_wrapper, optarg);
          break;

        case '/':
          ARGP_FREE_AND_STRDUP (p_argp->file_regex, optarg);
          break;

        case 'A':
          ARGP_FREE_AND_STRDUP (p_argp->run_alt_tag, optarg);
          break;

        case 'm':
          ARGP_TOGGLE (p_argp->use_markup);
          break;

        case 'i':
          ARGP_TOGGLE (p_argp->ignorecase);
          break;

        case '?':
        case 'h':
        default:
          argp_print_usage (p_argp, stderr);
          exit (EXIT_FAILURE);
          break;
        }
    }
}

void
argp_print_usage (argp_t *p_argp, FILE *fp)
{
#define P(fmt, ...) fprintf (fp, fmt __VA_OPT__ (, ) __VA_ARGS__)
  P ("It asks to select a script within SCRIPT_DIRS and execute "
     "it.\n", );
  P ("\n", );
  P ("(NO_DB_FLAG_FILE:\t%s)\n", p_argp->no_db_flag_file);
  P ("\n", );
  P ("-p | --print : print selection (%d)\n", p_argp->print);
  P ("-s | --save  : save selection (%d)\n", p_argp->save);
  P ("-e | --execute : execute selection (%d)\n", p_argp->execute);

  P ("-S SCRIPT_DIRS | --script-dirs SCRIPT_DIRS (':'-separated list)\n", );
  UT_array *script_dirs = argp_get_script_dirs_owned (p_argp);
  char **pp_script_dir = NULL;
  while (
      script_dirs != NULL
      && (pp_script_dir = (char **)utarray_next (script_dirs, pp_script_dir)))
    {
      P ("\t%s\n", *pp_script_dir);
    }

  P ("-D HIST_DB_FILE   :\t %s\n", p_argp->db_file);
  P ("-T XTERM_COMMAND  :\t %s\n", p_argp->term_command);
  P ("-P : Dump stored DB and exit (%d)\n", p_argp->dump_and_exit);
  P ("-W : Execute wrapper (like 'wine') (%s)\n", p_argp->exec_wrapper);
  P ("-A : 'Run in terminal' tag string (%s)\n", p_argp->run_alt_tag);
  P ("-m : Apply markup on tag string (%d)\n", p_argp->use_markup);

  P ("-/ REGEX | --file-regex REGEX : filename matching regex (%s)\n",
     p_argp->file_regex);

  P ("-i | --ignorecase \t: ignorecase (%d)\n", p_argp->ignorecase);
  P ("\n", );
  P ("Exiting.\n", );
#undef P
}

UT_array *
argp_get_script_dirs_owned (argp_t *p_argp)
{
  if (NULL == p_argp || NULL == p_argp->script_dirs)
    {
      return NULL;
    }

  if (NULL != p_argp->__script_dirs_cache)
    {
      return p_argp->__script_dirs_cache;
    }

  UT_array *splitted = str_split (p_argp->script_dirs, ":");
  UT_array *expanded = NULL;
  UTARRAY_STR_NEW (expanded);

  char **pp_script_dir = NULL;
  while ((pp_script_dir = (char **)utarray_next (splitted, pp_script_dir)))
    {
      char *exp = str_expand_tilde_alloc (*pp_script_dir);
      utarray_push_back (expanded, &exp);
      STRS_FREE (exp);
    }

  utarray_free (splitted);
  p_argp->__script_dirs_cache = expanded;
  return p_argp->__script_dirs_cache;
}

void
argp_set_script_dirs (argp_t *p_argp, char *script_dirs)
{
  if (NULL == p_argp)
    return;

  ARGP_FREE_AND_NULLIFY_UNLESS_NULL_1 (p_argp->script_dirs);
  ARGP_FREE_AND_NULLIFY_UNLESS_NULL (p_argp->__script_dirs_cache,
                                     utarray_free);

  p_argp->script_dirs = ARGP_STRDUP (script_dirs);
}

bool
argp_load_db_allowed (argp_t *p_argp)
{
  if (NULL == p_argp || NULL == p_argp->db_file)
    return false;

  struct stat st;
  if (stat (p_argp->no_db_flag_file, &st) == 0)
    {
      return false;
    }

  return true;
}

bool
argp_save_db_allowed (argp_t *p_argp)
{
  bool load = argp_load_db_allowed (p_argp);
  return load && p_argp->save;
}
