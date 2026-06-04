---
description: Wire the Flutter client to Supabase, verifying typed contracts, RLS (happy + sad paths), Realtime subscriptions, and Edge Function handling.
---

# Workflow: Integration & Wiring

**Objective:** Ensure a seamless, type-safe, RLS-correct connection between the Flutter client and Supabase, with no data leaks or broken routes.
**Trigger:** When both the Supabase backend and the Flutter UI for a feature are completed.
**Execution Order:** @qa -> (Wait for User)

**Steps:**

1. **@qa** verifies the Postgres row shape matches the Dart model 1:1 (including nullable medical fields) and that the repository deserializes it correctly.
2. **@qa** verifies **RLS** end-to-end: the owner can read/write; **sad paths** are denied (stranger, revoked caregiver, doctor reading an unrelated patient). Confirms medical-sensitive data never surfaces in public/feed/map/catalog queries.
3. **@qa** checks all `go_router` named routes and Aura Voice deep-links resolve, and that Realtime subscriptions + Edge Function responses are handled with explicit loading/empty/error/offline states (each announced for screen readers).
4. **@qa** simulates validation failures and confirms errors are caught and announced via live region + haptic.
5. **@qa** resolves mismatches, writes the integration log into `.artifacts/logs/`, and reports final status to the user.
