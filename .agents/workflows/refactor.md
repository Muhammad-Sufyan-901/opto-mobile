---
description: Audit and refactor existing code to improve performance and adhere to feature-first architecture and RLS conventions without altering behavior or accessibility.
---

# Workflow: Code Refactoring

**Trigger:** When the user asks to clean up code, reorganize Flutter features, or tighten Supabase RLS/Edge logic.
**Execution Order:** @pm -> (Wait for User) -> @backend AND/OR @frontend -> @qa

**Steps:**

1. **@pm** identifies architectural debt (fat widgets, raw `SupabaseClient` calls in UI, cross-feature imports, missing/loose RLS policies) and writes a refactoring strategy in `.artifacts/technical_spec_review.md`.
2. **@pm** pauses for user approval.
3. Upon approval, **@backend** tightens schema/RLS/Edge Functions while **@frontend** extracts widgets into the correct `features/<module>/` layers and moves SDK access behind repositories.
4. **@qa** aggressively verifies **zero change** to external behavior and accessibility (same labels, focus order, haptics, contrast, voice paths) and no new RLS gaps.
5. **@qa** writes the change log into `.artifacts/logs/` and completes the cycle.
