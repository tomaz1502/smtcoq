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


open Smtcoq_extr


(* Easy certificates: proof of unsatisfiability of `False` *)
let test1 =
  let smt =
    let pos = (Lexing.dummy_pos, Lexing.dummy_pos) in
    let f = Smtcoq_plugin.Smtlib2_ast.Symbol(pos, "false") in
    let s = Smtcoq_plugin.Smtlib2_ast.IdSymbol(pos, f) in
    let t = Smtcoq_plugin.Smtlib2_ast.QualIdentifierId(pos, s) in
    [|Smtcoq_plugin.Smtlib2_ast.TermQualIdentifier(pos, t)|]
  in
  let proof = Api.Resolution [Api.Assert 0; Api.False] in
  Api.checker smt proof

let test2 =
  let smt =
    let pos = (Lexing.dummy_pos, Lexing.dummy_pos) in
    let f = Smtcoq_plugin.Smtlib2_ast.Symbol(pos, "false") in
    let s = Smtcoq_plugin.Smtlib2_ast.IdSymbol(pos, f) in
    let t = Smtcoq_plugin.Smtlib2_ast.QualIdentifierId(pos, s) in
    [|Smtcoq_plugin.Smtlib2_ast.TermQualIdentifier(pos, t)|]
  in
  let proof = Api.Resolution [Api.False; Api.Assert 0] in
  Api.checker smt proof


let _ =
  assert test1;
  assert test2;
  Printf.printf "All tests suceeded\n"
