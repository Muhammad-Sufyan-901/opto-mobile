# System Architecture Brief — Opto

**Target Audience:** Flutter Engineers, Supabase/Backend Engineers, Software Architect
**Architecture Type:** Flutter **Clean Architecture (feature-first)** mobile client on top of a **Supabase** backend (Postgres + RLS, Auth, Storage, Realtime, Edge Functions).
**State Management:** **BLoC (`flutter_bloc`) + GetIt** service locator.

> **Document status:** This brief describes the **target architecture** for Opto and reconciles it against the **current state of the `opto-mobile` codebase**. Where the two differ, the gap is called out explicitly. See **§0** for the implementation snapshot and **Appendix A** for the migration/action-item backlog.

---

## 0. Implementation Status & Gap Snapshot

The repository was scaffolded by renaming a different project ("IDS Elder Rehab App") and has **not** yet been fully re-pointed to the Opto architecture. The following reflects what exists today versus the target described in this document.

### Legend
- ✅ **Built** — present and broadly aligned with the target.
- 🟡 **Partial** — scaffolded but incomplete, or implemented with a stack that must change.
- ⛔ **Planned** — described as target architecture; **not yet implemented**.

| Area | Status | Notes |
| :-- | :-- | :-- |
| Navigation (`go_router`) | ✅ Built | `go_router ^17.1.0` present; aligns with target. Deep links (`opto://`) not yet defined. |
| State management (BLoC + GetIt) | 🟡 Partial | `flutter_bloc` + `get_it` are dependencies and DI container exists; per-feature BLoCs/repositories not yet built out. |
| Clean Architecture layering | 🟡 Partial | `auth` has `data/domain/presentation`; other features only have `presentation`. No `datasources`/`repositories` yet. |
| Backend = Supabase | ⛔ Planned | Code currently uses a **REST/Dio** client with **custom JWT** auth. Must migrate to `supabase_flutter`. |
| Auth (Supabase OTP + biometric) | ⛔ Planned | Current auth is **email/password + JWT refresh** over REST. |
| Feature: `onboarding` | ✅ Built | Screens + widgets present. |
| Feature: `auth` | ✅ Built | Login / register / forgot-password (REST). |
| Feature: `dashboard` | 🟡 Partial | Contains leftover rehab artifacts (`lansia_dashboard_screen`, `recovery_progress_card`). |
| Feature: `dev` | ✅ Built | Internal developer/debug screen (not a product module). |
| Feature: `vision_ai` (Aura) | ⛔ Planned | Not present. Repo ships `google_mlkit_pose_detection` (leftover, wrong purpose). |
| Feature: `prosthetic_hub` | ⛔ Planned | Not present. |
| Feature: `consultation` | ⛔ Planned | Not present. No WebRTC; only `video_player`/`chewie`. |
| Feature: `connect` | ⛔ Planned | Not present. |
| Feature: `sos` | ⛔ Planned | Not present. |
| Feature: `map` | ⛔ Planned | Not present. |
| Feature: `profile` | ⛔ Planned | Not present. |
| `core/accessibility/` | ⛔ Planned | No dedicated a11y helpers (Semantics/haptic catalog/announce) yet. A UI widget library exists under `core/widgets/`. |
| `core/voice/` (Aura Voice STT/NLU) | ⛔ Planned | No STT/NLU dependency or folder. |
| Realtime / Storage buckets / Edge Functions | ⛔ Planned | Follow from the Supabase migration. Current push = `flutter_local_notifications` (local only). |
| Branding (`package name`, README) | ⛔ Action | Package is still `ids_elder_rehab_app`; README describes the rehab app. |

---

## 1. Communication Concepts & Main Paradigms

Opto is a single Flutter codebase (Android + iOS). The **target** is to talk directly to Supabase: there is **no separate REST/Node API** — the Flutter client uses the official `supabase_flutter` SDK and reaches Postgres through PostgREST, Storage, Realtime, and Edge Functions. Security is enforced **at the database layer** via Row Level Security (RLS), never solely in the client.

