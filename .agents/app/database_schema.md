# Database Schema — Opto (Supabase / Postgres)

> **Conventions:** UUID primary keys via `gen_random_uuid()`. `created_at`/`updated_at` are `timestamptz`. **Every table has Row Level Security (RLS) ENABLED with default-deny.** `profiles.id` extends Supabase `auth.users.id` (1:1). Medically sensitive tables are flagged 🔒 and carry the strictest owner-only policies. Enums are Postgres `enum` types.

---

## 1. IDENTITY, ROLES & ACCESSIBILITY

### `profiles` — extends `auth.users`
1:1 with `auth.users`; holds role and display data.

| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK**, FK → `auth.users.id` | |
| `role` | `user_role` enum | default `'user'` | `user`, `caregiver`, `doctor`, `admin` |
| `full_name` | `text` | | |
| `phone` | `text` | unique, nullable | OTP login channel |
| `vision_profile` | `vision_profile` enum | nullable | `blind_total`, `low_vision`, `ocular_prosthesis`, `caregiver`, `unspecified` |
| `avatar_url` | `text` | nullable | |
| `created_at` | `timestamptz` | default `now()` | |
| `preferred_language` | `text` | not null, default `'en'` | user's preferred UI language |
| `clinic_id` | `uuid` | FK → `clinics.id`, nullable | linked care clinic |

**RLS:** a user may `select/update` only their own row (`auth.uid() = id`). Doctors/admins read limited fields via dedicated views, not direct table access.

### `accessibility_settings` — per-user UI/AT preferences
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `user_id` | `uuid` | **PK**, FK → `profiles.id` | |
| `theme` | `theme_mode` enum | default `'light'` | `light`, `dark`, `high_contrast` |
| `text_scale` | `numeric(3,2)` | default `1.0` | 1.0–3.0 (up to 300%) |
| `font_family` | `text` | default `'AtkinsonHyperlegible'` | |
| `haptic_intensity` | `haptic_level` enum | default `'full'` | `off`, `light`, `full` |
| `voice_enabled` | `boolean` | default `true` | Aura Voice |
| `hotword_enabled` | `boolean` | default `false` | always-on hotword (battery/privacy) |
| `spoken_guidance_enabled` | `boolean` | default `true` | whether TTS guidance is read aloud |
| `speaking_rate` | `numeric(3,2)` | default `0.45` | TTS playback speed: 0.0 (slowest)–1.0 (fastest) |
| `updated_at` | `timestamptz` | default `now()` | |
| `sound_effects_enabled` | `boolean` | default `true` | app sound effects on/off |

**RLS:** owner-only (`auth.uid() = user_id`).

### `caregiver_links` — consent-based caregiver ↔ user relationship
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `user_id` | `uuid` | FK → `profiles.id` | the person being supported |
| `caregiver_id` | `uuid` | FK → `profiles.id` | |
| `status` | `link_status` enum | default `'pending'` | `pending`, `active`, `revoked` |
| `permissions` | `text[]` | | e.g. `{sos, bookings, reminders, orders}` |
| `created_at` | `timestamptz` | default `now()` | |
> **Index:** unique `(user_id, caregiver_id)`. **RLS:** either party may read; only the `user_id` may approve/revoke. Caregiver access to other tables is granted **only** while `status='active'` and the relevant permission is present.

### `emergency_contacts`
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `user_id` | `uuid` | FK → `profiles.id` | |
| `name` | `text` | | |
| `phone` | `text` | | |
| `relationship` | `text` | nullable | |
| `priority` | `int` | default `0` | dispatch order |
> **RLS:** owner-only.

### `vision_clinical_profile` 🔒 — clinical eye/vision details (owner-only)
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `user_id` | `uuid` | **PK**, FK → `profiles.id` | |
| `diagnosis` | `text` | nullable | e.g. "Glaucoma — advanced" |
| `diagnosis_severity` | `text` | nullable | |
| `affected_eyes` | `text` | nullable | e.g. "Right (functional) · Left (prosthetic)" |
| `diagnosed_year` | `int` | nullable | |
| `light_perception` | `text` | nullable | |
| `central_acuity` | `text` | nullable | e.g. "20/200 · counting fingers" |
| `visual_field` | `text` | nullable | e.g. "Tunnel · ~10° remaining" |
| `prosthesis_eye` | `text` | nullable | "Left", "Right", or "Both" |
| `prosthesis_type` | `text` | nullable | e.g. "scleral shell" |
| `prosthesis_material` | `text` | nullable | e.g. "PMMA acrylic" |
| `prosthesis_fitted_date` | `date` | nullable | |
| `prosthesis_fitted_clinic` | `text` | nullable | clinic name (free text, may differ from linked clinic) |
| `last_polish_date` | `date` | nullable | |
| `next_polish_due` | `date` | nullable | |
| `assistive_tech` | `jsonb` | not null, default `'[]'` | array of `{name: string, enabled: bool}` |
| `created_at` | `timestamptz` | not null, default `now()` | |
| `updated_at` | `timestamptz` | default `now()` | |

