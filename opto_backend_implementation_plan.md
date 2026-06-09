# Opto — Backend Implementation Plan (Supabase + Flutter Integration)

**Project:** Opto — "Invisible & Inclusive" accessibility-first super app
**Repository:** `opto-mobile` (`Muhammad-Sufyan-901`)
**Stack:** Flutter (Clean Architecture, feature-first) + Supabase (Postgres, Auth, RLS, Storage, Realtime, Edge Functions) + BLoC + GetIt
**Document status:** Implementation plan — ordering by **technical dependency** (foundation → features).

---

## Assumptions & Scope

**Assumed already done (do NOT re-do):**
- Database schema deployed: 18 tables across 6 modules (Identity, Prosthetic Hub, Consultation, Connect, SOS, Map).
- 14 enums created.
- RLS policies + helper functions deployed per `opto_supabase_setup_tutorial.md`.
- Security decisions in place: `prevent_role_change` trigger, `(select auth.uid())` per-statement caching, owner-only on 🔒 tables.

**In scope for this plan:**
- Flutter migration Dio/REST + custom JWT → `supabase_flutter`.
- Deferred Supabase config: Storage bucket policies, Edge Functions, Realtime channels, Dart type contracts.
- Building each feature end-to-end until it runs dynamically (data source → repository → BLoC → accessible screen → live wiring).

**Cross-phase invariants (apply to every ticket):**
- **RLS is the source of authorization.** Client holds only the anon key; elevated operations go through Edge Functions (service-role key lives only there).
- **Repository pattern is mandatory.** Widgets never call `SupabaseClient` directly — always via a feature repository returning domain entities.
- **Typed contract.** Every Postgres row maps 1:1 to a `freezed` Dart model with explicit `fromJson`/`toJson`; nullable medical fields handled explicitly.
- **Accessibility is part of "done."** A screen is not complete until it passes screen-reader (labels + focus order), contrast ≥ 4.5:1, 48dp targets, haptic pattern, and text-scale-to-300% checks.
- **Sensitive (🔒) tables** (`anthropometric_data`, `eye_photos`, `consultations`, `sos_events`) are owner-gated and never joined into community/map/catalog queries.

---

## Phase Overview

| Phase | Title | Core deliverable | Blocks |
| :-- | :-- | :-- | :-- |
| 0 | Foundation: Core Supabase Client & Repo Cleanup | App runs on `supabase_flutter`, rehab artifacts removed | Everything |
| 1 | Auth & Identity | Supabase Auth + profile/settings live | All features (RLS depends on `auth.uid()`) |
| 2 | Core Accessibility, Voice & Storage Infra | a11y + voice + Storage buckets + Realtime enabled | All feature modules |
| 3 | Feature Modules (3A–3F) | Each module functional end-to-end | — |
| 4 | Integration & Hardening | FCM wired, RLS audited, tests green | Release |

---

## PHASE 0 — Foundation: Core Supabase Client & Repo Cleanup

**Goal:** Replace the REST/Dio + custom JWT foundation with `supabase_flutter` and remove leftover rehab-project scaffolding. Without this, no feature can run.

### Backend tickets

- **B0-1 — Verify Data API exposure.** Confirm `anon`/`authenticated` roles are `GRANT`ed access to tables that should be readable. (RLS controls *rows*; GRANT controls *table* accessibility — both required.) If catalog browsing before login is desired later, note which public-read tables need `to anon, authenticated`.
- **B0-2 — Environment config.** Add `SUPABASE_URL` + `SUPABASE_ANON_KEY` to `.env`; document required keys in README.

### Flutter tickets

