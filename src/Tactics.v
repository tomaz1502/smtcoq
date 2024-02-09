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


From Trakt Require Import Trakt.
Require Import Conversion.
Require Import Uint63 List PArray Bool ZArith.
Require Import SMTCoq.State SMTCoq.SMT_terms SMTCoq.Trace SMT_classes_instances QInst.
From Ltac2 Require Import Ltac2.

Declare ML Module "coq-smtcoq.smtcoq".

(** A printer for testing Ltac2 functions returning hypothesis *)

Ltac2 rec hyps_printer (h : (ident * constr option * constr) list) 
:=
match h with
| [] => ()
| x :: xs => match x with
            | (id, opt, cstr) => 
let () := Message.print (Message.concat (Message.of_ident id)
                                        (Message.concat (Message.of_string " : ")
                                                        (Message.of_constr cstr))) 
in hyps_printer xs
end 
end.


(* Collect all the hypotheses from the context *)

Ltac2 get_hyps_aux () :=
let h := Control.hyps () in
List.filter (fun x => match x with
                    | (id, opt, c) => let ty := Constr.type c in Constr.equal ty '(Prop)
                    end) h.

Ltac2 get_hyps_ltac2 () :=
let hs := get_hyps_aux () in
match hs with
| [] => '(@None nat)
| x :: xs => 
    match x with
    | (id, opt, c) => 
    let h := Control.hyp id in
    let rec tac_aux xs acc :=
      match xs with
      | y :: ys => 
        match y with
        | (id', opt', c') => 
        let h1 := Control.hyp id' in let res := tac_aux ys acc in '($h1, $res)
        end
      | [] => acc
      end in let res := tac_aux xs h in '(Some ($res))
  end
end. 

Ltac2 get_hyps_cont_ltac1 (tac : Ltac1.t -> unit) := 
Control.enter (fun () =>
let hs := Ltac1.of_constr (get_hyps_ltac2 ()) in
tac hs).

(*
Section Test.
Variable A : Type.
Hypothesis H1 : forall a:A, a = a.
Variable n : Z.
Hypothesis H2 : n = 17%Z.

Goal True.
Proof.
let hs := get_hyps_aux () in hyps_printer hs. 
let hs := get_hyps_ltac2 () in Message.print (Message.of_constr hs).
get_hyps_cont_ltac1 ltac1:(H |- idtac H).
Abort.

Goal True.
Proof. clear A H1 n H2.
let hs := get_hyps_aux () in hyps_printer hs. 
let hs := get_hyps () in Message.print (Message.of_constr hs).
Abort.
End Test.  *)



(** Tactics in bool *)

Tactic Notation "verit_bool_base_auto" constr(h) := verit_bool_base h; try (exact _).
Tactic Notation "verit_bool_no_check_base_auto" constr(h) := verit_bool_no_check_base h; try (exact _).

Tactic Notation "verit_bool" constr(h) :=
  let tac :=
  ltac2:(h |- get_hyps_cont_ltac1
  (ltac1:(h hs |- 
  match hs with
  | Some ?hs => verit_bool_base_auto (Some (h, hs))
  | None => verit_bool_base_auto (Some h)
  end;
  vauto) h)) in tac h.

Tactic Notation "verit_bool" :=
  ltac2:(get_hyps_cont_ltac1 ltac1:(hs |- verit_bool_base_auto hs; vauto)).

Tactic Notation "verit_bool_no_check" constr(h) :=
  let tac :=
  ltac2:(h |- get_hyps_cont_ltac1 (ltac1:(h hs |-
  match hs with
  | Some ?hs => verit_bool_no_check_base_auto (Some (h, hs))
  | None => verit_bool_no_check_base_auto (Some h)
  end;
  vauto) h)) in tac h.

Tactic Notation "verit_bool_no_check" :=
  ltac2:(get_hyps_cont_ltac1 ltac1:(hs |- verit_bool_no_check_base_auto hs; vauto)).


(** Tactics in bool with timeout **)

Tactic Notation "verit_bool_base_auto_timeout" constr(h) int_or_var(timeout) := verit_bool_base_timeout h timeout; auto with typeclass_instances.
Tactic Notation "verit_bool_no_check_base_auto_timeout" constr(h) int_or_var(timeout) := verit_bool_no_check_base_timeout h timeout; auto with typeclass_instances.

Tactic Notation "verit_bool_timeout" constr(h) int_or_var(timeout) :=
  let tac :=
  ltac2:(h timeout |- get_hyps_cont_ltac1
  (ltac1:(h timeout hs |- 
  match hs with
  | Some ?hs => verit_bool_base_auto_timeout (Some (h, hs)) timeout
  | None => verit_bool_base_auto_timeout (Some h) timeout
  end;
  vauto) h timeout)) in tac h timeout.

Tactic Notation "verit_bool_timeout" int_or_var(timeout) :=
  let tac :=
  ltac2:(timeout |- get_hyps_cont_ltac1 (ltac1:(timeout hs |- verit_bool_base_auto_timeout hs timeout; vauto) timeout))
  in tac timeout.

Tactic Notation "verit_bool_no_check_timeout" constr(h) int_or_var (timeout) :=
  let tac :=
  ltac2:(h timeout |- get_hyps_cont_ltac1
  (ltac1:(h timeout hs |- 
  match hs with
  | Some ?hs => verit_bool_no_check_base_auto_timeout (Some (h, hs)) timeout
  | None => verit_bool_no_check_base_auto_timeout (Some h) timeout
  end;
  vauto) h timeout)) in tac h timeout.

Tactic Notation "verit_bool_no_check_timeout"   int_or_var(timeout)        :=
  let tac :=
  ltac2:(timeout |- get_hyps_cont_ltac1 (ltac1:(timeout hs |- verit_bool_no_check_base_auto_timeout hs timeout; vauto) timeout))
  in tac timeout.
  

(** Tactics in Prop **)

Ltac zchaff          := trakt Z bool; Tactics.zchaff_bool.
Ltac zchaff_no_check := trakt Z bool; Tactics.zchaff_bool_no_check.


Ltac2 preprocess1 hs := 
   add_compdecs () >
    [ .. |
    remove_compdec_hyps_option hs;
    let cpds := collect_compdecs () in
    let rels := generate_rels cpds in
    Control.enter (fun () => trakt1 rels (Option.map (List.map (fun (id, _, _) => id)) hs))].

Tactic Notation "verit" constr(global) :=
  let tac :=
  ltac2:(h |- intros; unfold is_true in *;
  let l := Option.get (Ltac1.to_list h) in
  let l' := List.map (fun x => Option.get (Ltac1.to_constr x)) l in
  let hs := pose_hyps l' in
  preprocess1 (Some hs) >
  [ .. |
    ltac1:(let Hs' := intros_names in
    let tac' := ltac2:(hs' |- 
    let hs'' := Ltac1.to_list hs' in
    let hs''' := 
    match hs'' with
      | None => None 
      | Some l => Some (List.map (fun x => Option.get (Ltac1.to_ident x)) l)
    end in
      preprocess2 hs''') in tac' Hs';
    verit_bool_base_auto Hs';
    QInst.vauto)
  ]) in tac global.

