/-
Copyright (c) 2024 Joseph Tooby-Smith. All rights reserved.
Released under Apache 2.0 license.
Authors: Joseph Tooby-Smith
-/
import HepLean.AnomalyCancellation.MSSMNu.Basic
import Mathlib.Tactic.Polyrith
/-!
# Hypercharge in MSSM.

Relavent definitions for the MSSM hypercharge.

-/

universe v u

namespace MSSMACC
open MSSMCharges
open MSSMACCs
open BigOperators

/-- The hypercharge as an element of `MSSMACC.charges`. -/
def YAsCharge : MSSMACC.charges := toSpecies.invFun
  ⟨fun s => fun i =>
    match s, i with
    | 0, 0 => 1
    | 0, 1 => 1
    | 0, 2 => 1
    | 1, 0 => -4
    | 1, 1 => -4
    | 1, 2 => -4
    | 2, 0 => 2
    | 2, 1 => 2
    | 2, 2 => 2
    | 3, 0 => -3
    | 3, 1 => -3
    | 3, 2 => -3
    | 4, 0 => 6
    | 4, 1 => 6
    | 4, 2 => 6
    | 5, 0 => 0
    | 5, 1 => 0
    | 5, 2 => 0,
  fun s =>
    match s with
    | 0 => -3
    | 1 => 3⟩

/-- The hypercharge as an element of `MSSMACC.Sols`. -/
def Y : MSSMACC.Sols :=
  MSSMACC.AnomalyFreeMk YAsCharge (by rfl) (by rfl) (by rfl) (by rfl) (by rfl) (by rfl)


end MSSMACC
