#include <stdio.h>
#include <caml/callback.h>

/* TODO: try to remove [extern] */
extern char* dummy_checker();

int main(int argc, char ** argv)
{
  char* result;

  /* Initialize OCaml code */
  caml_startup(argv);
  /* /\* Do some computation *\/ */
  result = dummy_checker();
  printf("%s\n", result);
  return 0;
}
