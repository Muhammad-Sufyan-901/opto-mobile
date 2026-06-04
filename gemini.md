# GEMINI.md

This file provides guidance to GEMINI when working with code in this repository.

## ⚠️ Read the system briefs first

**Before generating or modifying any code, consult the canonical system briefs in `.agents/app/`.** They are the source of truth and override the legacy `README.md` / `gemini.md` (which still describe the old rehab template):

| Brief | Use it for |
|-------|-----------|
| `.agents/app/product_requirements.md` | What to build — the 8 modules, personas, workflows, scope, roadmap |
| `.agents/app/system_architecture.md` | How it's structured — layering, state mgmt, Supabase backend, **current-vs-target gap + migration backlog (Appendix A)** |
| `.agents/app/database_schema.md` | Data shapes, enums, and **RLS policies** (Supabase/Postgres) |
| `.agents/app/design_system.md` | Tokens, typography, components, haptics, voice, screen-reader rules, screen-by-screen anatomy |

When a task touches a feature, open the relevant brief(s) and follow them. If code and a brief disagree, the brief describes the intended target — check `system_architecture.md` §0 to see whether that area is `✅ Built`, `🟡 Partial`, or `⛔ Planned` before assuming the code is correct.

## What this project actually is

**Opto** — *"Your world, made clear."* An accessibility-first **super app** (Flutter, Android + iOS) for **blind, low-vision, and ocular-prosthesis users**. Every feature must be completable **without looking at the screen**. Eight modules: Prosthetic Hub, Health & Consultation, Vision AI ("Aura"), Connect (community), Emergency SOS, Accessibility Map, Aura Voice, Profile/Settings.

> **The repo was scaffolded by renaming a different project ("IDS Elder Rehab App") and is mid-migration.** The package is still `ids_elder_rehab_app`, `README.md`/`gemini.md` describe the rehab app, and several dependencies (`google_mlkit_pose_detection`, `model_viewer_plus`, etc.) are rehab leftovers. Treat `README.md`/`gemini.md` as **stale**; defer to `.agents/app/`.

## Commands

```bash
# Install dependencies
flutter pub get

# Run code generation (required after creating/modifying Freezed/json_serializable classes)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app (real device strongly recommended for camera/Vision AI features)
flutter run

# Analyze / lint
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart
```

## Architecture

**Feature-First Clean Architecture** on a (target) **Supabase** backend. State management is **BLoC (`flutter_bloc`) + GetIt** service locator — this is the implemented and intended stack. (Note: the PRD mentions Riverpod, but `system_architecture.md` reconciles that to **BLoC + GetIt** as the actual stack — follow the architecture brief.)

Every feature under `lib/features/[name]/` splits into three layers:
- `data/` — DTOs/models, data sources (Supabase; Dio today — legacy), repository implementations
- `domain/` — pure Dart entities, repository contracts, use cases (single `call()`)
- `presentation/` — BLoC (events/states via `freezed`), screens, feature-scoped widgets

`lib/core/` holds cross-cutting concerns only. **Golden rule:** `core/` must not import from `features/`, and features must not import each other directly — cross-feature needs go through `shared/` or an exported `domain` contract.

### Key files

| File | Purpose |
|------|---------|
| `lib/main.dart` | Entry point — loads `.env`, inits Hive, runs GetIt DI, then `runApp` |
| `lib/app.dart` | Root widget — themes + GoRouter |
| `lib/core/router/app_router.dart` | **Single source of truth for routes** |
| `lib/core/constants/app_routes.dart` | Route path/name constants (`AppRoutes`) |
| `lib/core/di/dependencies_injection_container.dart` | GetIt registrations (`sl`) |
| `lib/core/middlewares/authentication_middleware.dart` | Global auth guard (token → redirect) |
| `lib/core/middlewares/roles_middleware.dart` | Role-based route guard |
| `lib/core/config/api_client.dart` | Dio REST client — **legacy, scheduled for Supabase replacement** |

### Routing