- **Client (Flutter + BLoC + GetIt):** screens, state, and accessibility live here. The client calls Supabase via repositories; it never embeds service-role keys.
- **Backend (Supabase):** Postgres schema + RLS policies are the source of truth for authorization. Server-side logic that must not run on the client (cloud LLM proxy, payment, push fan-out, SOS dispatch) lives in **Edge Functions** (Deno/TypeScript). Realtime channels power Connect, SOS, and consultation signaling. Storage holds media (tutorial videos, eye photos) with bucket-level policies.

> **Current reality (transitional):** the app presently uses a **Dio REST client** (`core/config/api_client.dart`, `core/constants/api_endpoints.dart`) with **custom JWT** tokens (`AuthEntity.token`) and `flutter_secure_storage`. This layer is **legacy** and is scheduled for replacement by `supabase_flutter` (Appendix A-1).

---

## 2. Client Architecture (Flutter — Clean Architecture, Feature-First)

Each product module is an isolated feature module. Layers per feature: `presentation` (UI + state) → `domain` (entities, use cases) → `data` (repositories, data sources).

### 2.1 Actual structure (today)

```
lib/
├── core/
│   ├── config/                 # app + environment config, api_client (Dio — legacy)
│   ├── constants/              # app_routes, api_endpoints, http_status
│   ├── di/                     # dependencies_injection_container.dart (GetIt)
│   ├── error/                  # failures / exceptions
│   ├── middlewares/            # authentication_middleware, roles_middleware (go_router)
│   ├── router/                 # app_router.dart (go_router config)
│   ├── themes/                 # ColorScheme tokens, typography
│   ├── utils/                  # formatters, helpers (incl. secure_storage_helper)
│   └── widgets/                # accessible UI primitives — 16 groups:
│                               #   accordions, alerts, badges, breadcrumbs, buttons,
│                               #   calendars, cards, dropdowns, forms, inputs,
│                               #   sliders, switches, tables, tabs
├── features/
│   ├── auth/                   # data(models) / domain(entities) / presentation(layouts, screens)
│   ├── dashboard/              # presentation(screens, widgets)  ← contains rehab leftovers
│   ├── dev/                    # presentation(screens) — internal debug surface
│   └── onboarding/             # presentation(screens, widgets)
```

> Notes on the actual tree:
> - There is **no `shared/`** folder yet.
> - The doc-target folders `core/accessibility/`, `core/voice/`, and `core/supabase/` **do not exist** yet.
> - `core/widgets/` is a sizeable component library (shadcn-style primitives) — a strong asset to build the accessible design system on.

### 2.2 Target structure (to converge toward)

```
lib/
├── core/
│   ├── accessibility/          # ⛔ Semantics helpers, haptic patterns, announce()
│   ├── config/                 # ✅ app/env config
│   ├── constants/              # ✅ routes, etc.
│   ├── di/                     # ✅ GetIt container
│   ├── error/                  # ✅ failures
│   ├── middlewares/            # ✅ auth + role guards
│   ├── router/                 # ✅ go_router + deep links for Aura Voice intents
│   ├── supabase/               # ⛔ SupabaseClient provider, error mapping (replaces Dio config)
│   ├── themes/                 # ✅ ColorScheme tokens (light default; dark/high-contrast), text scaler
│   ├── voice/                  # ⛔ STT + intent mapping (Aura Voice engine)
│   ├── widgets/                # ✅ accessible primitives (A11yButton, A11yCard, A11yField, …)
│   └── utils/                  # ✅ formatters, result types
├── features/
│   ├── onboarding/             # ✅ built
│   ├── auth/                   # ✅ built (migrate to Supabase Auth)
│   ├── profile/                # ⛔ settings, caregiver linking, medical data export/delete
│   ├── vision_ai/              # ⛔ Aura: scene description, OCR, object/color
│   ├── prosthetic_hub/         # ⛔ catalog, custom order, tutorials, reminders
│   ├── consultation/           # ⛔ doctors, booking, WebRTC non-verbal consult, history
│   ├── connect/                # ⛔ community threads
│   ├── sos/                    # ⛔ Emergency SOS triggers + dispatch
│   └── map/                    # ⛔ Accessibility Map
└── shared/                     # ⛔ cross-feature models/value objects (use sparingly)
```

