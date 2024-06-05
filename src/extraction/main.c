#include <stdio.h>
#include <assert.h>

#include <caml/callback.h>


#include "c/checker.h"


/** Incorrect proof (to make sure that the checker does something) **/

int test00() {
  // SMT-LIB2 problem
  SORTS s = sorts(0, NULL);
  FUNSYMS f = funsyms(0, NULL);
  FORM ff = ffalse();
  ASSERTIONS a = assertions(1, &ff);
  SMTLIB2 smt = smtlib2(s, f, a);

  // Proof
  CERTIF r[2] = {cfalse(), cfalse()};
  CERTIF proof = cresolution(2, r);

  // Proof checking
  return checker(smt, proof);
}

/** Proofs of unsatisfiability of ⊥ **/

int test01() {
  // SMT-LIB2 problem
  SORTS s = sorts(0, NULL);
  FUNSYMS f = funsyms(0, NULL);
  FORM ff = ffalse();
  ASSERTIONS a = assertions(1, &ff);
  SMTLIB2 smt = smtlib2(s, f, a);

  // Proof
  CERTIF r[2] = {cassert(0), cfalse()};
  CERTIF proof = cresolution(2, r);

  // Proof checking
  return checker(smt, proof);
}

int test02() {
  // SMT-LIB2 problem
  SORTS s = sorts(0, NULL);
  FUNSYMS f = funsyms(0, NULL);
  FORM ff = ffalse();
  ASSERTIONS a = assertions(1, &ff);
  SMTLIB2 smt = smtlib2(s, f, a);

  // Proof
  CERTIF r[2] = {cfalse(), cassert(0)};
  CERTIF proof = cresolution(2, r);

  // Proof checking
  return checker(smt, proof);
}


/** Proofs of unsatisfiability of `a ∧ ¬a` **/

int test03() {
  // SMT-LIB2 problem
  SORTS s = sorts(0, NULL);
  FUNSYM fa = funsym("a", 0, NULL, sort("Bool"));
  FUNSYMS f = funsyms(1, &fa);
  FORM a = fterm(tfun(fa, NULL));
  FORM as[2] = {a, fneg(a)};
  ASSERTIONS ass = assertions(2, as);
  SMTLIB2 smt = smtlib2(s, f, ass);

  // Proof
  CERTIF r[2] = {cassert(0), cassert(1)};
  CERTIF proof = cresolution(2, r);

  // Proof checking
  return checker(smt, proof);
}

int test04() {
  // SMT-LIB2 problem
  SORTS s = sorts(0, NULL);
  FUNSYM fa = funsym("a", 0, NULL, sort("Bool"));
  FUNSYMS f = funsyms(1, &fa);
  FORM a = fterm(tfun(fa, NULL));
  FORM as[2] = {a, fneg(a)};
  ASSERTIONS ass = assertions(2, as);
  SMTLIB2 smt = smtlib2(s, f, ass);

  // Proof
  CERTIF r[2] = {cassert(1), cassert(0)};
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
  assert(!test00());
  assert(test01());
  assert(test02());
  assert(test03());
  assert(test04());
  printf("All tests suceeded\n");

  return 0;
}
