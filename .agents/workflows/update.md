---
description: Perform minor fixes, tweaks, or dependency updates without dismantling the core Flutter + Supabase architecture or accessibility behavior.
---

# Workflow: Minor Update & Refactor

**Objective:** Apply minor bug fixes, small UI tweaks, dependency bumps, or cleanups without altering core architecture, data contracts, or accessibility behavior.
**Trigger:** When the user reports a minor bug, requests a small visual tweak, or asks for cleanup on an existing feature.
**Execution Order:** @frontend / @backend -> @qa -> (Wait for User)

**Steps:**

1. The assigned specialist (**@frontend** or **@backend**, by domain) analyzes the existing code and identifies the change.
2. The specialist applies it following clean-code principles, Flutter best practices, or Supabase/RLS conventions — keeping colors on `ColorScheme` tokens and semantics intact.
3. The specialist confirms the change does not break dependent widgets, the data contract, or any accessibility behavior (labels, focus order, haptic, contrast, text scale, voice path).
4. Execution is handed to **@qa** to run existing `flutter_test` and accessibility/RLS checks, then finalize with the user.