Tactic Notation "verit" :=
  ltac2:(intros; unfold is_true in *;
  let hs := pose_hyps [] in 
  preprocess1 (Some hs) >
  [ .. |
    ltac1:(let Hs' := intros_names in 
    let tac' := ltac2:(hs' |- 
    let hs'' := Ltac1.to_list hs' in
    let hs''' := 
    match hs'' with
      | None => None 
      | Some l => Some (List.map (fun x => Option.get (Ltac1.to_ident x)) l)
    end in 
      preprocess2 hs''') in tac' Hs';
    verit_bool_base_auto Hs';
    QInst.vauto)
  ]).

Tactic Notation "verit_no_check" constr(global) :=
  let tac :=
  ltac2:(h |- intros; unfold is_true in *;
  let l := Option.get (Ltac1.to_list h) in
  let l' := List.map (fun x => Option.get (Ltac1.to_constr x)) l in
  let hs := pose_hyps l' in
  preprocess1 (Some hs) >
  [ .. |
    ltac1:(let Hs' := intros_names in
    let tac' := ltac2:(hs' |-
    Control.enter (fun () =>
    let hs'' := Option.get (Ltac1.to_list hs') in
    let hs''' := List.map (fun x => Option.get (Ltac1.to_ident x)) hs'' in
      preprocess2 (Some hs'''))) in tac' Hs';
    verit_bool_no_check_base_auto Hs';
    QInst.vauto)
  ]) in tac global.