- **F0-1 — Dependencies.** Add `supabase_flutter` (pin version, commit lockfile). Remove `google_mlkit_pose_detection`, `model_viewer_plus`, and other rehab leftovers. *(Backlog A-4, A-5)*
- **F0-2 — `core/supabase/`.** Create `SupabaseClient` provider + error mapping (`PostgrestException` / `AuthException` → typed `Failure`). Replaces `core/config/api_client.dart`, `core/constants/api_endpoints.dart`, `http_status.dart`. *(Backlog A-1)*
- **F0-3 — Init in `main.dart`.** `Supabase.initialize(...)` before `runApp`; keep `flutter_secure_storage` for the biometric/session gate.
- **F0-4 — Package rename.** `ids_elder_rehab_app` → `opto` in `pubspec.yaml` and every `package:` import. Rewrite stale `README.md` / `gemini.md`. *(Backlog A-5)*
- **F0-5 — Role rename.** `lansia` → `user` across `app_routes.dart`, `app_router.dart`, `roles_middleware.dart`, and models. Align enum to `user / caregiver / doctor / admin`. *(Backlog A-2)*
- **F0-6 — Re-scope `dashboard/`.** Remove rehab artifacts (`lansia_dashboard_screen.dart`, `recovery_progress_card.dart`); stub the Opto home surface. *(Backlog A-3)*

### Definition of Done
- `flutter analyze` clean; app builds and runs with an active Supabase client.
- No `package:ids_elder_rehab_app` imports remain; no rehab dependencies in `pubspec.yaml`.
- No functional feature yet — this is plumbing.

---

## PHASE 1 — Auth & Identity

**Goal:** Auth runs on Supabase Auth, and the Identity module tables connect end-to-end. Prerequisite for every other feature because `auth.uid()` underpins all RLS.

**Tables touched:** `profiles`, `accessibility_settings`, `caregiver_links`, `emergency_contacts`.

### Backend tickets

- **B1-1 — Confirm escalation guards.** Verify `prevent_role_change` trigger and the privilege-escalation policy on `profiles` are active (sad-path test in Phase 4).
- **B1-2 — Profile bootstrap trigger.** Verify a trigger creates a `profiles` row on new sign-up (`handle_new_user`). **This is the only schema item that may need adding** if absent.

### Flutter tickets

- **F1-1 — Migrate `auth` data source.** Dio/JWT → `supabase_flutter` (`signInWithPassword`, `onAuthStateChange` session listener). Keep secure-storage biometric gate. Password-based for now; OTP + biometric is roadmap.
- **F1-2 — Sync auth middleware.** Point `AuthenticationMiddleware.guard` to `Supabase.auth.currentSession`.
- **F1-3 — Build `profile/` feature (3 layers).** Repositories for `profiles`, `accessibility_settings`, `emergency_contacts`, `caregiver_links`.
- **F1-4 — Typed models.** `freezed` models for each Identity table; explicit nullable handling.
- **F1-5 — Accessibility settings wiring.** Persisted theme/typography/haptic preferences read on boot and applied app-wide.

### Accessibility AC
- Login/OTP focus order logical top→bottom; form errors announced via live region; targets ≥ 48dp; labels on all fields.

### Definition of Done
- User logs in via Supabase; profile + accessibility settings read/write dynamically and survive restart.

---

## PHASE 2 — Core Accessibility, Voice & Storage Infrastructure

**Goal:** Build the cross-feature infrastructure that later modules depend on, and finish the deferred Supabase config items.

### Backend tickets (deferred items from tutorial)

- **B2-1 — Storage buckets + policies.** Create private buckets `eye-photos` and `consultation-attachments` (signed-URL access only). **Upsert needs INSERT + SELECT + UPDATE** — granting only INSERT silently breaks file replacement.
- **B2-2 — Realtime channels.** Enable Realtime for Connect (feed), SOS (dispatch), and consultation (WebRTC signaling).

### Flutter tickets

- **F2-1 — `core/accessibility/`.** Semantics helpers, haptic-pattern catalog, `announce()` live-region helper. *(Backlog A-7)*
- **F2-2 — Typography + scaling.** Register **Atkinson Hyperlegible**; wire `textScaler` reflow up to 300% across `core/widgets/` (no overflow/clipping).
- **F2-3 — `core/voice/`.** STT + NLU intent mapping (Aura Voice engine); define `opto://` deep-link intents in `go_router`. *(Backlog A-8)*

### Definition of Done
- a11y helpers, voice intents, and Storage buckets exist and are usable by feature modules; Realtime channels reachable.

---

## PHASE 3 — Feature Modules

Each sub-phase follows the same pattern:
**Storage/Realtime/Edge Function (if needed) → data source → repository → BLoC → accessible screen → dynamic wiring.**
Ordered lightest-dependency first.

