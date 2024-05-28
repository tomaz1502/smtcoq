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


(* SMT-LIB2 commands *)
type assertion = Smtlib2_ast.term
type assertions = assertion array

let declare_assertion ra rf (t:assertion) =
  Smtlib2_genConstr.make_root ra rf t

let assertions = Hashtbl.create 17
let declare_assertions ra rf (a:assertions) =
  let cell = ref (-1) in
  List.rev (Array.fold_left (fun acc t ->
                incr cell;
                let aa = declare_assertion ra rf t in
                Hashtbl.add assertions !cell aa;
                aa::acc
              ) [] a)


(* Certificate as a tree *)
type certif =
  | Assert of int
  | False
  | Resolution of certif list


type 'hform rule_kind =
  | RKind of 'hform SmtCertif.clause_kind
  | RRoot of int


let process_certif =
  let add_clause id cl =
    VeritSyntax.add_clause id cl;
    if id > 1 then SmtTrace.link (VeritSyntax.get_clause (id-1)) cl
  in
  let confl_num = ref 0 in

  (* Add roots *)
  let add_roots () =
    Hashtbl.iter (fun i a ->
        let id = i+1 in
        confl_num := id;
        let cl = SmtTrace.mkRootV [a] in
        add_clause id cl
      ) assertions;
    if !confl_num < 1 then failwith "The SMT problem should have at least one assertion";
  in

  (* Process the certificate *)
  let rec process_certif c =
    let kind = match c with
        | Assert i -> RRoot (i+1)
        | False -> RKind(SmtCertif.Other SmtCertif.False)
        | Resolution l ->
           (match List.map (fun cl -> VeritSyntax.get_clause (process_certif cl)) l with
              | cl1::cl2::q ->
                 let res = {SmtCertif.rc1 = cl1; SmtCertif.rc2 = cl2; SmtCertif.rtail = q} in
                 RKind (SmtCertif.Res res)
              | _ -> failwith "Resolution should contain at least two clauses"
           )
    in
    match kind with
      | RKind k ->
         incr confl_num;
         let id = !confl_num in
         let cl = SmtTrace.mk_scertif k None in
         add_clause id cl;
         id
      | RRoot i -> i
  in

  fun c -> add_roots (); process_certif c


(* From verit.ml *)
let import_trace (c:certif) =
  let confl_num = process_certif c in
  let cfirst = ref (VeritSyntax.get_clause 1) in
  let confl = ref (VeritSyntax.get_clause confl_num) in
  SmtTrace.select !confl;
  SmtTrace.occur !confl;
  (SmtTrace.alloc !cfirst, !confl)


(* The API checker *)

let clear_all () =
  Smt_utils.clear_all ();
  Hashtbl.clear assertions


(* From verit_checker.ml (TODO: factorize) *)
let checker (smt:assertions) (proof:certif) : bool =
  clear_all ();
  let ra = VeritSyntax.ra in
  let rf = VeritSyntax.rf in
  let roots = declare_assertions ra rf smt in
  let (max_id, confl) = import_trace proof in
  Smt_utils.checker ra rf roots max_id confl
