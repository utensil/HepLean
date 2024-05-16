/-
Copyright (c) 2024 Joseph Tooby-Smith. All rights reserved.
Released under Apache 2.0 license.
Authors: Joseph Tooby-Smith
-/
import HepLean.SpaceTime.Metric
/-!
# The Clifford Algebra

This file defines the Gamma matrices.

## TODO

- Prove that the algebra generated by the gamma matrices is ismorphic to the
  Clifford algebra assocaited with spacetime.
- Include relations for gamma matrices.
-/

namespace spaceTime
open Complex

noncomputable section diracRepresentation

/-- The γ⁰ gamma matrix in the Dirac representation. -/
def γ0 : Matrix (Fin 4) (Fin 4) ℂ :=
  ![![1, 0, 0, 0], ![0, 1, 0, 0], ![0, 0, -1, 0], ![0, 0, 0, -1]]

/-- The γ¹ gamma matrix in the Dirac representation. -/
def γ1 : Matrix (Fin 4) (Fin 4) ℂ :=
  ![![0, 0, 0, 1], ![0, 0, 1, 0], ![0, -1, 0, 0], ![-1, 0, 0, 0]]

/-- The γ² gamma matrix in the Dirac representation. -/
def γ2 : Matrix (Fin 4) (Fin 4) ℂ :=
  ![![0, 0, 0, - I], ![0, 0, I, 0], ![0, I, 0, 0], ![-I, 0, 0, 0]]

/-- The γ³ gamma matrix in the Dirac representation. -/
def γ3 : Matrix (Fin 4) (Fin 4) ℂ :=
  ![![0, 0, 1, 0], ![0, 0, 0, -1], ![-1, 0, 0, 0], ![0, 1, 0, 0]]

/-- The γ⁵ gamma matrix in the Dirac representation. -/
def γ5 : Matrix (Fin 4) (Fin 4) ℂ := I • (γ0 * γ1 * γ2 * γ3)

/-- The γ gamma matrices in the Dirac representation. -/
@[simp]
def γ : Fin 4 → Matrix (Fin 4) (Fin 4) ℂ := ![γ0, γ1, γ2, γ3]

namespace γ

open spaceTime

variable (μ ν : Fin 4)

/-- The subset of `Matrix (Fin 4) (Fin 4) ℂ` formed by the gamma matrices in the Dirac
representation. -/
@[simp]
def γSet : Set (Matrix (Fin 4) (Fin 4) ℂ) := {γ i | i : Fin 4}

lemma γ_in_γSet (μ : Fin 4) : γ μ ∈ γSet := by
  simp [γSet]

/-- The algebra generated by the gamma matrices in the Dirac representation. -/
def diracAlgebra : Subalgebra ℝ (Matrix (Fin 4) (Fin 4) ℂ) :=
  Algebra.adjoin ℝ γSet

lemma γSet_subset_diracAlgebra : γSet ⊆ diracAlgebra :=
  Algebra.subset_adjoin

lemma γ_in_diracAlgebra (μ : Fin 4) : γ μ ∈ diracAlgebra :=
  γSet_subset_diracAlgebra (γ_in_γSet μ)

end γ

end diracRepresentation
end spaceTime

namespace CliffordAlgebraDiracAlgebra

open scoped spaceTime.γ

instance : Semiring diracAlgebra := sorry

def Q : QuadraticForm ℝ (Matrix (Fin 4) (Fin 4) ℂ) := sorry

instance : Algebra ℝ (CliffordAlgebra Q) := sorry

instance : Algebra ℝ diracAlgebra := sorry

def equiv : CliffordAlgebra Q ≃ₐ[ℝ] diracAlgebra := sorry

end CliffordAlgebraDiracAlgebra
