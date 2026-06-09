# Claude Code Guide — Supabase Migrations for Opto

This document is intended for **Claude Code agents** working in the Flutter `opto-mobile` repository. Purpose: to create, run, verify, and commit Supabase migrations safely and consistently with `database_schema.md`, `system_architecture.md`, and the `@backend` role.

> Place this file in the repo (e.g., `supabase/AGENTS.md` or reference from `CLAUDE.md`) so agents read it before touching the database.

---

## 0. Hard Rules (read before anything)

1. **RLS is the source of truth.** Every table in the `public` schema MUST have `enable row level security` + at least one policy. No tables without RLS. Default-deny.
2. **Medical-sensitive data 🔒** (`anthropometric_data`, `eye_photos`, `consultations`) **owner-only**. Must never be joined into queries feeding Connect feed, Map, or catalog.
3. **`service_role` key NEVER goes in Flutter client.** App holds **anon key only**. Elevated operations (SOS dispatch, LLM proxy, payments, notifications) run via **Edge Functions**.
4. **Supabase changes frequently.** Do not rely on model memory. Before implementing any Supabase feature, fetch `https://supabase.com/changelog.md`, scan for relevant `breaking-change` tags, then check related documentation. Verify function signatures and `config.toml` options against current docs.
5. **Verify every change.** After migration, run test queries + `db advisors`. Changes without verification = incomplete.
6. **Don't loop.** If one approach fails 2–3 times, stop, read the error & logs, switch approaches.

---

## 1. Location & Prerequisites

- **Backend folder:** `supabase/` at root of `opto-mobile` repo (standard CLI structure). Do not name `backend/` unless the team decides on a separate repo.
- **Tooling:** Supabase CLI; Docker Desktop (for local stack `supabase start`); optionally Supabase **MCP server** (OAuth 2.1 — request user trigger auth flow in agent, complete in browser, then reload session).

```bash
supabase --version    # verify installed
docker info           # verify Docker running for local dev
```

---

## 2. Initialization (once per repo)

```bash
cd <root-repo-opto-mobile>
supabase init                               # creates supabase/ folder + config.toml
supabase link --project-ref <PROJECT_REF>   # connect to remote "Opto" project
```

Expected folder structure after init:

```
supabase/
├── config.toml
├── migrations/        # migration files in order (by timestamp)
└── seed.sql           # local seed data (auto-runs on `supabase db reset`)
```

Ensure `config.toml` loads seed (default correct in recent CLI versions):

```toml
[db.seed]
enabled = true
sql_paths = ["./seed.sql"]
```

---

## 3. Two Workflows — Choose by Situation

### Workflow A — Initial schema already finalized (from Opto tutorial)

SQL for the initial schema is written in `opto_supabase_setup_tutorial.md` (Blocks 00–07). Since it is deterministic, write directly as migration files:

```bash
supabase migration new enums          # paste Block 00 content
supabase migration new identity       # Block 01
supabase migration new prosthetic_hub # Block 02
supabase migration new consultation   # Block 03
supabase migration new connect        # Block 04
supabase migration new sos_map        # Block 05
supabase migration new grants         # Block 06
```

**Seed (Block 07)** is NOT a migration. Paste its content into `supabase/seed.sql` so it auto-runs on `supabase db reset` (local). For remote, seed runs manually (see §5).

### Workflow B — New features still iterative (recommended per supabase skill)

For schema changes not yet finalized, **don't** write migrations immediately. Iterate in the DB first, then capture to migration when ready:

1. **Iterate freely** — modify schema with `supabase db query` (CLI) or MCP `execute_sql`. Runs SQL **without** writing migration history, so you can retry.

   ```bash
   supabase db query "alter table public.posts add column pinned boolean not null default false;"
   ```

   > **DO NOT** use `apply_migration` (MCP) for iteration — it writes history entry per call, causing `db diff`/`db pull` to be empty/conflicted, locking you to the first SQL attempt.

2. **Once satisfied, generate clean migration:**

   ```bash
   supabase db diff -f add_pinned_to_posts      # from local diff
   # or, if changes made directly on remote:
   supabase db pull add_pinned_to_posts --yes
   ```

3. Add **RLS + GRANT** for new tables/columns in the same migration if needed.

---

## 4. Run & Reset

**Local (fastest dev loop):**

