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


(** SMT-LIB2 terms **)
type form =
  | FFalse


(** SMT-LIB2 commands **)
type assertions = form array


(** Certificate **)
type certif =
  | CAssert of int
  | CFalse
  | CResolution of certif list


(** The API checker **)
val checker : assertions -> certif -> bool
