Require Import Coq.ZArith.ZArith.
Require Import Coq.QArith.QArith.
Require Import Coq.QArith.Qround.
Require Import Coq.Strings.String.
Require Import Coq.derive.Derive.
Require Import Coq.Lists.List.
Require Import Crypto.Util.ZRange.
Require Import Crypto.Arithmetic.Core.
Require Import Crypto.Arithmetic.ModOps.
Require Import Crypto.Arithmetic.Partition.
Require Import Crypto.PushButtonSynthesis.UnsaturatedSolinas.
Require Import Crypto.UnsaturatedSolinasHeuristics.
Require Crypto.PushButtonSynthesis.SaturatedSolinas.
Require Crypto.PushButtonSynthesis.WordByWordMontgomery.
Require Crypto.Stringification.C.
Require Crypto.Stringification.Go.
Require Crypto.Stringification.Java.
Require Import Crypto.BoundsPipeline.
Require Import Crypto.Util.ZUtil.ModInv.

Require Import Coq.micromega.Lia.
Require Import Crypto.Algebra.Ring.
Require Import Crypto.Util.Decidable.
Require Import Crypto.Util.LetIn.
Require Import Crypto.Util.ListUtil.
Require Import Crypto.Util.NatUtil.
Require Import Crypto.Util.Prod.
Require Import Crypto.Util.Tactics.BreakMatch.
Require Import Crypto.Util.Tactics.UniquePose.
Require Import Crypto.Util.ZUtil.Definitions.
Require Import Crypto.Util.ZUtil.AddGetCarry Crypto.Util.ZUtil.MulSplit.
Require Import Crypto.Util.ZUtil.Modulo Crypto.Util.ZUtil.Div.
Require Import Crypto.Util.ZUtil.Hints.Core.
Require Import Crypto.Util.ZUtil.Tactics.LtbToLt.
Require Import Crypto.Util.ZUtil.Tactics.RewriteModSmall.
Require Import Crypto.Util.ZUtil.Tactics.PullPush.Modulo.

Require Import Coq.ZArith.Znat.

Require Import Crypto.Util.Notations.
Local Open Scope string_scope.
Local Open Scope list_scope.
Import ListNotations. Local Open Scope Z_scope.

Import
  AbstractInterpretation.Compilers
  Language.Compilers
  Language.API.Compilers.

Import Language.API.Compilers.API.

Import Associational Positional.

Local Coercion Z.of_nat : nat >-> Z.
Local Coercion QArith_base.inject_Z : Z >-> Q.
Local Coercion Z.pos : positive >-> Z.

Local Existing Instance default_low_level_rewriter_method.
Local Existing Instance AbstractInterpretation.default_Options.
Local Instance : unfold_value_barrier_opt := true.
Local Instance : assembly_hints_lines_opt := None.
Local Instance : ignore_unique_asm_names_opt := false.
Local Instance : tight_upperbound_fraction_opt := default_tight_upperbound_fraction.
Local Existing Instance default_language_naming_conventions.
Local Existing Instance default_documentation_options.
Local Instance : package_name_opt := None.
Local Instance : class_name_opt := None.

Local Existing Instance default_output_options.

