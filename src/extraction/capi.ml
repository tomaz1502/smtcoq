(* Testing callbacks from C to OCaml
   see https://ocaml.org/manual/5.2/intfc.html#s:c-advexample
 *)


open Smtcoq_extr


let test01 =
  let smt =
    let sorts = [] in
    let funs = [] in
    let ass = [|Api.FFalse|] in
    (sorts, funs, ass)
  in
  let proof = Api.CResolution [Api.CAssert 0; Api.CFalse] in
  Api.checker smt proof

let dummy_checker () =
  Printf.sprintf "The test %s\n" (if test01 then "suceeded" else "did not suceed")

let _ = Callback.register "dummy_checker" dummy_checker
