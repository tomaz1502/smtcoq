(* Testing callbacks from C to OCaml
   see https://ocaml.org/manual/4.09/intfc.html#sec426
 *)


open Smtcoq_extr


(* let test01 = *)
(*   let smt = *)
(*     let sorts = [] in *)
(*     let funs = [] in *)
(*     let ass = [|Api.FFalse|] in *)
(*     (sorts, funs, ass) *)
(*   in *)
(*   let proof = Api.CResolution [Api.CAssert 0; Api.CFalse] in *)
(*   Api.checker smt proof *)

(* let dummy_checker () = *)
(*   Printf.sprintf "The test %s\n" (if test01 then "suceeded" else "did not suceed") *)

let _ = Callback.register "checker" Api.checker
