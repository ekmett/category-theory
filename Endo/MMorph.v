Require Export Monad.
Require Export Trans.

(* These classes are laws are documented by Gabriel Gonzalez at:

   http://hackage.haskell.org/package/mmorph-1.0.3/docs/src/Control-Monad-Morph.html
*)
Class MFunctor (T : (Type -> Type) -> Type -> Type) :=
{ hoist : forall {M N : Type -> Type} `{Monad M} `{Monad (T M)} {A},
    (forall {X}, M X -> N X) -> T M A -> T N A

; hoist_law_1 : forall {M : Type -> Type} `{Monad M} `{Monad (T M)} {A},
    (@hoist M M _ _ A (fun X => id)) = id

; hoist_law_2 : forall {M N O : Type -> Type}
    `{Monad M} `{Monad (T M)} `{Monad N} `{Monad (T N)} {A : Type}
    (f : forall X, N X -> O X) (g : forall X, M X -> N X),
    hoist (fun X => f X ∘ g X) = hoist f ∘ (@hoist M N _ _ A g)
}.

Notation "hoist/ M N" := (@hoist M N _ _ _) (at level 68).

(*
Set Printing All.
Class MMonad (T : (Type -> Type) -> Type -> Type)
  `{MFunctor T} `{td : MonadTrans T} :=
{ embed : forall {M N : Type -> Type} `{Monad N} `{Monad (T N)} {A},
    (forall {X}, M X -> T N X) -> T M A -> T N A

; embed_law_1 : forall {N : Type -> Type}
    `{n : Monad N} `{tn : Monad (T N)} {A : Type},
    @embed N N _ _ A (@lift T _ n tn td) = id

; embed_law_2 : forall {M N : Type -> Type}
    `{Monad M} `{Monad (T M)} `{Monad N} `{Monad (T N)} {A : Type}
    (m : M A) (f : forall X, M X -> T N X),
    (@embed M N _ _ A f (@lift T _ _ _ _ A m)) = f A m

; embed_law_3 : forall {M N O : Type -> Type}
    `{Monad M} `{Monad (T M)}
    `{Monad N} `{Monad (T N)}
    `{Monad O} `{Monad (T O)} {A : Type}
    (f : forall X, N X -> T O X) (g : forall X, M X -> T N X) (t : T M A),
    (@embed N O _ _ A f) ∘ (@embed M N _ _ A g) =
    (@embed M O _ _ A (fun B => (@embed N O _ _ B f) ∘ g B))
}.

Notation "embed/ M N" := (@embed M N _ _ _) (at level 68).
*)