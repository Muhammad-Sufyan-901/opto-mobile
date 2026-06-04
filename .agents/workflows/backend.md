---
description: Build the secure Supabase data foundation — migrations, Row Level Security, Storage policies, Realtime channels, and Edge Functions — without handling UI.
---

# Workflow: Backend Development (Supabase)

**Objective:** Build the secure, RLS-first data foundation and server-only logic on Supabase.
**Trigger:** When a technical spec is approved, or the user explicitly asks for schema/RLS/Edge Function work.
**Execution Order:** @backend -> @frontend

**Steps:**

1. **@backend** writes/updates Postgres migrations (tables, enums, constraints, indexes, relationships), ensuring transactions for multi-table state changes.
2. **@backend** enables **RLS** on every new table with default-deny and writes policies for ownership (`auth.uid()`), caregiver (only while `active` + permitted), and doctor-assignment relationships. Medical-sensitive (🔒) tables get owner-only policies and never join into public queries.
3. **@backend** configures Storage buckets + policies (private/signed-URL for `eye-photos`, `consultation-attachments`) and Realtime channels (Connect, SOS, consultation signaling) as needed.
4. **@backend** implements Edge Functions (Deno/TypeScript) for server-only logic (`scene-describe`, `sos-dispatch`, `send-notification`, payment webhooks); the service-role key lives only here.
5. **@backend** documents the typed row shape for each consumed table so the Dart model maps 1:1, then passes execution to **@frontend**.
