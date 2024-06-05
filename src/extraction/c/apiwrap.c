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


#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/callback.h>


#include "checker.h"


int checker() {
  // Declaration of local variables of type value
  value nil, ff, sorts, funs, ass, smt, cassert, cfalse, reso, resox, proof, res;

  /* nil: first constant constructor of type list */
  nil = Val_int(0);

  /* FFalse: first constant constructor of type form */
  ff = ffalse();

  sorts = nil;
  funs = nil;

  /* Array containing FFalse */
  ass = caml_alloc(1, 0);
  Store_field(ass, 0, ff);

  /* SMT problem: tuple of sorts, funs and ass */
  smt = caml_alloc(3, 0);
  Store_field(smt, 0, sorts);
  Store_field(smt, 1, funs);
  Store_field(smt, 2, ass);

  /* CAssert 0: first non-constant constructor of type certif */
  cassert = caml_alloc(1, 0);
  Store_field(cassert, 0, Val_int(0));

  /* CFalse: first constant constructor of type certif */
  cfalse = Val_int(0);

  /* [CAssert 0; CFalse] */
  resox = caml_alloc(2, 0);
  Store_field(resox, 0, cfalse);
  Store_field(resox, 1, nil);
  reso = caml_alloc(2, 0);
  Store_field(reso, 0, cassert);
  Store_field(reso, 1, resox);

  /* CResolution [CAssert 0; CFalse] */
  proof = caml_alloc(1, 1);
  Store_field(proof, 0, reso);

  // Get the OCaml function
  static const value * checker_closure = NULL;
  if (checker_closure == NULL)
    checker_closure = caml_named_value("checker");

  // Call the OCaml function
  return Bool_val(caml_callback2(*checker_closure, smt, proof));
}
