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
  let smt = [|Api.FFalse|] in
  let proof = Api.CResolution [Api.CAssert 0; Api.CFalse] in
  Api.checker smt proof

let test2 =
  let smt = [|Api.FFalse|] in
  let proof = Api.CResolution [Api.CFalse; Api.CAssert 0] in
  Api.checker smt proof


let _ =
  assert test1;
  assert test2;
  Printf.printf "All tests suceeded\n"
