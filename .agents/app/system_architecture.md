# System Architecture Brief — Opto

**Target Audience:** Flutter Engineers, Supabase/Backend Engineers, Software Architect
**Architecture Type:** Flutter **Clean Architecture (feature-first)** mobile client on top of a **Supabase** backend (Postgres + RLS, Auth, Storage, Realtime, Edge Functions).

## 1. Communication Concepts & Main Paradigms

Opto is a single Flutter codebase (Android + iOS) talking directly to Supabase. There is **no separate REST/Node API** — the Flutter client uses the official `supabase_flutter` SDK and reaches Postgres through PostgREST, Storage, Realtime, and Edge Functions. Security is enforced **at the database layer** via Row Level Security (RLS), never solely in the client.

- **Client (Flutter + Riverpod):** screens, state, and accessibility live here. The client calls Supabase via repositories; it never embeds service-role keys.
- **Backend (Supabase):** Postgres schema + RLS policies are the source of truth for authorization. Server-side logic that must not run on the client (cloud LLM proxy, payment, push fan-out, SOS dispatch) lives in **Edge Functions** (Deno/TypeScript). Realtime channels power Connect, SOS, and consultation signaling. Storage holds media (tutorial videos, eye photos) with bucket-level policies.

## 2. Client Architecture (Flutter — Clean Architecture, Feature-First)

Each of the eight modules is an isolated feature module. Layers per feature: `presentation` (UI + state) → `domain` (entities, use cases) → `data` (repositories, data sources).

```
lib/
├── core/                       # foundation, no business logic
│   ├── accessibility/          # Semantics helpers, haptic patterns, announce()
│   ├── theme/                  # ColorScheme tokens (light default; dark/high-contrast), text scaler
│   ├── router/                 # go_router config + deep links for Aura Voice intents
│   ├── supabase/               # SupabaseClient provider, error mapping
│   ├── voice/                  # STT + intent mapping (Aura Voice engine)
│   ├── widgets/                # accessible primitives (A11yButton, A11yCard, A11yField)
│   └── utils/                  # formatters, result types
├── features/
│   ├── onboarding/             # presentation / domain / data
│   ├── vision_ai/              # Aura: scene description, OCR, object/color
│   ├── prosthetic_hub/         # catalog, custom order, tutorials, reminders
│   ├── consultation/           # doctors, booking, WebRTC non-verbal consult, history
│   ├── connect/                # community threads
│   ├── sos/                    # Emergency SOS triggers + dispatch
│   ├── map/                    # Accessibility Map
│   └── profile/                # settings, caregiver linking, medical data export/delete
└── shared/                     # cross-feature models/value objects (use sparingly)
```

**Golden Rule:** `core/` must not import from `features/`, and feature folders must not import each other directly. Cross-feature needs go through `shared/` or an exported `domain` contract.

### State Management
- **Riverpod** is the standard for state & dependency injection (lightweight DI, highly testable). BLoC is acceptable for very event-heavy flows (SOS, WebRTC signaling) if a feature lead justifies it.
- Server state is fetched through feature repositories and exposed via providers; avoid scattering raw `SupabaseClient` calls in widgets.

### Navigation
- **`go_router`** with named routes and deep links so **Aura Voice** can jump straight to any screen/intent (e.g. `opto://prosthetic/order`, `opto://sos`). Every voice command maps to a route + intent payload.

### Accessibility-Native (mandatory, see `design_system.md`)
- `Semantics` / `MergeSemantics` / `ExcludeSemantics` on every interactive/decorative element.
- Live regions via `SemanticsService.announce` for dynamic status (Vision AI result, form errors, "SOS sent").
- `HapticFeedback` driven by the shared haptic-pattern catalog.
- `MediaQuery.textScaler` honored up to 300% with reflow (no overflow/clipping).

## 3. Backend Architecture (Supabase)

