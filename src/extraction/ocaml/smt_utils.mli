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


(* SMT-LIB2 declarations *)
val declare_sort : Smtcoq_plugin.Smtlib2_ast.symbol -> Smtcoq_plugin.SmtBtype.btype
val declare_fun : Smtcoq_plugin.Smtlib2_ast.symbol ->
                  Smtcoq_plugin.Smtlib2_ast.sort list ->
                  Smtcoq_plugin.Smtlib2_ast.sort -> Smtcoq_plugin.SmtAtom.indexed_op
val declare_assert : Smtcoq_plugin.SmtAtom.Atom.reify_tbl ->
                     Smtcoq_plugin.SmtAtom.Form.reify ->
                     Smtcoq_plugin.Smtlib2_ast.term -> Smtcoq_plugin.SmtAtom.Form.t

(* Clear tables *)
val clear_all : unit -> unit

(* Checker *)
val checker : Smtcoq_plugin.SmtAtom.Atom.reify_tbl ->
              Smtcoq_plugin.SmtAtom.Form.reify ->
              Smtcoq_plugin.SmtAtom.Form.t list ->
              int ->
              Smtcoq_plugin.SmtAtom.Form.t Smtcoq_plugin.SmtCertif.clause ->
              bool
