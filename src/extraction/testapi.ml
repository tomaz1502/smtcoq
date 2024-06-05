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


(* Proofs of unsatisfiability of `False` *)
let test01 =
  let smt =
    let sorts = [] in
    let funs = [] in
    let ass = [|Api.FFalse|] in
    (sorts, funs, ass)
  in
  let proof = Api.CResolution [Api.CAssert 0; Api.CFalse] in
  Api.checker smt proof

let test02 =
  let smt =
    let sorts = [] in
    let funs = [] in
    let ass = [|Api.FFalse|] in
    (sorts, funs, ass)
  in
  let proof = Api.CResolution [Api.CFalse; Api.CAssert 0] in
  Api.checker smt proof


(* Proofs of unsatisfiability of `a ∧ ¬a` *)
let test03 =
  let smt =
    let sorts = [] in
    let fa = ("a", [], "Bool") in
    let funs = [fa] in
    let a = Api.FTerm (Api.TFun (fa, [])) in
    let ass = [|a; Api.FNeg a|] in
    (sorts, funs, ass)
  in
  let proof = Api.CResolution [Api.CAssert 0; Api.CAssert 1] in
  Api.checker smt proof

let test04 =
  let smt =
    let sorts = [] in
    let fa = ("a", [], "Bool") in
    let funs = [fa] in
    let a = Api.FTerm (Api.TFun (fa, [])) in
    let ass = [|a; Api.FNeg a|] in
    (sorts, funs, ass)
  in
  let proof = Api.CResolution [Api.CAssert 1; Api.CAssert 0] in
  Api.checker smt proof


let _ =
  assert test01;
  assert test02;
  assert test03;
  assert test04;
  Printf.printf "All tests suceeded\n"
