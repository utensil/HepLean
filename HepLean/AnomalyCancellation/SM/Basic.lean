/-
Copyright (c) 2024 Joseph Tooby-Smith. All rights reserved.
Released under Apache 2.0 license.
Authors: Joseph Tooby-Smith
-/
import Mathlib.Tactic.FinCases
import Mathlib.Algebra.Module.Basic
import Mathlib.Tactic.Ring
import Mathlib.Algebra.GroupWithZero.Units.Lemmas
import HepLean.AnomalyCancellation.Basic
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Logic.Equiv.Fin
/-!
# Anomaly cancellation conditions for n family SM.

We define the ACC system for the Standard Model with`n`-famlies and no RHN.

-/

universe v u
open Nat
open BigOperators

/-- Aassociate to each (including RHN) SM fermion a set of charges-/
@[simps!]
def SMCharges (n : ℕ) : ACCSystemCharges := ACCSystemChargesMk (5 * n)

/-- The vector space associated with a single species of fermions. -/
@[simps!]
def SMSpecies (n : ℕ) : ACCSystemCharges := ACCSystemChargesMk n

namespace SMCharges

variable  {n : ℕ}

/-- An equivalence between the set `(SMCharges n).charges` and the set
  `(Fin 5 → Fin n → ℚ)`. -/
@[simps!]
def toSpeciesEquiv : (SMCharges n).charges ≃ (Fin 5 → Fin n → ℚ) :=
  ((Equiv.curry _ _ _).symm.trans ((@finProdFinEquiv 5 n).arrowCongr (Equiv.refl ℚ))).symm

/-- For a given `i ∈ Fin 5`, the projection of a charge onto that species. -/
@[simps!]
def toSpecies (i : Fin 5) : (SMCharges n).charges →ₗ[ℚ] (SMSpecies n).charges where
  toFun S := toSpeciesEquiv S i
  map_add' _ _ := by aesop
  map_smul' _ _ := by aesop

lemma charges_eq_toSpecies_eq (S T : (SMCharges n).charges) :
    S = T ↔ ∀ i, toSpecies i S = toSpecies i T := by
  apply Iff.intro
  intro h
  rw [h]
  simp only [forall_const]
  intro h
  apply toSpeciesEquiv.injective
  funext i
  exact h i

lemma toSMSpecies_toSpecies_inv (i : Fin 5) (f :  (Fin 5 → Fin n → ℚ) ) :
    (toSpecies i) (toSpeciesEquiv.symm f) = f i := by
  change (toSpeciesEquiv ∘ toSpeciesEquiv.symm ) _ i= f i
  simp

/-- The `Q` charges as a map `Fin n → ℚ`. -/
abbrev Q := @toSpecies n 0

/-- The `U` charges as a map `Fin n → ℚ`. -/
abbrev U := @toSpecies n 1

/-- The `D` charges as a map `Fin n → ℚ`. -/
abbrev D := @toSpecies n 2

/-- The `L` charges as a map `Fin n → ℚ`. -/
abbrev L := @toSpecies n 3

/-- The `E` charges as a map `Fin n → ℚ`. -/
abbrev E := @toSpecies n 4

end SMCharges

namespace SMACCs

open SMCharges

variable  {n : ℕ}

/-- The gravitational anomaly equation. -/
@[simp]
def accGrav : (SMCharges n).charges →ₗ[ℚ] ℚ where
  toFun S := ∑ i, (6 * Q S i + 3 * U S i + 3 * D S i + 2 * L S i + E S i)
  map_add' S T := by
    simp only
    repeat rw [map_add]
    simp  [Pi.add_apply, mul_add]
    repeat erw [Finset.sum_add_distrib]
    ring
  map_smul' a S := by
    simp only
    repeat erw [map_smul]
    simp [HSMul.hSMul, SMul.smul]
    repeat erw [Finset.sum_add_distrib]
    repeat erw [← Finset.mul_sum]
    --rw [show Rat.cast a = a from rfl]
    ring

/-- Extensionality lemma for `accGrav`. -/
lemma accGrav_ext {S T : (SMCharges n).charges}
    (hj : ∀ (j : Fin 5),  ∑ i, (toSpecies j) S i = ∑ i, (toSpecies j) T i) :
    accGrav S = accGrav T := by
  simp only [accGrav, SMSpecies_numberCharges, toSpecies_apply, Fin.isValue, LinearMap.coe_mk,
    AddHom.coe_mk]
  repeat erw [Finset.sum_add_distrib]
  repeat erw [← Finset.mul_sum]
  repeat erw [hj]
  rfl

