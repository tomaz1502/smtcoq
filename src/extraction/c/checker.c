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


#include <string.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/callback.h>

#include "checker.h"


/** Lists and arrays of values **/

value value_list(size_t nb, const value* elem) {
  if (nb == 0) {
    return Val_int(0);
  } else {
    value next = value_list(nb-1, elem+1);
    value res = caml_alloc(2, 0);
    Store_field(res, 0, *elem);
    Store_field(res, 1, next);
    return res;
  }
}

value value_array(size_t nb, const value* elem) {
  value res = caml_alloc(nb, 0);
  for (int i = 0; i < nb; i++) {
    Store_field(res, i, *(elem+i));
  }
}


/** Sorts of first-order logic **/

SORT sort(char* s) {
  return (caml_alloc_initialized_string(strlen(s), s));
}


/** Function symbols of first-order logic **/

FUNSYM funsym(char* name, size_t arity, const SORT* domain, SORT codomain) {
  CAMLparam1(codomain);
  CAMLlocal2(res, d);
  res = caml_alloc(3, 0);
  Store_field(res, 0, caml_alloc_initialized_string(strlen(name), name));
  d = value_list(arity, domain);
  Store_field(res, 1, d);
  Store_field(res, 2, codomain);
  FUNSYM f = {res, arity};
  CAMLreturnT(FUNSYM, f);
}


/** Terms of first-order logic **/

#define TFUN 0

/* Variables and applied function symbols */
TERM tfun(FUNSYM fun, const TERM* args) {
  value res = caml_alloc(2, TFUN);
  Store_field(res, 0, fun.fval);
  value a = value_list(fun.arity, args);
  Store_field(res, 1, a);
  return res;
}


/** Formulas of first order logic **/

#define FFALSE 0

#define FTERM 0
#define FNEG 1

/* Terms */
FORM fterm(TERM term) {
  CAMLparam1(term);
  CAMLlocal1(res);
  res = caml_alloc(1, FTERM);
  Store_field(res, 0, term);
  CAMLreturn(res);
}

/* ⊥ */
FORM ffalse() {
  value res = Val_int(0);
  return res;
}

/* ¬ */
FORM fneg(FORM form) {
  CAMLparam1(form);
  CAMLlocal1(res);
  res = caml_alloc(1, FNEG);
  Store_field(res, 0, form);
  CAMLreturn(res);
}


/** SMT-LIB2 commands **/

SORTS sorts(size_t nb, SORT* data) {
  return value_list(nb, data);
}

FUNSYMS funsyms(size_t nb, FUNSYM* data) {
  value d[nb];
  for (int i = 0; i < nb; i++) {
    d[i] = (data+i)->fval;
  }
  return value_list(nb, d);
}

ASSERTIONS assertions(size_t nb, FORM* data) {
  return value_array(nb, data);
}

ASSERTIONS assertion(FORM data) {
  CAMLparam1(data);
  CAMLlocal1(res);
  res = caml_alloc(1, 0);
  Store_field(res, 0, data);
  CAMLreturn(res);
}

SMTLIB2 smtlib2(SORTS s, FUNSYMS f, ASSERTIONS a) {
  CAMLparam3(s, f, a);
  CAMLlocal1(res);
  res = caml_alloc(3, 0);
  Store_field(res, 0, s);
  Store_field(res, 1, f);
  Store_field(res, 2, a);
  CAMLreturn(res);
}


/** Certificates **/

#define CFALSE 0

#define CASSERT 0
#define CRESOLUTION 1

/* Refer to an assertion */
CERTIF cassert(size_t num) {
  value res = caml_alloc(1, CASSERT);
  Store_field(res, 0, Val_int(num));
  return res;
}

/* Proof of the clause {(not false)} */
CERTIF cfalse() {
  return Val_int(CFALSE);
}

/* Resolution chain */
CERTIF cresolution(size_t nb, const CERTIF* premisses) {
  value res = caml_alloc(1, CRESOLUTION);
  value p = value_list(nb, premisses);
  Store_field(res, 0, p);
  return res;
}


/** The checker **/

/* TODO: try to remove [extern] */
extern int checker();

int checker(SMTLIB2 smt, CERTIF proof) {
  CAMLparam2(smt, proof);

  // Get the OCaml function
  static const value * checker_closure = NULL;
  if (checker_closure == NULL)
    checker_closure = caml_named_value("checker");

  // Call the OCaml function
  return Bool_val(caml_callback2(*checker_closure, smt, proof));
}