```bash
supabase start              # start local stack (Postgres, Auth, Storage, etc.)
supabase db reset           # drop + re-apply ALL migrations + seed.sql from scratch
```

`supabase db reset` is the agent's best friend: after editing a migration, reset → test from clean state.

**Remote (deploy to Opto project):**

```bash
supabase db push            # apply migrations not yet on remote
supabase migration list     # compare local vs remote (must be in sync)
```

> `db push` does **not** run `seed.sql`. To seed remote, run its content via SQL Editor or `supabase db query --file supabase/seed.sql` (once, idempotent thanks to `where not exists`).

---

## 5. Mandatory Verification After Each Migration

```bash
# 1) Security advisors — catches tables without policies, functions without search_path, etc.
supabase db advisors        # or MCP get_advisors; FIX all findings

# 2) No public tables without RLS (must return 0 rows)
supabase db query "select tablename from pg_tables where schemaname='public' and rowsecurity=false;"

# 3) List all policies in place
supabase db query "select tablename, policyname, cmd from pg_policies where schemaname='public' order by tablename;"
```

**Test RLS happy-path & sad-path** (mandatory for tables holding user/medical data):

- Owner can read own row. ✅
- Others CANNOT read another's row. ✅
- Revoked caregiver / one without permission CANNOT read. ✅
- Doctor CANNOT read consultation of non-assigned patient. ✅

Quick test from psql/SQL by impersonating a user:

```sql
set local role authenticated;
set local request.jwt.claims = '{"sub":"<UUID_USER_A>","role":"authenticated"}';
select * from public.emergency_contacts;   -- only A's rows appear
reset role;
```

---

## 6. Commit to History (when ready)

Official order before committing migrations (per supabase skill):

1. `supabase db advisors` → fix all issues.
2. Review Security Checklist if changes touch **views / functions / triggers / storage** (e.g., `SECURITY DEFINER` must have `set search_path = ''`).
3. Generate final migration: `supabase db pull <descriptive-name> --local --yes` (if using Workflow B).
4. Verify: `supabase migration list --local`.
5. Commit `supabase/migrations/` folder to Git.

---

## 7. Flutter Client Integration (anon key only)

After schema is ready on remote:

```bash
flutter pub add supabase_flutter
```

```dart
// main.dart — initialize before runApp
await Supabase.initialize(
  url: const String.fromEnvironment('SUPABASE_URL'),
  anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'), // anon key ONLY
);
```

- Store `SUPABASE_URL` & `SUPABASE_ANON_KEY` via `--dart-define` / `--dart-define-from-file`, not hardcoded.
- **Forbidden** to store `service_role` key in app.
- Feature repository (`core/supabase/`) wraps `SupabaseClient`; don't scatter raw `SupabaseClient` calls in widgets (aligns with `system_architecture.md`).
- When migrating from Dio: replace REST calls per-feature with Supabase queries in `data/` layer, keep Dart model contract 1:1 with Postgres rows.

---

## 8. Guardrails — DO / DON'T

**DO**

- Always `enable row level security` + policy in the same migration when creating a table.
- Index every FK column.
- Wrap `auth.uid()` as `(select auth.uid())` in policies.
- Make authorization helpers (`is_admin`, `is_active_caregiver`, etc.) `security definer` + `set search_path = ''`.
- Run `supabase db reset` after editing a migration to test from scratch.
- Add `GRANT` for new tables (because "Automatically expose new tables" is disabled).

**DON'T**

- Don't use `apply_migration` for iteration (locks to first SQL attempt).
- Don't write `service_role` key to client or repository.
- Don't relax RLS on 🔒 tables for join convenience.
- Don't add tables to exposed schema without RLS.
- Don't guess Supabase API from memory — check changelog & docs first.
- Don't modify `profiles.role` via client policies (already blocked by anti-escalation trigger).

---

## 9. Example Prompts to Claude Code

> "Read `supabase/AGENTS.md`. Initialize Supabase in this repo, then create migrations from Blocks 00–06 in `opto_supabase_setup_tutorial.md` as separate files in order. Place seed content in `supabase/seed.sql`. Run `supabase db reset` locally, fix all `db advisors` findings, then show me `pg_policies` output. Don't push to remote until I approve."

> "Add 'pin post' feature to Connect. Use iterative workflow (db query), add update policy for post author only, generate clean migration `add_pin_to_posts`, verify RLS happy/sad paths, then show diff before I approve push."