Module solinas_reduction.

  Import Crypto.Arithmetic.Saturated.

  Section __.

    Context weight {wprops : @weight_properties weight}.

    Definition sat_reduce base s c n (p : list (Z * Z)) :=
      let s' := fst (Saturated.Rows.adjust_s weight (S (S n)) s) in
      let lo_hi := Associational.split s' p in
      let coef := Saturated.Associational.sat_mul_const base [(1, s'/s)] c in
      let hi := Saturated.Associational.sat_mul_const base coef (snd lo_hi) in
      let r := (fst lo_hi) ++ hi in
      r.

    Hint Rewrite eval_app : push_eval.
    Hint Rewrite Saturated.Associational.eval_sat_mul : push_eval.
    Hint Rewrite Saturated.Associational.eval_sat_mul_const using (lia || assumption) : push_eval.
    Hint Rewrite eval_split using solve [auto] : push_eval.

    Lemma value_sat_reduce base s c n (p : list (Z * Z)) (basenz:base<>0):
      let s' := fst (Saturated.Rows.adjust_s weight (S (S n)) s) in
      let coef := Saturated.Associational.sat_mul_const base [(1, s'/s)] c in
      let lo_hi := Associational.split s' p in
      Associational.eval (sat_reduce base s c n p) =
        Associational.eval coef * Associational.eval (snd lo_hi) + Associational.eval (fst lo_hi).
    Proof.
      intros; cbv [sat_reduce] in *; cbv [s' lo_hi coef].
      autorewrite with push_eval; lia.
    Qed.

    Lemma adjust_s_invariant fuel s (s_nz:s<>0) :
      fst (Saturated.Rows.adjust_s weight fuel s) mod s = 0
      /\ fst (Saturated.Rows.adjust_s weight fuel s) <> 0.
    Proof using wprops.
      cbv [Saturated.Rows.adjust_s]; rewrite fold_right_map; generalize (List.rev (seq 0 fuel)); intro ls; induction ls as [|l ls IHls];
        cbn.
      { rewrite Z.mod_same by assumption; auto. }
      { break_match; cbn in *; auto with zarith. }
    Qed.

    Lemma eval_sat_reduce base s c n p :
      base <> 0
      -> s - Associational.eval c <> 0
      -> s <> 0
      -> Associational.eval (sat_reduce base s c n p) mod (s - Associational.eval c)
        = Associational.eval p mod (s - Associational.eval c).
    Proof using wprops.
      intros; cbv [sat_reduce].
      lazymatch goal with
      | |- context[Saturated.Rows.adjust_s ?weight ?fuel ?s] =>
          destruct (adjust_s_invariant fuel s ltac:(assumption)) as [Hmod ?]
      end.
      eta_expand; autorewrite with push_eval zsimplify_const; cbn [fst snd].
      rewrite <- (Z.mul_comm (Associational.eval c)), <- !Z.mul_assoc, <-Associational.reduction_rule by auto.
      autorewrite with zsimplify_const; rewrite !Z.mul_assoc, Z.mul_div_eq_full, Hmod by auto.
      autorewrite with zsimplify_const push_eval; trivial.
    Qed.
    Hint Rewrite eval_sat_reduce using auto : push_eval.

    (* n is input width *)
    Definition reduce1 base s c n m (p : list Z) :=
      let p_a := Positional.to_associational weight n p in
      let r_a := sat_reduce base s c n p_a in
      let r_rows := Saturated.Rows.from_associational weight n r_a in
      let r_flat := Saturated.Rows.flatten weight m r_rows in
      fst r_flat.

    Definition reduce base s c n (p : list Z) :=
      let r1 := reduce1 base s c (2*n) (S n) p in
      let r2 := reduce1 base s c (S n) (S n) (r1) in
      let r3 := reduce1 base s c (S n) (n) (r2) in
      r3.

    Definition mul_no_reduce base n (p q : list Z) :=
      let p_a := Positional.to_associational weight n p in
      let q_a := Positional.to_associational weight n q in
      let pq_a := Saturated.Associational.sat_mul base p_a q_a in
      let pq_rows := Saturated.Rows.from_associational weight (2*n) pq_a in
      let pq := Saturated.Rows.flatten weight (2*n) pq_rows in
      fst pq.

    Definition mulmod base s c n (p q : list Z) :=
      let prod := mul_no_reduce base n p q in
      let red := reduce base s c n prod in
      red.

    Definition canonical_repr n (p : list Z) : Prop :=
      length p = n /\
        p = Partition.partition weight n (Positional.eval weight n p).

    Hint Rewrite Saturated.Rows.eval_from_associational using auto : push_eval.

    Hint Resolve length_partition : push_length.
    Hint Resolve Rows.length_from_associational : push_length.

    Lemma reduce_canonical_repr base s c n m : forall (p : list Z),
        canonical_repr m (reduce1 base s c n m p).
    Proof using wprops.
      intros.
      unfold reduce1 in *.
      unfold canonical_repr.
      rewrite Saturated.Rows.flatten_correct; auto.
      { intuition.
        { cbn [fst].
          auto with push_length. }
        { simpl.
          rewrite Partition.eval_partition; auto.
          f_equal.
          admit. }
      }
      { admit. }
    Admitted.

    Theorem reduce_second base s c n (s_nz:s<>0) : forall (p : list Z) lo hi,
        p = lo ++ [hi] ->
        (canonical_repr (S n) p /\ hi <= 39) ->
        forall q_lo q_hi1 q_hi2,
          let q := reduce1 base s c (S n) (S n) p in
          q = q_lo ++ [q_hi1] ++ [q_hi2] ->
          canonical_repr (S n) q ->
          ((* canonical_repr n q /\ *)
             ((q_hi2 = 1 /\ q_hi1 = 0) \/
                (q_hi2 = 0))).
    Proof using wprops.
      intros.
      intuition.

      assert (Hevalq : eval weight (S n) q = 38 * hi + eval weight n lo).
      { cbv [reduce1] in *.
        cbv [q].
        rewrite !H.
        Search eval Rows.flatten.
        rewrite Rows.flatten_mod.
        Search Rows.eval Rows.from_associational.
        rewrite Rows.eval_from_associational.
        Search Associational.eval sat_reduce.
        rewrite value_sat_reduce.

        lazymatch goal with
        | |- context[Saturated.Rows.adjust_s ?weight ?fuel ?s] =>
            destruct (adjust_s_invariant fuel s ltac:(assumption)) as [Hmod ?]
        end.
        destruct Rows.adjust_s.
        cbn [fst] in *.
        cbv [to_associational].
        Search combine app.
        Search seq app.
        rewrite seq_snoc.
        rewrite map_app.
        replace (map weight [(0 + n)%nat]) with [weight n] by auto.
        rewrite combine_snoc.

        Search split snd.
        rewrite fst_split_app.
        rewrite snd_split_app.
        autorewrite with push_eval.

        all: admit.
      }

      assert (q_hi2 < 2).
      { pose proof fun pf => nth_default_partition weight 0 (S n) (eval weight (S n) q) (1 + length q_lo) pf.
        unfold canonical_repr in H2.
        destruct H2.
        rewrite <-H5 in H0.
        rewrite H1 in H0 at 1.
        Search nth_default app.
        rewrite nth_default_app in H0.
        destruct (lt_dec) in H0.
        lia.
        replace (1 + Datatypes.length q_lo - Datatypes.length q_lo)%nat with 1%nat in H0 by lia.
        unfold nth_default in H0.
        simpl in H0.
        rewrite Hevalq in H0.
        rewrite H0.
        Search (_ / _ < _).
        apply Z.div_lt_upper_bound.
        admit.

        Search Z.lt Z.le 1 iff.
        apply Le.Z.le_sub_1_iff.

        etransitivity.
        apply Z.mod_le.
        admit.
        apply wprops.

        admit.
        admit. }

      assert (q_hi2 >= 0) by admit.
      assert (q_hi2 = 1 \/ q_hi2 = 0) by lia.
      intuition.
      left.
      intuition.
      pose proof f_equal (eval weight (S n)) H1.
      rewrite app_assoc in H6.
      Search eval app.
      erewrite eval_snoc in H6.
      2: eauto.
      erewrite eval_snoc in H6.
      2: eauto.
      Search (_ = _ + _ -> _ - _ = _).
      rewrite Hevalq in H6.
      subst.
      autorewrite with zsimplify_const in H6.
      apply LinearSubstitute.Z.move_L_pX with (y:=weight (Datatypes.length (q_lo ++ [q_hi1]))) in H6.
      Search nth_default Partition.partition.
      pose proof fun pf => nth_default_partition weight 0 (n) (38 * hi + eval weight n lo - weight (Datatypes.length (q_lo ++ [q_hi1]))) (length q_lo) pf.
      assert (Partition.partition weight n (38 * hi + eval weight n lo - weight (Datatypes.length (q_lo ++ [q_hi1]))) = q_lo ++ [q_hi1]) by admit.
      rewrite H7 in H.
      rewrite nth_default_app in H.
      destruct lt_dec in H.
      lia.
      replace (Datatypes.length q_lo - Datatypes.length q_lo)%nat with 0%nat in H by lia.
      replace (nth_default 0 [q_hi1] 0) with (q_hi1) in H.
      2: { unfold nth_default.
           reflexivity. }
      rewrite H.
      Search (_ / _ = 0).
      apply Z.div_small.
      split.
      admit.
      apply Le.Z.le_sub_1_iff.
      etransitivity.
      apply Z.mod_le.
      admit.
      apply wprops.
      { admit. }
      unfold canonical_repr in H2.
      intuition.
      apply f_equal with (f:=fun l => length l) in H1.
      rewrite !app_length in H1.
      cbn [Datatypes.length] in H1.
      assert (Datatypes.length q_lo = (n - 1)%nat) by lia.
      lia.
      rewrite app_length.
      cbn [Datatypes.length].
      lia.

      unfold canonical_repr in H2.
      intuition.
      apply f_equal with (f:=fun l => length l) in H1.
      rewrite !app_length in *.
      cbn [Datatypes.length] in *.
      apply f_equal.
      rewrite H8 in H1.
      lia.
    Admitted.

  End __.

  Section compile.

    Let s := 2^255.
    Let c := [(1, 19)].
    Let machine_wordsize := 64.
    Let n : nat := Z.to_nat (Qceiling (Z.log2_up s / machine_wordsize)).
    Let m : nat := 2 * n.
    Let w : nat -> Z := weight machine_wordsize 1.
    Let base : Z := 2 ^ machine_wordsize.

    Let bound := Some r[0 ~> (2^machine_wordsize - 1)]%zrange.
    Let boundsn : list (ZRange.type.option.interp base.type.Z)
        := repeat bound (n).

    Import Stringification.C.Compilers.
    Import Stringification.C.Compilers.ToString.

    Local Existing Instances ToString.C.OutputCAPI Pipeline.show_ErrorMessage.
    Local Instance : only_signed_opt := false.
    Local Instance : no_select_opt := false.
    Local Instance : static_opt := true.
    Local Instance : internal_static_opt := true.
    Local Instance : inline_opt := true.
    Local Instance : inline_internal_opt := true.
    Local Instance : use_mul_for_cmovznz_opt := false.
    Local Instance : emit_primitives_opt := true.
    Local Instance : should_split_mul_opt := false.
    Local Instance : should_split_multiret_opt := false.
    Local Instance : widen_carry_opt := false.
    Local Instance : widen_bytes_opt := true. (* true, because we don't allow byte-sized things anyway, so we should not expect carries to be widened to byte-size when emitting C code *)

    Let possible_values := prefix_with_carry [machine_wordsize].
    Local Instance : machine_wordsize_opt := machine_wordsize. (* for show *)
    Local Instance : no_select_size_opt := no_select_size_of_no_select machine_wordsize.
    Local Instance : split_mul_to_opt := split_mul_to_of_should_split_mul machine_wordsize possible_values.
    Local Instance : split_multiret_to_opt := split_multiret_to_of_should_split_multiret machine_wordsize possible_values.


    Compute reduce

    Time Compute
         Show.show
         (Pipeline.BoundsPipelineToString
            "fiat" "mul"
            false
            false
            None
            possible_values
            machine_wordsize
            ltac:(let n := (eval cbv in n) in
                  let r := Reify (reduce w base s c n) in
                  exact r)
                   (fun _ _ => [])
                   (Some (repeat bound (2*n)), tt)
                   (Some (repeat bound (n)))
                   (None, tt)
                   (None)
           : Pipeline.ErrorT _).

  End compile.

End solinas_reduction.
