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


let declare_commands ra rf acc = function
  | Smtlib2_ast.CDeclareSort (_,sym,_) -> let _ = Smt_utils.declare_sort sym in acc
  | Smtlib2_ast.CDeclareFun (_,sym, (_, arg), cod) -> let _ = Smt_utils.declare_fun sym arg cod in acc
  | Smtlib2_ast.CAssert (_, t) -> (Smt_utils.declare_assert ra rf t)::acc
  | _ -> acc


let import_smtlib2 ra rf filename =
  let chan = open_in filename in
  let lexbuf = Lexing.from_channel chan in
  let commands = Smtlib2_parse.main Smtlib2_lex.token lexbuf in
  close_in chan;
  match commands with
    | None -> []
    | Some (Smtlib2_ast.Commands (_,(_,res))) ->
      List.rev (List.fold_left (declare_commands ra rf) [] res)


(* From verit/verit.ml and trace/smtCommands.ml *)
let checker fsmt fproof =
  Smt_utils.clear_all ();
  let ra = VeritSyntax.ra in
  let rf = VeritSyntax.rf in
  let ra_quant = VeritSyntax.ra_quant in
  let rf_quant = VeritSyntax.rf_quant in
  let roots = import_smtlib2 ra rf fsmt in
  let (max_id, confl) = Verit.import_trace ra_quant rf_quant fproof None [] in
  Smt_utils.checker ra rf roots max_id confl
