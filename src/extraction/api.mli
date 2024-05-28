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


type assertion = Smtlib2_ast.term
type assertions = assertion array

type certif =
  | Assert of int
  | False
  | Resolution of certif list

val checker : assertions -> certif -> bool