Tactic Notation "verit_no_check" :=
  ltac2:(intros; unfold is_true in *;
  let hs := Control.hyps () in
  preprocess1 (Some hs) >
  [ .. |
    ltac1:(let Hs' := intros_names in
    let tac' := ltac2:(hs' |- 
    let hs'' := Option.get (Ltac1.to_list hs') in
    let hs''' := List.map (fun x => Option.get (Ltac1.to_ident x)) hs'' in
      preprocess2 (Some hs''')) in tac' Hs';
    verit_bool_no_check_base_auto Hs';
    QInst.vauto)
  ]).

Tactic Notation "verit_timeout" uconstr_list_sep(global, ",") int_or_var(timeout) :=
  let tac :=
  ltac2:(h n |- intros; unfold is_true in *;
  let l := Option.get (Ltac1.to_list h) in
  let l' := List.map (fun x => Option.get (Ltac1.to_constr x)) l in
  let hs := pose_hyps l' in
  preprocess1 (Some hs) >
  [ .. |
    ltac1:(n |- let Hs' := intros_names in
    let tac' := ltac2:(hs' |- 
    let hs'' := Option.get (Ltac1.to_list hs') in
    let hs''' := List.map (fun x => Option.get (Ltac1.to_ident x)) hs'' in
      preprocess2 (Some hs''')) in tac' Hs';
    verit_bool_base_auto_timeout Hs' n;
    QInst.vauto) n
  ]) in tac global timeout.

Tactic Notation "verit_timeout"  int_or_var(timeout) :=
  let tac := 
  ltac2:(n |- intros; unfold is_true in *;
  let hs := Control.hyps () in
  preprocess1 (Some hs) >
  [ .. |
    ltac1:(n |- let Hs' := intros_names in
    let tac' := ltac2:(hs' |- 
    let hs'' := Option.get (Ltac1.to_list hs') in
    let hs''' := List.map (fun x => Option.get (Ltac1.to_ident x)) hs'' in
      preprocess2 (Some hs''')) in tac' Hs';
    verit_bool_base_auto_timeout Hs' n;
    QInst.vauto) n
  ]) in tac timeout.

Tactic Notation "verit_no_check_timeout" uconstr_list_sep(global, ",") int_or_var(timeout) :=
  let tac :=
  ltac2:(h n |- intros; unfold is_true in *;
  let l := Option.get (Ltac1.to_list h) in
  let l' := List.map (fun x => Option.get (Ltac1.to_constr x)) l in
  let hs := pose_hyps l' in
  preprocess1 (Some hs) >
  [ .. |
    ltac1:(n |- let Hs' := intros_names in
    let tac' := ltac2:(hs' |- 
    let hs'' := Option.get (Ltac1.to_list hs') in
    let hs''' := List.map (fun x => Option.get (Ltac1.to_ident x)) hs'' in
      preprocess2 (Some hs''')) in tac' Hs';
    verit_bool_no_check_base_auto_timeout Hs' n;
    QInst.vauto) n
  ]) in tac global timeout.

Tactic Notation "verit_no_check_timeout"  int_or_var(timeout) :=
  let tac := 
  ltac2:(n |- intros; unfold is_true in *;
  let hs := Control.hyps () in
  preprocess1 (Some hs) >
  [ .. |
    ltac1:(n |- let Hs' := intros_names in
    let tac' := ltac2:(hs' |- 
    let hs'' := Option.get (Ltac1.to_list hs') in
    let hs''' := List.map (fun x => Option.get (Ltac1.to_ident x)) hs'' in
      preprocess2 (Some hs''')) in tac' Hs';
    verit_bool_no_check_base_auto_timeout Hs' n;
    QInst.vauto) n
  ]) in tac timeout.

Ltac cvc4            := trakt Z bool; [ .. | cvc4_bool ].
Ltac cvc4_no_check   := trakt Z bool; [ .. | cvc4_bool_no_check ].

Tactic Notation "smt" constr(h) := intros; try verit h; cvc4; try verit h.
Tactic Notation "smt"           := intros; try verit  ; cvc4; try verit.
Tactic Notation "smt_no_check" constr(h) :=
  intros; try verit_no_check h; cvc4_no_check; try verit_no_check h.
Tactic Notation "smt_no_check"           :=
  intros; try verit_no_check  ; cvc4_no_check; try verit_no_check.

Lemma fun_const2goals :
  forall f (g : Z -> Z -> bool),
    (forall x, g (f x) 2%Z) -> (g (f 3) 2 /\ g (f 3) 2)%Z.
Proof using. ltac1:(intros; split; verit). Qed.

(* 
   Local Variables:
   coq-load-path: ((rec "." "SMTCoq"))
   End: 
*)
