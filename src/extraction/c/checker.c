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


/* Terms */

/* enum termc {TFUN}; */

/* struct term { */
/*   enum termc node; */
/*   struct data { */
/*     char* name; */
/*     uint32_t arity; */
/*     struct term* args; */
/*   } data; */
/* }; */

/* struct term * tfun(char* name, uint32_t arity; struct term* args) { */

/* } */


value ffalse() {
  value res = Val_int(0);
  return res;
}


/* value tfun(char* name, uint32_t arity; value* args) { */

/* } */