### 3A — Prosthetic Hub *(read-heavy; no Edge Function)*
- **Tables:** `vendors`, `prosthetic_products`, `care_tutorials` (read: authenticated); `anthropometric_data`🔒, `eye_photos`🔒 (owner-only); `prosthetic_orders` (owner + caregiver`orders` + admin); `care_reminders` (owner + caregiver`reminders`).
- **Storage:** `eye_photos` uploads/reads via `eye-photos` bucket + signed URL.
- **Edge Function:** none yet (payment webhook for orders deferred).
- **Build order:** catalog (read) → tutorials → anthropometric/eye-photo (🔒 owner) → orders → reminders.

### 3B — Accessibility Map *(read + simple insert)*
- **Tables:** `accessibility_pois` (read: authenticated, insert: authenticated); `poi_contributions` (contributor + admin).
- **Edge Function:** none.
- **Note:** 🔒 tables must never join into POI queries.

### 3C — Connect (Community) *(needs Realtime)*
- **Tables:** `posts`, `post_media`, `post_replies` (read: authenticated, write: author); `follows` (owner-managed); `content_reports` (reporter + admin).
- **Realtime:** live feed channel.
- **Storage:** `post_media` (decide public vs signed; community media is non-sensitive).

### 3D — Consultation *(most complex: Realtime signaling + WebRTC)*
- **Tables:** `clinics`, `doctors`, `doctor_availability`, `eye_care_exercises` (read: authenticated); `consultation_bookings` (patient + assigned doctor + caregiver`bookings`); `consultations`🔒 (patient read + assigned doctor write).
- **Realtime:** WebRTC signaling channel.
- **Storage:** `consultation-attachments` (private, signed URL).
- **Build order:** doctor search → availability → booking → consult session (WebRTC) → history.

### 3E — Emergency SOS *(needs Edge Functions + FCM)*
- **Tables:** `sos_events`🔒 (owner + caregiver`sos`).
- **Edge Functions:** `sos-dispatch`, `send-notification` (FCM). **Service-role key lives only here.**
- **Realtime:** SOS active-event channel.
- **Accessibility:** "SOS sent" announced via live region; strong haptic confirmation; one-action trigger reachable without sight.

### 3F — Vision AI (Aura) *(cloud Edge Function + on-device ML)*
- **Edge Function:** `scene-describe` (cloud multimodal LLM, target < 3s response).
- **On-device (Flutter):** ML Kit Text Recognition (OCR), Object Detection, color CV.
- **Minimal tables;** logic split between Edge Function (cloud scene description) and on-device inference.
- **Edge case (from PRD):** define what Aura announces when `scene-describe` is offline (graceful on-device fallback + spoken status).

---

## PHASE 4 — Integration & Hardening

- **I-1 — FCM wiring.** Connect `send-notification` to all notification triggers (SOS, booking updates, caregiver events).
- **I-2 — RLS audit.** Happy + sad path per table, with special focus on 🔒 tables. Verify a **revoked caregiver** is cut off at the RLS layer (not just the UI).
- **I-3 — Tests.** `flutter_test` coverage per repository + BLoC; integration tests for critical flows (login, SOS dispatch, consult booking).
- **I-4 — Edge-case sweep.** Offline `scene-describe` behavior; Storage signed-URL expiry handling; Realtime reconnect.
- **I-5 — Accessibility regression.** Re-run screen-reader, contrast, tap-target, haptic, and 300%-scale checks across all shipped screens.

---

## Notes on Ordering

- **3A → 3B** are lightest (read-heavy, no Edge Functions).
- **3C → 3D** add Realtime complexity.
- **3E → 3F** are heaviest (Edge Functions + service-role + cloud/on-device AI).
- This ordering follows **technical dependency**, not business priority. If a specific MVP slice must ship first, the sub-phases inside Phase 3 can be reordered without affecting Phases 0–2.

## Open Items / Decisions to Confirm Before Phase 3

- Pre-login catalog browsing: if desired, adjust public-read RLS from `to authenticated` → `to anon, authenticated` (affects 3A/3B).
- `prosthetic_orders` currently lacks an assignee column needed to safely grant practitioner access — confirm whether to add one before building order assignment.
- OTP + biometric auth: confirm target phase (currently roadmap, post-Phase 1).
