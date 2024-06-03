#include <stdio.h>
#include <caml/callback.h>

/* TODO: try to remove [extern] */
extern int checker();

int main(int argc, char ** argv)
{
  /* Initialize OCaml code */
  caml_startup(argv);
  /* Do some computation */
  int result = checker();
  printf("%d\n", result);
  return 0;
}
