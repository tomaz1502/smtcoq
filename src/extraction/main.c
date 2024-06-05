#include <stdio.h>
#include <assert.h>

#include <caml/callback.h>


#include "c/checker.h"


/** Proofs of unsatisfiability of ⊥ **/
int test01() {
  // SMT-LIB2 problem
  SORTS s = sorts(0, NULL);
  FUNSYMS f = funsyms(0, NULL);
  FORM ff = ffalse();
  ASSERTIONS a = assertion(ff);
  /* FORM foo[1] = {ff}; */
  /* ASSERTIONS a = assertions(1, foo); */
  /* ASSERTIONS a = assertions(1, &ff); */
  SMTLIB2 smt = smtlib2(s, f, a);

  // Proof
  CERTIF r[2] = {cassert(0), cfalse()};
  CERTIF proof = cresolution(2, r);

  // Proof checking
  return checker(smt, proof);
}


/** Main program **/

int main(int argc, char ** argv)
{
  // Initialize OCaml code
  caml_startup(argv);

  // Run tests
  assert(test01());
  printf("All tests suceeded\n");

  return 0;
}
