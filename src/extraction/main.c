/**************************************************************************/
/*                                                                        */
/*     SMTCoq                                                             */
/*     Copyright (C) 2011 - 2024                                          */
/*                                                                        */
/*     See file "AUTHORS" for the list of authors                         */
/*                                                                        */
/*   This file is distributed under the terms of the CeCILL-C licence     */
/*                                                                        */
/**************************************************************************/


#include <stdio.h>
#include <assert.h>

#include <caml/callback.h>


#include "c/types.h"
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

int test00b() {
  // SMT-LIB2 problem
  start_smt2();
  assertf(ffalse());

  // Proof
  CERTIF r[2] = {cfalse(), cfalse()};
  CERTIF proof = cresolution(2, r);

  // Proof checking
  return check_proof(proof);
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

int test01b() {
  // SMT-LIB2 problem
  start_smt2();
  assertf(ffalse());

  // Proof
  CERTIF r[2] = {cassert(0), cfalse()};
  CERTIF proof = cresolution(2, r);

  // Proof checking
  return check_proof(proof);
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

int test02b() {
  // SMT-LIB2 problem
  start_smt2();
  assertf(ffalse());

  // Proof
  CERTIF r[2] = {cfalse(), cassert(0)};
  CERTIF proof = cresolution(2, r);

  // Proof checking
  return check_proof(proof);
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

int test03b() {
  // SMT-LIB2 problem
  start_smt2();
  FUNSYM fa = funsym("a", 0, NULL, sort("Bool"));
  declare_fun(fa);
  FORM a = fterm(tfun(fa, NULL));
  assertf(a);
  assertf(fneg(a));

  // Proof
  CERTIF r[2] = {cassert(0), cassert(1)};
  CERTIF proof = cresolution(2, r);

  // Proof checking
  return check_proof(proof);
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

int test04b() {
  // SMT-LIB2 problem
  start_smt2();
  FUNSYM fa = funsym("a", 0, NULL, sort("Bool"));
  declare_fun(fa);
  FORM a = fterm(tfun(fa, NULL));
  assertf(a);
  assertf(fneg(a));

  // Proof
  CERTIF r[2] = {cassert(1), cassert(0)};
  CERTIF proof = cresolution(2, r);

  // Proof checking
  return check_proof(proof);
}


/** Main program **/

int main(int argc, char ** argv)
{
  // Initialize OCaml code
  caml_startup(argv);

  // Run tests
  assert(!test00());
  assert(!test00b());
  assert(test01());
  assert(test01b());
  assert(test02());
  assert(test02b());
  assert(test03());
  assert(test03b());
  assert(test04());
  assert(test04b());
  printf("All tests suceeded\n");

  return 0;
}