**RLS:** owner-only (`auth.uid() = user_id`) for all operations. Medically sensitive — **never** join into community/map/catalog queries, never cache beyond session.

---

## 2. PROSTHETIC HUB (OCULAR) 🔒

### `prosthetic_products`
Verified catalog: ocular prosthetics and self-cleaning cases.

| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `type` | `product_type` enum | | `prosthesis`, `self_cleaning_case`, `care_kit` |
| `name` | `text` | | |
| `audio_description` | `text` | | **required** — full spoken description (material, size, care, price) |
| `material` | `text` | | |
| `iris_color` | `text` | nullable | filter facet |
| `size` | `text` | nullable | filter facet |
| `is_custom` | `boolean` | default `false` | custom vs ready-stock |
| `price_idr` | `int` | | |
| `vendor_id` | `uuid` | FK → `vendors.id`, nullable | |
| `is_active` | `boolean` | default `true` | |
> **RLS:** public read (`is_active = true`); write restricted to `admin`/verified vendor.

### `vendors` — verified manufacturers / clinic partners
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `name` | `text` | | |
| `is_verified` | `boolean` | default `false` | |
| `clinic_id` | `uuid` | FK → `clinics.id`, nullable | clinic-manufacturer link |

### `anthropometric_data` 🔒 — socket/iris measurements
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `user_id` | `uuid` | FK → `profiles.id` | |
| `socket_size_mm` | `numeric` | nullable | |
| `curvature` | `numeric` | nullable | |
| `iris_diameter_mm` | `numeric` | nullable | |
| `matched_iris_hex` | `text` | nullable | from on-device color CV |
| `source` | `data_source` enum | | `self_measured`, `ocularist_record` |
| `created_at` | `timestamptz` | default `now()` | |
> **RLS (strict):** owner-only read/write; an assigned ocularist may read **only** via an approved order relationship. Never joined into public/feed queries.

### `eye_photos` 🔒 — references to Storage objects (private bucket)
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `user_id` | `uuid` | FK → `profiles.id` | |
| `storage_path` | `text` | | object in private `eye-photos` bucket |
| `purpose` | `photo_purpose` enum | | `iris_match`, `consultation`, `progress` |
| `created_at` | `timestamptz` | default `now()` | |
> **RLS (strict):** owner-only; signed URLs only. Storage bucket policy mirrors this.

### `prosthetic_orders`
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `user_id` | `uuid` | FK → `profiles.id` | |
| `product_id` | `uuid` | FK → `prosthetic_products.id` | |
| `anthropometric_id` | `uuid` | FK → `anthropometric_data.id`, nullable | for custom orders |
| `status` | `order_status` enum | default `'draft'` | `draft`, `submitted`, `in_review`, `in_production`, `shipped`, `completed`, `cancelled` |
| `consent_given` | `boolean` | default `false` | explicit read-aloud confirmation |
| `total_idr` | `int` | | |
| `created_at` | `timestamptz` | default `now()` | |
> **RLS:** owner read/write; assigned vendor/ocularist reads via order; admin full.

### `care_tutorials`
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `title` | `text` | | |
| `category` | `tutorial_category` enum | | `insert`, `remove`, `clean`, `lubricate`, `case_use` |
| `video_path` | `text` | nullable | Storage; must have audio description |
| `audio_narration_path` | `text` | nullable | |
| `transcript` | `text` | | required text transcript |
| `sort_order` | `int` | default `0` | |
> **RLS:** public read; admin write.

### `care_reminders`
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `user_id` | `uuid` | FK → `profiles.id` | |
| `label` | `text` | | e.g. periodic cleaning |
| `schedule_cron` | `text` | | dispatched via `send-notification` Edge Function |
| `notify_caregiver` | `boolean` | default `false` | |
| `is_active` | `boolean` | default `true` | |
> **RLS:** owner read/write; linked caregiver read if permitted.

---

## 3. HEALTH & CONSULTATION 🔒

### `clinics`
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `name` | `text` | | |
| `is_manufacturer` | `boolean` | default `false` | clinic-manufacturer |
| `lat` / `lng` | `double precision` | | |
| `address` | `text` | | |

### `doctors`
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `profile_id` | `uuid` | FK → `profiles.id` | role = `doctor` |
| `specialty` | `text` | | eye specialist / ocularist |
| `clinic_id` | `uuid` | FK → `clinics.id`, nullable | |
| `is_verified` | `boolean` | default `false` | |
> **RLS:** public read of non-sensitive fields; profile owner manages own row.

