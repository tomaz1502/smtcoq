(**************************************************************************)
(*                                                                        *)
(*     SMTCoq                                                             *)
(*     Copyright (C) 2011 - 2022                                          *)
(*                                                                        *)
(*     See file "AUTHORS" for the list of authors                         *)
(*                                                                        *)
(*   This file is distributed under the terms of the CeCILL-C licence     *)
(*                                                                        *)
(**************************************************************************)


open Smtcoq_plugin


(** SMT-LIB2 terms and formulas **)
(*** Terms ***)
type term =
  | TFun of string * term list

(*** Formulas ***)
type form =
  | FTerm of term
  | FFalse
  | FNeg of form


(** SMT-LIB2 commands **)
(*** Sort declarations ***)
type sort = string
type sorts = sort list

(*** Function symbols declarations ***)
type funsym = string * sort list * sort
type funsyms = funsym list

(*** Assertions ***)
type assertions = form array

(*** Commands ***)
type smtlib2 = sorts * funsyms * assertions


(** Certificate **)
type certif =
  | CAssert of int
  | CFalse
  | CResolution of certif list


(** The API checker **)
val checker : smtlib2 -> certif -> bool
