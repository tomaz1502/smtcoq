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


(** SMT-LIB2 sorts and function symbols **)
type sort = string
type funsym = string * sort list * sort


(** SMT-LIB2 terms and formulas **)
(*** Terms ***)
type term =
  | TFun of funsym * term list

(*** Formulas ***)
type form =
  | FTerm of term
  | FFalse
  | FNeg of form


(** SMT-LIB2 commands **)
(*** Sort declarations ***)
type sorts = sort list

(*** Function symbols declarations ***)
type funsyms = funsym list

(*** Assertions ***)
type assertions = form array

(*** Commands ***)
type smtlib2 = sorts * funsyms * assertions


(** Certificate **)
type node =
  | CAssert of int
  | CFalse
  | CResolution of certif list
and certif = string * node


(** The API checker **)
val checker : smtlib2 -> certif -> bool


(** Pretty-printers **)
val pp_sort : Format.formatter -> sort -> unit
val pp_funsym : Format.formatter -> funsym -> unit
val pp_term : Format.formatter -> term -> unit
val pp_form : Format.formatter -> form -> unit
