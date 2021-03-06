Require Export Monad.

Inductive Either (X : Type) (Y : Type): Type :=
  | Left : X -> Either X Y
  | Right : Y -> Either X Y.

Definition Either_map {E X Y} (f : X -> Y) (x : Either E X) : Either E Y :=
  match x with
  | Left e => Left E Y e
  | Right x' => Right E Y (f x')
  end.

Definition Either_apply {E X Y} (f : Either E (X -> Y)) (x : Either E X)
  : Either E Y :=
  match f with
  | Left e => Left E Y e
  | Right f' => match x with
    | Left e => Left E Y e
    | Right x' => Right E Y (f' x')
    end
  end.

Definition Either_join {E X} (x : Either E (Either E X)) : Either E X :=
  match x with
  | Left e => Left E X e
  | Right (Left e) => Left E X e
  | Right (Right x') => Right E X x'
  end.

Global Instance Either_Functor {E} : Functor (Either E) :=
{ fmap := @Either_map E
}.
Proof.
  - (* fun_identity *)
    intros. ext_eq. compute. destruct x; reflexivity.
  - (* fun_composition *)
    intros. ext_eq. compute. destruct x; reflexivity.
Defined.

Global Instance Either_Applicative {E} : Applicative (Either E) :=
{ is_functor := Either_Functor
; eta := Right E
; apply := @Either_apply E
}.
Proof.
  - (* app_identity *)
    intros. ext_eq. compute. destruct x; reflexivity.
  - (* app_composition *)
    intros. compute.
    destruct u.
      destruct v; reflexivity.
      destruct v. reflexivity. destruct w; reflexivity.
  - (* app_homomorphism *)
    intros. compute. reflexivity.
  - (* app_interchange *)
    intros. compute. destruct u; reflexivity.
  - (* app_fmap_unit *)
    intros. ext_eq. compute. destruct x; reflexivity.
Defined.

Global Instance Either_Monad {E} : Monad (Either E) :=
{ is_applicative := Either_Applicative
; mu := @Either_join E
}.
Proof.
  - (* monad_law_1 *)
    intros. ext_eq. compute.
    destruct x.
      reflexivity.
      destruct e.
        reflexivity.
        destruct e; reflexivity.
  - (* monad_law_2 *)
    intros. ext_eq. compute.
    destruct x; reflexivity.
  - (* monad_law_3 *)
    intros. ext_eq. compute.
    destruct x; reflexivity.
  - (* monad_law_4 *)
    intros. ext_eq. compute.
    destruct x.
      reflexivity.
      destruct e; reflexivity.
Defined.