> The `dev/` and `dashboard/` features are not part of the target product surface as-is: `dev/` is an internal debug screen, and `dashboard/` must be re-scoped from the rehab "lansia dashboard" into the Opto home/profile surface (Appendix A-3).

**Golden Rule:** `core/` must not import from `features/`, and feature folders must not import each other directly. Cross-feature needs go through `shared/` or an exported `domain` contract.

### State Management
- **BLoC (`flutter_bloc`)** is the standard for state, with **GetIt (`get_it`)** as the service locator / DI container (`core/di/dependencies_injection_container.dart`). This matches the implemented stack and suits event-heavy flows (SOS, WebRTC signaling).
- Server state is fetched through feature repositories and exposed to BLoCs; avoid scattering raw `SupabaseClient` (or, today, `Dio`) calls in widgets.
- `freezed_annotation` is available for immutable state/event/model classes.

### Navigation
- **`go_router ^17.1.0`** (already in use) with named routes. Route guards are implemented as **middlewares** (`core/middlewares/authentication_middleware.dart`, `roles_middleware.dart`).
- **Target:** add deep links so **Aura Voice** can jump straight to any screen/intent (e.g. `opto://prosthetic/order`, `opto://sos`). Every voice command maps to a route + intent payload. *(Not yet defined; current routes use plain paths.)*

### Accessibility-Native (mandatory, see `design_system.md`)
*(Target — to be implemented in `core/accessibility/` and applied across `core/widgets/`.)*
- `Semantics` / `MergeSemantics` / `ExcludeSemantics` on every interactive/decorative element.
- Live regions via `SemanticsService.announce` for dynamic status (Vision AI result, form errors, "SOS sent").
- `HapticFeedback` driven by the shared haptic-pattern catalog.
- `MediaQuery.textScaler` honored up to 300% with reflow (no overflow/clipping).
- Atkinson Hyperlegible as the primary typeface (register in `pubspec.yaml` assets + `core/themes`).

---

## 3. Backend Architecture (Supabase)

> **Target architecture.** The current code reaches a REST backend via Dio; migrating to Supabase (Appendix A-1) is a prerequisite for the sections below.

### 3.1 Postgres + Row Level Security (authorization source of truth)
- Every table that holds user or medical data has **RLS enabled**. Default deny; policies grant access by `auth.uid()` ownership or by an explicit caregiver/role relationship.
- Roles are modeled in a `profiles.role` enum (`user`, `caregiver`, `doctor`, `admin`) plus relationship tables (e.g. `caregiver_links`). Doctors only see consultations they are assigned to; caregivers only see linked users' permitted data.
- Medically sensitive tables (`anthropometric_data`, `eye_photos`, `consultations`) carry the strictest policies and are never exposed to community/feed queries.

> **Gap:** the codebase currently uses a `lansia` role (leftover from the rehab template). It must be renamed to the Opto `user` role and the role enum aligned to `user / caregiver / doctor / admin` (Appendix A-2).

### 3.2 Auth
- **Target:** Supabase Auth with **phone OTP** (and email OTP) + on-device **biometric unlock** for the local session. **No visual CAPTCHA** anywhere. Biometric gate is a client-side re-auth over a valid Supabase session, not a replacement for it.
- **Current:** email/password login, registration, and forgot-password flows over REST, with **JWT access + refresh tokens** persisted in `flutter_secure_storage`. A reusable `app_otp_field` widget exists under `core/widgets/inputs/` but is not yet wired into an OTP flow.