### `doctor_availability`
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `doctor_id` | `uuid` | FK → `doctors.id` | |
| `slot_start` / `slot_end` | `timestamptz` | | |
| `is_booked` | `boolean` | default `false` | |

### `consultation_bookings`
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `user_id` | `uuid` | FK → `profiles.id` | |
| `doctor_id` | `uuid` | FK → `doctors.id` | |
| `slot_id` | `uuid` | FK → `doctor_availability.id` | |
| `mode` | `consult_mode` enum | default `'video'` | `video`, `non_verbal`, `in_person` |
| `status` | `booking_status` enum | default `'booked'` | `booked`, `completed`, `cancelled` |
| `booked_via_voice` | `boolean` | default `false` | KPI: voice-only completion |
| `created_at` | `timestamptz` | default `now()` | |
> **RLS:** patient (owner) and the assigned `doctor_id` only; linked caregiver if permitted.

### `consultations` 🔒 — history & prescriptions
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `booking_id` | `uuid` | FK → `consultation_bookings.id` | |
| `summary` | `text` | nullable | |
| `prescription` | `text` | nullable | |
| `recording_path` | `text` | nullable | **opt-in only**, private Storage |
| `created_at` | `timestamptz` | default `now()` | |
> **RLS (strict):** patient + assigned doctor only.

### `eye_care_exercises`
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `title` | `text` | | |
| `audio_guide_path` | `text` | | |
| `duration_seconds` | `int` | | haptic timer |
| `medical_disclaimer` | `text` | | displayed + read aloud |
> **RLS:** public read; admin write.

---

## 4. CONNECT (COMMUNITY)

### `posts`
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `author_id` | `uuid` | FK → `profiles.id` | |
| `body` | `text` | | supports voice-dictated input |
| `created_at` | `timestamptz` | default `now()` | |
> **RLS:** public read; author write/delete; soft-moderation flag respected.

### `post_media`
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `post_id` | `uuid` | FK → `posts.id` | |
| `storage_path` | `text` | | `post-media` bucket |
| `alt_text` | `text` | **NOT NULL** | alt-text **required** (enforced app + DB) |
> **Constraint:** `alt_text` non-empty `CHECK`.

### `post_replies`, `follows`, `content_reports`
- `post_replies(id, post_id FK, author_id FK, body, created_at)` — RLS public read / author write.
- `follows(follower_id FK, target_id FK, type)` — P2 topic/people follow; owner-managed.
- `content_reports(id, reporter_id FK, post_id FK, reason, status)` — reporter + admin/moderator read; moderation accessible to screen readers in the UI.

---

## 5. EMERGENCY SOS 🔒

### `sos_events`
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `user_id` | `uuid` | FK → `profiles.id` | |
| `trigger_method` | `sos_trigger` enum | | `button`, `gesture`, `voice` |
| `lat` / `lng` | `double precision` | | real-time location |
| `status` | `sos_status` enum | default `'active'` | `active`, `cancelled`, `resolved` |
| `dispatched_at` | `timestamptz` | nullable | set by `sos-dispatch` Edge Function |
| `created_at` | `timestamptz` | default `now()` | |
> **RLS:** owner + active linked caregivers (with `sos` permission). Location streamed via Realtime channel scoped to the event.

---

## 6. ACCESSIBILITY MAP

### `accessibility_pois`
| Field | Type | Attributes | Notes |
| :-- | :-- | :-- | :-- |
| `id` | `uuid` | **PK** | |
| `name` | `text` | | |
| `lat` / `lng` | `double precision` | | |
| `attributes` | `jsonb` | | `{ramp, elevator, tactile_path, wheelchair, ...}` — read aloud |
| `verified_count` | `int` | default `0` | crowdsourced trust |
| `created_by` | `uuid` | FK → `profiles.id`, nullable | |
> **RLS:** public read; authenticated users may insert; verification via `poi_contributions`.

### `poi_contributions`
`(id, poi_id FK, user_id FK, change jsonb, status)` — contributor + moderator read (P2).

---

## 7. NOTES FOR ENGINEERS
- **RLS first:** no table ships without policies. Test both happy path (owner can read) and sad path (stranger denied, revoked caregiver denied, doctor cannot read unrelated patients).
- **Medical-sensitive (🔒) tables** must never appear in joins that feed community, map, or catalog queries.
- **Storage** buckets carry policies mirroring these tables; `eye-photos`, `consultation-attachments` are private + signed-URL only.
- **Edge Functions** are the only path for service-role operations (SOS fan-out, scene-describe, payments, notifications).