- All routes live in `app_router.dart`. **Never use `Navigator.push`** — use `context.go()` / `context.push()`.
- Global auth guard runs via GoRouter's top-level `redirect` (`AuthenticationMiddleware.guard`).
- Role guards apply per `ShellRoute` via `RolesMiddleware.requireRole()`.
- The `/developer` route is registered only when `AppInfo.isDevelopment`.
- **Target:** add `opto://` deep links so Aura Voice intents map to routes (e.g. `opto://prosthetic/order`, `opto://sos`).

### Global UI component library (`lib/core/widgets/`)

A shadcn-style set of accessible primitives — a key asset for building the Opto design system. Existing groups: `accordions`, `alerts`, `badges`, `breadcumbs`, `buttons`, `calendars`, `cards`, `dropdowns`, `forms`, `inputs` (incl. `app_otp_field`), `sliders`, `switches`, `tables`, `tabs`. Feature-specific widgets go in `features/[name]/presentation/widgets/`.

## Non-negotiable rules

### Accessibility is part of "done" (the whole point of this app)
Follow `design_system.md` §9, §15.4. Every screen:
- Wrap interactive elements in `Semantics`/`MergeSemantics`; exclude decorative art with `ExcludeSemantics`.
- Announce dynamic status (Vision AI result, form errors, "SOS sent") via live regions (`SemanticsService.announce` / `liveRegion: true`).
- Tap targets ≥ **48×48 dp**; honor `MediaQuery.textScaler` up to **300%** with reflow (no clipping/overflow).
- Contrast ≥ 4.5:1 text (≥ 3:1 large/borders). **Never encode meaning by color alone** — pair with text + icon + audio + haptic.
- Drive haptics from the shared catalog (`design_system.md` §6); the long pulsing **danger/SOS** pattern is reserved and never reused.
- Provide an **Aura Voice** path for the screen's core task. **No visual CAPTCHA anywhere.**
- Default theme is **Light** (blue-on-white); Dark and High-Contrast are user options. Tokens are authored in OKLCH (see `design_system.md` §2). Primary font: **Atkinson Hyperlegible**.

### Data, security & state
- **RLS is the authorization source of truth**, not the client. The Flutter app holds only the Supabase anon key; any elevated operation goes through an **Edge Function**. See `database_schema.md`.
- **Medically sensitive (🔒) tables** (`anthropometric_data`, `eye_photos`, `consultations`, SOS) are owner-only and must **never** appear in community/map/catalog joins, nor be cached beyond session need.
- Widgets never call `SupabaseClient`/`Dio` directly — depend on a feature **repository** returning domain entities.
- Use `flutter_bloc` for business logic/state; `setState` only for localized UI toggles.
- Models/states/events use `freezed` + `json_serializable` — no manual `fromJson`/`toJson`. Run `build_runner` after changes.
- No `dynamic`; prefer `const` constructors; return typed `Failure`s (`lib/core/error/failures.dart`).

## Current state vs. target (migration in progress)

Before working in an area, check its status in `system_architecture.md` §0 and the **migration backlog (Appendix A)**. Highlights:

- **Backend:** currently Dio/REST + custom JWT (`core/config/api_client.dart`, `api_endpoints.dart`) → migrating to `supabase_flutter` (A-1).
- **Roles:** legacy `lansia` role must become `user`; align enum to `user / caregiver / doctor / admin` (A-2).
- **`dashboard/` feature:** contains rehab leftovers (`lansia_dashboard_screen`, `recovery_progress_card`) to be re-scoped into the Opto home/profile surface (A-3).
- **Vision AI:** repo ships `google_mlkit_pose_detection` (wrong — body pose from the rehab app); replace with ML Kit Text Recognition + Object Detection + color CV, plus a `scene-describe` Edge Function (A-4).
- **Built today (`✅`):** `onboarding`, `auth` (REST), `core/router`, `core/widgets`, DI container. **Planned (`⛔`):** `vision_ai`, `prosthetic_hub`, `consultation`, `connect`, `sos`, `map`, `profile`, `core/accessibility/`, `core/voice/`, `core/supabase/`.

When implementing a `⛔ Planned` feature, build the full `presentation/domain/data` stack with a BLoC, follow the matching brief, and use the existing `core/widgets/` primitives.
