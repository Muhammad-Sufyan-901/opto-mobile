---
description: Analyze requirements against the Opto PRD, design the Supabase schema/RLS contract, and establish the typed data + accessibility contract between Supabase and Flutter before execution.
---

# Workflow: Planning

**Objective:** Define feature specifications, design the Supabase data + RLS contract, and establish the typed contract and accessibility acceptance criteria between backend and Flutter client.
**Trigger:** When the user requests a new complex feature, schema change, or major system change.
**Execution Order:** @pm -> (Wait for User) -> @backend

**Steps:**

1. **@pm** analyzes the request and maps it onto the eight Opto modules and affected personas (Rian/Sari/Bima/Lestari).
2. **@pm** designs the Supabase schema (tables, enums, relationships) and the **RLS contract** (ownership, caregiver, doctor-assignment policies), flags any **medical-sensitive (🔒)** data, and defines the typed row shape (Postgres ↔ Dart model). Identifies needed Storage buckets, Realtime channels, and Edge Functions.
3. **@pm** defines the Flutter feature module, the `go_router` route + Aura Voice intent, and explicit **accessibility acceptance criteria** (labels/focus order, contrast, 48dp targets, haptic, text scale 300%).
4. **@pm** drafts the execution plan and splits backend vs frontend tickets inside `.artifacts/technical_spec_review.md`.
5. **@pm** explicitly pauses and asks for user approval on the spec.
6. Upon approval, **@pm** hands over execution to **@backend** to begin the data + RLS foundation.
