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


#ifndef _CHECKER_H_
#define _CHECKER_H_

#include <caml/mlvalues.h>

#include "types.h"


/** Sorts of first-order logic **/

SORT sort(char* s);


/** Function symbols of first-order logic **/

FUNSYM funsym(char* name, size_t arity, const SORT* domain, SORT codomain);


/** Terms of first-order logic **/

/* Variables and applied function symbols */
TERM tfun(FUNSYM fun, const TERM* args);


/** Formulas of first order logic **/

/* Terms */
FORM fterm(TERM term);

/* ⊥ */
FORM ffalse();

/* ¬ */
FORM fneg(FORM form);


/** SMT-LIB2 commands **/

SORTS sorts(size_t nb, SORT* data);
FUNSYMS funsyms(size_t nb, FUNSYM* data);
ASSERTIONS assertions(size_t nb, FORM* data);
SMTLIB2 smtlib2(SORTS s, FUNSYMS f, ASSERTIONS a);


/** Certificates **/

/* Refer to an assertion */
CERTIF cassert(size_t num);

/* Proof of the clause {(not false)} */
CERTIF cfalse();

/* Resolution chain */
CERTIF cresolution(size_t nb, const CERTIF* premisses);


/** The checker **/

int checker(SMTLIB2 smt, CERTIF proof);


#endif