### 3.3 Storage *(Planned)*
- Buckets: `tutorial-media` (public-read where appropriate), `eye-photos` (**private, medical-sensitive** — signed URLs only, RLS-style storage policies keyed to owner), `post-media` (community; alt-text required at the application layer), `consultation-attachments` (private).
- **Current:** local persistence via `hive`/`hive_flutter`; secrets via `flutter_secure_storage`; image capture via `image_picker`. No remote buckets yet.

### 3.4 Realtime *(Planned)*
- Channels for **Connect** (new posts/replies), **SOS** (live location stream to caregivers + community), and **consultation signaling** (WebRTC offer/answer/ICE exchange).
- **Current:** only `internet_connection_checker` (connectivity awareness). No realtime/websocket transport.

### 3.5 Edge Functions (Deno / TypeScript) — server-only logic *(Planned)*
- `scene-describe`: proxies camera frames to the **cloud multimodal LLM**; keeps the LLM key server-side, applies rate limits, returns a concise description. (OCR/object detection stay **on-device** with ML Kit.)
- `sos-dispatch`: fans out SOS alerts (push via FCM, SMS, caregiver notifications) and persists the event.
- `send-notification`: generic FCM dispatch for reminders, booking updates, replies.
- `order-confirm` / `payment-webhook`: prosthetic order finalization and payment provider callbacks.
- Edge Functions are the **only** place a service-role key may be used; never ship it in the Flutter app.
- **Current:** push notifications are **local-only** (`flutter_local_notifications` + `timezone`). FCM is not yet integrated.

---

## 4. AI Pipeline (Vision AI "Aura") *(Planned)*

> The Opto Vision AI engine is **not yet implemented**. Importantly, the repository currently ships `google_mlkit_pose_detection` + `camera`, which is **body-pose detection inherited from the rehab template** — the wrong capability for Opto. It should be removed/replaced (Appendix A-4) with the ML Kit modules below.

| Capability | Approach | Where | Status |
| :-- | :-- | :-- | :-- |
| OCR (text/money, BI + EN, Rupiah) | Google ML Kit Text Recognition | **On-device** (< 1 s, offline-friendly) | ⛔ |
| Object detection & label | ML Kit Object Detection / TFLite | On-device | ⛔ |
| Color identification | On-device color CV | On-device | ⛔ |
| Natural-language scene description | Cloud multimodal LLM via `scene-describe` Edge Function | **Cloud** (< 3 s; brief offline fallback) | ⛔ |
| Iris/sclera color match (Prosthetic) | On-device color CV + calibration | On-device capture → ocularist review | ⛔ |
| Voice command intent (Aura Voice) | Speech-to-Text + NLU intent mapping → `go_router` | Hybrid | ⛔ |

**Hybrid strategy:** anything latency-critical or privacy-sensitive runs on-device; only rich contextual description leaves the device, and Aura announces via audio when cloud features are unavailable.

---

## 5. Connectivity & Offline
- Care tutorials and profile/accessibility settings are cached locally (**`hive`/`hive_flutter`** already in the stack) for offline access.
- On-device Vision AI keeps working offline (limited mode); Supabase reads degrade gracefully with cached data where safe (never cache medical-sensitive payloads beyond session need).
- `internet_connection_checker` provides connectivity state for graceful degradation.

---

## 6. Telemedicine *(Planned)*
- **Target:** WebRTC peer-to-peer with a TURN server; **signaling over Supabase Realtime** (no custom socket server). Recording is **opt-in** with explicit, read-aloud consent.
- Non-verbal mode is a structured instruction flow (audio/text) so the patient can aim the camera without two-way conversation; haptic/audio guidance assists positioning.
- **Current:** only `video_player` + `chewie` (one-way media playback). No WebRTC dependency yet.

---

## 7. Integrated Best Practices
- **Repositories over raw SDK:** widgets never call `SupabaseClient` (or `Dio`) directly; they depend on a feature repository returning domain entities, which makes RLS errors and offline states testable.
- **Typed models:** map every Postgres row to a Dart model with explicit `fromJson`/`toJson` (`freezed` available); treat nullable medical fields explicitly.
- **Security:** trust RLS, not the client. The Flutter app holds only the anon key. Any operation requiring elevated rights goes through an Edge Function.
- **Accessibility is part of "done":** a screen is not complete until it passes the screen-reader, contrast, tap-target, and haptic checks in `design_system.md`.

