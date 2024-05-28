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


val pp_symbol : Smtlib2_ast.symbol -> string
val parse_smt2bv : string -> bool list
val bigint_bv : Big_int.big_int -> int -> string

(* For extraction *)
val string_of_symbol : Smtlib2_ast.symbol -> string
val sort_of_string : string -> SmtBtype.btype list -> SmtBtype.btype
val sort_of_sort : Smtlib2_ast.sort -> SmtBtype.btype
val make_root :
  SmtAtom.Atom.reify_tbl -> SmtAtom.Form.reify -> Smtlib2_ast.term -> SmtAtom.Form.t

(* Import from an SMTLIB2 file *)
val import_smtlib2 :
  SmtBtype.reify_tbl ->
  SmtAtom.Op.reify_tbl ->
  SmtAtom.Atom.reify_tbl ->
  SmtAtom.Form.reify -> string -> SmtAtom.Form.t list

(* Lower level functions, to build types and terms *)
val declare_sort_from_name : SmtBtype.reify_tbl -> string -> SmtBtype.btype
val declare_fun_from_name :
  SmtBtype.reify_tbl -> SmtAtom.Op.reify_tbl -> string ->
  SmtBtype.btype list -> SmtBtype.btype -> SmtAtom.indexed_op