### 3.1 Postgres + Row Level Security (authorization source of truth)
- Every table that holds user or medical data has **RLS enabled**. Default deny; policies grant access by `auth.uid()` ownership or by an explicit caregiver/role relationship.
- Roles are modeled in a `profiles.role` enum (`user`, `caregiver`, `doctor`, `admin`) plus relationship tables (e.g. `caregiver_links`). Doctors only see consultations they are assigned to; caregivers only see linked users' permitted data.
- Medically sensitive tables (`anthropometric_data`, `eye_photos`, `consultations`) carry the strictest policies and are never exposed to community/feed queries.

### 3.2 Auth
- Supabase Auth with **phone OTP** (and email OTP) + on-device **biometric unlock** for the local session. **No visual CAPTCHA** anywhere. Biometric gate is a client-side re-auth over a valid Supabase session, not a replacement for it.

### 3.3 Storage
- Buckets: `tutorial-media` (public-read where appropriate), `eye-photos` (**private, medical-sensitive** — signed URLs only, RLS-style storage policies keyed to owner), `post-media` (community; alt-text required at the application layer), `consultation-attachments` (private).

### 3.4 Realtime
- Channels for **Connect** (new posts/replies), **SOS** (live location stream to caregivers + community), and **consultation signaling** (WebRTC offer/answer/ICE exchange).

### 3.5 Edge Functions (Deno / TypeScript) — server-only logic
- `scene-describe`: proxies camera frames to the **cloud multimodal LLM**; keeps the LLM key server-side, applies rate limits, returns a concise description. (OCR/object detection stay **on-device** with ML Kit.)
- `sos-dispatch`: fans out SOS alerts (push via FCM, SMS, caregiver notifications) and persists the event.
- `send-notification`: generic FCM dispatch for reminders, booking updates, replies.
- `order-confirm` / `payment-webhook`: prosthetic order finalization and payment provider callbacks.
- Edge Functions are the **only** place a service-role key may be used; never ship it in the Flutter app.

## 4. AI Pipeline (Vision AI "Aura")

| Capability | Approach | Where |
| :-- | :-- | :-- |
| OCR (text/money, BI + EN, Rupiah) | Google ML Kit Text Recognition | **On-device** (< 1 s, offline-friendly) |
| Object detection & label | ML Kit Object Detection / TFLite | On-device |
| Color identification | On-device color CV | On-device |
| Natural-language scene description | Cloud multimodal LLM via `scene-describe` Edge Function | **Cloud** (< 3 s; brief offline fallback) |
| Iris/sclera color match (Prosthetic) | On-device color CV + calibration | On-device capture → ocularist review |
| Voice command intent (Aura Voice) | Speech-to-Text + NLU intent mapping → `go_router` | Hybrid |

**Hybrid strategy:** anything latency-critical or privacy-sensitive runs on-device; only rich contextual description leaves the device, and Aura announces via audio when cloud features are unavailable.

## 5. Connectivity & Offline
- Care tutorials and profile/accessibility settings are cached locally (e.g. Hive/Drift) for offline access.
- On-device Vision AI keeps working offline (limited mode); Supabase reads degrade gracefully with cached data where safe (never cache medical-sensitive payloads beyond session need).

## 6. Telemedicine
- WebRTC peer-to-peer with a TURN server; **signaling over Supabase Realtime** (no custom socket server). Recording is **opt-in** with explicit, read-aloud consent.
- Non-verbal mode is a structured instruction flow (audio/text) so the patient can aim the camera without two-way conversation; haptic/audio guidance assists positioning.

## 7. Integrated Best Practices
- **Repositories over raw SDK:** widgets never call `SupabaseClient` directly; they depend on a feature repository returning domain entities, which makes RLS errors and offline states testable.
- **Typed models:** map every Postgres row to a Dart model with explicit `fromJson`/`toJson`; treat nullable medical fields explicitly.
- **Security:** trust RLS, not the client. The Flutter app holds only the anon key. Any operation requiring elevated rights goes through an Edge Function.
- **Accessibility is part of "done":** a screen is not complete until it passes the screen-reader, contrast, tap-target, and haptic checks in `design_system.md`.
