# Opto Supabase Schema — Migration Plan

## Context

Turns the `opto_supabase_setup_tutorial.md` SQL blocks into a versioned,
CLI-managed migration set. 18 tables across 6 modules, 14 enums, helper
functions, and default-deny RLS on every `public` table.

**Apply target:** remote linked project via `supabase db push`.
**"Auto-expose new tables":** OFF → Block 06 grants are mandatory.

---

## Migration files (Blocks 00–06)

| Block | Migration name | Contents |
|-------|---------------|----------|
| 00 | `enums` | `pgcrypto` extension, 14 enum types, generic `set_updated_at()` trigger fn |
| 01 | `identity` | `profiles`, `accessibility_settings`, `caregiver_links`, `emergency_contacts` + helpers + RLS |
| 02 | `prosthetic_hub` | `vendors`, `prosthetic_products`, `anthropometric_data`🔒, `eye_photos`🔒, `prosthetic_orders`, `care_tutorials`, `care_reminders` + RLS |
| 03 | `consultation` | `clinics`, ALTER `vendors` clinic FK, `doctors`, `doctor_availability`, `consultation_bookings`, `consultations`🔒, `eye_care_exercises` + helpers + RLS |
| 04 | `connect` | `posts`, `post_media`, `post_replies`, `follows`, `content_reports` + helpers + RLS |
| 05 | `sos_map` | `sos_events`🔒, `accessibility_pois`, `poi_contributions` + RLS |
| 06 | `grants` | Table-level GRANTs to `authenticated` role |

## Seed file

`supabase/seed.sql` — Block 07. Reference data (clinics, vendors, products,
tutorials, exercises). Idempotent (`where not exists`). Applied separately after
`db push` (SQL Editor or `psql`), not auto-run by `db push` on remote.

## Verification (run after `db push`)

```bash
supabase migration list       # local == remote for all 7 migrations
supabase db advisors          # expect 0 ERROR-level security findings
```

```sql
-- Must return 0 rows (all public tables have RLS on)
select tablename from pg_tables
where schemaname = 'public' and rowsecurity = false;

-- Expect 18 tables
select count(*) from pg_tables where schemaname = 'public';

-- Policy inventory
select tablename, policyname, cmd from pg_policies
where schemaname = 'public' order by tablename, policyname;
```

## Security checklist compliance

- All `SECURITY DEFINER` functions: `set search_path = ''` + `auth.uid()` body check.
- UPDATE policies: both `USING` and `WITH CHECK` on every table.
- `TO authenticated` always paired with an ownership predicate (no BOLA/IDOR).
- `(select auth.uid())` wrapping used throughout (per-statement cache).
- Medical 🔒 tables: owner-only, never joined to community/catalog queries.

---

## Phase 3F — Edge Functions

### `scene-describe`

**Purpose:** Accepts a base64-encoded JPEG frame, calls Anthropic Claude
(claude-sonnet-4-6 multimodal), and returns a concise, accessibility-first
scene description.

**Files:**
- `supabase/functions/scene-describe/index.ts` — Deno handler
- `supabase/functions/scene-describe/deno.json` — npm imports
- `supabase/config.toml` — `[functions.scene-describe] verify_jwt = true`

**Required secret (set once on the Supabase project, never committed):**

```bash
supabase secrets set ANTHROPIC_API_KEY=sk-ant-...
```

**Local development:**

```bash
# Create .env.local with ANTHROPIC_API_KEY=sk-ant-... (gitignored)
supabase functions serve scene-describe --env-file .env.local
```

**Deploy:**

```bash
supabase functions deploy scene-describe
```

**Security properties:**
- `verify_jwt = true` — rejects calls without a valid Supabase JWT.
- `ANTHROPIC_API_KEY` lives only as a Supabase secret — never in `.env` or
  client code.
- Rate-limited: 20 requests per `auth.uid()` per hour (in-memory; upgrade to
  Postgres table for production persistence).
- Image bytes are not logged or cached server-side beyond the single request.
- Only the `describeScene` mode sends image data off-device; all other Vision
  AI modes (OCR, object detection, colors) remain on-device.
