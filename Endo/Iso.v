Require Export Basics.

Class Isomorphism X Y :=
{ to   : X -> Y
; from : Y -> X

; iso_to   : from ∘ to = id
; iso_from : to ∘ from = id
}.
  Arguments to       {X} {Y} {Isomorphism} _.
  Arguments from     {X} {Y} {Isomorphism} _.
  Arguments iso_to   {X} {Y} {Isomorphism}.
  Arguments iso_from {X} {Y} {Isomorphism}.

Hint Resolve iso_to.
Hint Resolve iso_from.

Notation "X ≅ Y" := (Isomorphism X Y) (at level 50) : type_scope.
Notation "x ≡ y" := (to x = y /\ from y = x) (at level 50).

Section Isos.

  Variables X Y : Type.
  Context `{X ≅ Y}.

  Theorem iso_from_x : forall (y : Y), to (from y) = y.
  Proof.
    intros.
    destruct H.
    simpl.
    rewrite <- uncompose with (f := to0).
      rewrite iso_from0.
      reflexivity.
    assumption.
  Qed.

  Theorem exchange_from : forall (x : X) (y : Y),
    x ≡ y -> from y = x.
  Proof.
    intros.
    destruct H0.
    assumption.
  Qed.

  Theorem exchange_to : forall (x : X) (y : Y),
    x ≡ y -> to x = y.
  Proof.
    intros.
    destruct H0.
    assumption.
  Qed.

End Isos.