---

## Appendix A — Migration & Action-Item Backlog

Ordered roughly by dependency. Items A-1 and A-2 unblock most of the backend sections.

| # | Action | Scope | Priority |
| :-- | :-- | :-- | :-- |
| A-1 | **Backend migration: Dio/REST → Supabase.** Replace `core/config/api_client.dart`, `core/constants/api_endpoints.dart`, `http_status.dart` with a `core/supabase/` client provider; re-implement auth/data sources against `supabase_flutter`. Keep `flutter_secure_storage` for the biometric/session gate. | core, auth | High |
| A-2 | **Role rename `lansia` → `user`** across routes (`app_routes.dart`, `app_router.dart`), `roles_middleware.dart`, and models; align enum to `user / caregiver / doctor / admin`. | core, auth | High |
| A-3 | **Re-scope `dashboard/`**: remove rehab artifacts (`lansia_dashboard_screen.dart`, `recovery_progress_card.dart`) and rebuild as the Opto home surface; fold settings into the planned `profile/` feature. | features | High |
| A-4 | **Vision AI deps cleanup**: remove `google_mlkit_pose_detection`; add ML Kit Text Recognition + Object Detection + color CV; design the `vision_ai/` feature and `scene-describe` Edge Function. | features, backend | High |
| A-5 | **Branding rename**: `pubspec.yaml` `name: ids_elder_rehab_app` → `opto`; update every `package:ids_elder_rehab_app/...` import; rewrite `README.md` (currently describes the rehab app); update app description. | repo-wide | High |
| A-6 | **Stand up missing feature modules**: `profile`, `prosthetic_hub`, `consultation`, `connect`, `sos`, `map` — each with full `presentation/domain/data` layers + a BLoC. | features | Med |
| A-7 | **Accessibility core**: create `core/accessibility/` (Semantics helpers, haptic-pattern catalog, `announce()`); register **Atkinson Hyperlegible**; wire `textScaler` reflow up to 300% across `core/widgets/`. | core | Med |
| A-8 | **Aura Voice**: create `core/voice/` (STT + NLU), define `opto://` deep-link intents in `go_router`. | core | Med |
| A-9 | **Realtime, Storage buckets, FCM**: enable Supabase Realtime channels (Connect/SOS/consult signaling), create storage buckets with policies, integrate FCM via `send-notification`. | backend | Med |
| A-10 | **Telemedicine WebRTC**: add a WebRTC client + TURN, signal over Supabase Realtime; opt-in recording with read-aloud consent. | features, backend | Low |
| A-11 | **Dependency review**: confirm whether `model_viewer_plus` (AR 3D), `fl_chart`, `lottie`, `audioplayers`, `chewie` are needed for Opto or are rehab leftovers; remove unused. | repo-wide | Low |

---

## Appendix B — Current Dependency Inventory (from `pubspec.yaml`)

**Aligned with target:** `flutter_bloc`, `get_it`, `freezed_annotation`, `go_router`, `hive`/`hive_flutter`, `flutter_secure_storage`, `internet_connection_checker`, `path_provider`, `permission_handler`, `image_picker`, `camera`, `intl`, `phosphor_flutter`.

**Transitional / to replace:** `dio` + `flutter_dotenv` (REST → Supabase), `flutter_local_notifications` + `timezone` (local → add FCM), `video_player` + `chewie` (playback → add WebRTC for consult).

**Likely rehab leftovers (review/remove):** `google_mlkit_pose_detection`, `model_viewer_plus`, `fl_chart`, `lottie`, `audioplayers`.

**Missing for target (to add):** `supabase_flutter`, ML Kit Text Recognition + Object Detection, a Speech-to-Text package, a WebRTC package, `firebase_messaging`, Atkinson Hyperlegible font assets.