/-- The `SU(2)` anomaly equation. -/
@[simp]
def accSU2 : (SMCharges n).charges →ₗ[ℚ] ℚ where
  toFun S := ∑ i, (3 * Q S i + L S i)
  map_add' S T := by
    simp only
    repeat rw [map_add]
    simp [Pi.add_apply, mul_add]
    repeat erw [Finset.sum_add_distrib]
    ring
  map_smul' a S := by
    simp only
    repeat erw [map_smul]
    simp [HSMul.hSMul, SMul.smul]
    repeat erw [Finset.sum_add_distrib]
    repeat erw [← Finset.mul_sum]
    --rw [show Rat.cast a = a from rfl]
    ring

/-- Extensionality lemma for `accSU2`. -/
lemma accSU2_ext {S T : (SMCharges n).charges}
    (hj : ∀ (j : Fin 5),  ∑ i, (toSpecies j) S i = ∑ i, (toSpecies j) T i) :
    accSU2 S = accSU2 T := by
  simp only [accSU2, SMSpecies_numberCharges, toSpecies_apply, Fin.isValue, LinearMap.coe_mk,
    AddHom.coe_mk]
  repeat erw [Finset.sum_add_distrib]
  repeat erw [← Finset.mul_sum]
  repeat erw [hj]
  rfl

/-- The `SU(3)` anomaly equations. -/
@[simp]
def accSU3 : (SMCharges n).charges →ₗ[ℚ] ℚ where
  toFun S := ∑ i, (2 * Q S i + U S i + D S i)
  map_add' S T := by
    simp only
    repeat rw [map_add]
    simp [Pi.add_apply, mul_add]
    repeat erw [Finset.sum_add_distrib]
    ring
  map_smul' a S := by
    simp only
    repeat erw [map_smul]
    simp [HSMul.hSMul, SMul.smul]
    repeat erw [Finset.sum_add_distrib]
    repeat erw [← Finset.mul_sum]
    --rw [show Rat.cast a = a from rfl]
    ring

/-- Extensionality lemma for `accSU3`. -/
lemma accSU3_ext {S T : (SMCharges n).charges}
    (hj : ∀ (j : Fin 5),  ∑ i, (toSpecies j) S i = ∑ i, (toSpecies j) T i) :
    accSU3 S = accSU3 T := by
  simp only [accSU3, SMSpecies_numberCharges, toSpecies_apply, Fin.isValue, LinearMap.coe_mk,
    AddHom.coe_mk]
  repeat erw [Finset.sum_add_distrib]
  repeat erw [← Finset.mul_sum]
  repeat erw [hj]
  rfl

/-- The `Y²` anomaly equation. -/
@[simp]
def accYY : (SMCharges n).charges →ₗ[ℚ] ℚ where
  toFun S := ∑ i, (Q S i + 8 * U S i + 2 * D S i + 3 * L S i
    + 6 * E S i)
  map_add' S T := by
    simp only
    repeat rw [map_add]
    simp [Pi.add_apply, mul_add]
    repeat erw [Finset.sum_add_distrib]
    ring
  map_smul' a S := by
    simp only
    repeat erw [map_smul]
    simp [HSMul.hSMul, SMul.smul]
    repeat erw [Finset.sum_add_distrib]
    repeat erw [← Finset.mul_sum]
    --rw [show Rat.cast a = a from rfl]
    ring

/-- Extensionality lemma for `accYY`. -/
lemma accYY_ext {S T : (SMCharges n).charges}
    (hj : ∀ (j : Fin 5),  ∑ i, (toSpecies j) S i = ∑ i, (toSpecies j) T i) :
    accYY S = accYY T := by
  simp only [accYY, SMSpecies_numberCharges, toSpecies_apply, Fin.isValue, LinearMap.coe_mk,
    AddHom.coe_mk]
  repeat erw [Finset.sum_add_distrib]
  repeat erw [← Finset.mul_sum]
  repeat erw [hj]
  rfl

/-- The quadratic bilinear map. -/
@[simps!]
def quadBiLin : BiLinearSymm (SMCharges n).charges := BiLinearSymm.mk₂
  (fun S => ∑ i, (Q S.1 i * Q S.2 i +
    - 2 * (U S.1 i * U S.2 i) +
    D S.1 i * D S.2 i +
    (- 1) * (L S.1 i * L S.2 i) +
    E S.1 i * E S.2 i))
  (by
    intro a S T
    simp only
    rw [Finset.mul_sum]
    apply Fintype.sum_congr
    intro i
    repeat erw [map_smul]
    simp [HSMul.hSMul, SMul.smul]
    ring)
  (by
    intro S1 S2 T
    simp only
    rw [← Finset.sum_add_distrib]
    apply Fintype.sum_congr
    intro i
    repeat erw [map_add]
    simp only [ACCSystemCharges.chargesAddCommMonoid_add, toSpecies_apply, Fin.isValue, neg_mul,
      one_mul]
    ring)
  (by
    intro S T
    simp only [SMSpecies_numberCharges, toSpecies_apply, Fin.isValue, neg_mul, one_mul]
    apply Fintype.sum_congr
    intro i
    ring)

/-- The quadratic anomaly cancellation condition. -/
@[simp]
def accQuad  : HomogeneousQuadratic (SMCharges n).charges :=
  (@quadBiLin n).toHomogeneousQuad

/-- Extensionality lemma for `accQuad`. -/
lemma accQuad_ext {S T : (SMCharges n).charges}
    (h : ∀ j, ∑ i, ((fun a => a^2) ∘ toSpecies j S) i =
    ∑ i, ((fun a => a^2) ∘ toSpecies j T) i) :
    accQuad S = accQuad T := by
  simp only [HomogeneousQuadratic, accQuad, BiLinearSymm.toHomogeneousQuad_apply]
  erw [← quadBiLin.toFun_eq_coe]
  rw [quadBiLin]
  simp only [quadBiLin, BiLinearSymm.mk₂, AddHom.toFun_eq_coe, AddHom.coe_mk, LinearMap.coe_mk]
  repeat erw [Finset.sum_add_distrib]
  repeat erw [← Finset.mul_sum]
  ring_nf
  erw [h 0, h 1, h 2, h 3, h 4]
  rfl

/-- The trilinear function defining the cubic. -/
@[simps!]
def cubeTriLin : TriLinearSymm (SMCharges n).charges := TriLinearSymm.mk₃
  (fun S => ∑ i, (6 * ((Q S.1 i) * (Q S.2.1 i) * (Q S.2.2 i))
    + 3 * ((U S.1 i) * (U S.2.1 i) * (U S.2.2 i))
    + 3 * ((D S.1 i) * (D S.2.1 i) * (D S.2.2 i))
    + 2 * ((L S.1 i) * (L S.2.1 i) * (L S.2.2 i))
    +  ((E S.1 i) * (E S.2.1 i) * (E S.2.2 i))))
  (by
    intro a S T R
    simp only
    rw [Finset.mul_sum]
    apply Fintype.sum_congr
    intro i
    repeat erw [map_smul]
    simp [HSMul.hSMul, SMul.smul]
    ring
  )
  (by
    intro S T R L
    simp only
    rw [← Finset.sum_add_distrib]
    apply Fintype.sum_congr
    intro i
    repeat erw [map_add]
    simp only [ACCSystemCharges.chargesAddCommMonoid_add, toSpecies_apply, Fin.isValue]
    ring
  )
  (by
    intro S T L
    simp only [SMSpecies_numberCharges, toSpecies_apply, Fin.isValue]
    apply Fintype.sum_congr
    intro i
    ring
  )
  (by
    intro S T L
    simp only [SMSpecies_numberCharges, toSpecies_apply, Fin.isValue]
    apply Fintype.sum_congr
    intro i
    ring
  )

/-- The cubic acc. -/
@[simp]
def accCube : HomogeneousCubic (SMCharges n).charges := cubeTriLin.toCubic

/-- Extensionality lemma for `accCube`. -/
lemma accCube_ext {S T : (SMCharges n).charges}
    (h : ∀ j, ∑ i, ((fun a => a^3) ∘ toSpecies j S) i =
    ∑ i, ((fun a => a^3) ∘ toSpecies j T) i) :
    accCube S = accCube T := by
  simp only [HomogeneousCubic, accCube, cubeTriLin, TriLinearSymm.toCubic_apply,
    TriLinearSymm.mk₃_toFun_apply_apply]
  repeat erw [Finset.sum_add_distrib]
  repeat erw [← Finset.mul_sum]
  ring_nf
  have h1 : ∀ j, ∑ i, (toSpecies j S i)^3 = ∑ i, (toSpecies j T i)^3 := by
    intro j
    erw [h]
    rfl
  repeat rw [h1]


end SMACCs
