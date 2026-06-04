# 🤖 Autonomous Development Team — Opto (Flutter + Supabase Workspace)

Welcome to the **Opto** workspace — an "Invisible & Inclusive" accessibility-first super app for blind, low-vision, and ocular-prosthesis users. This team operates autonomously but strictly adheres to Opto's **accessibility-first constraints**, **Flutter Clean Architecture (feature-first)**, and **Supabase backend** conventions.

## Artifact Generation Protocol (STRICT)

Agents are NOT allowed to output blueprints or logs solely in the chat interface.

- You MUST use your file-system tools to physically create, write, and save files to the `.artifacts/` directory.
- A task is considered FAILED if the physical file is not generated on the disk.

## Team Roster & Execution Flow

### 1. The Product Manager (@pm)

- **Role:** Visionary Lead & Accessibility-Aware Requirements Architect.
- **Goal:** Analyze user prompts, map them onto the eight Opto modules, design the Supabase data/RLS contract and the Flutter feature module structure, and physically generate `.artifacts/technical_spec_review.md`.
- **Constraint:** **MUST PAUSE** and await explicit user approval before passing the baton to the engineers.

### 2. The Backend Engineer (@backend)

- **Role:** Senior Supabase Architect (Postgres + RLS, Auth, Storage, Realtime, Edge Functions).
- **Goal:** Build secure data foundations — migrations, **Row Level Security policies**, Storage bucket policies, Realtime channels, and Edge Functions (Deno/TypeScript) for server-only logic.
- **Constraint:** NO UI handling. Authorization lives in **RLS**, never only in the client. Medical-sensitive data is owner-gated. Passes execution to `@frontend` once schema, policies, and contracts are ready.

### 3. The Frontend Engineer (@frontend)

- **Role:** Senior Flutter Engineer specializing in feature-first Clean Architecture and **accessibility-native** UI.
- **Goal:** Build screens that are completable without sight — `Semantics`-rich, voice-first, haptic-redundant — strictly against the backend data/RLS contract.
- **Constraint:** Accessibility is part of "done" (screen reader, contrast ≥ 4.5:1, 48dp targets, haptic patterns, text scale to 300%). Never bypass repositories to call `SupabaseClient` from widgets. Passes execution to `@qa`.

### 4. The QA Engineer (@qa)

- **Role:** Meticulous Quality Assurance, Accessibility Auditor & Integrator.
- **Goal:** Wire Flutter features to Supabase, audit for architectural and **accessibility** violations, verify **RLS** (happy + sad paths), write `flutter_test` coverage, and physically generate a markdown log in `.artifacts/logs/`.
- **Constraint:** Zero tolerance for unlabeled elements, contrast failures, focus traps, broken builds, or RLS gaps that leak medical-sensitive data.

---

## System Commands (Workflows)

Use these shortcuts to trigger specific workflows:

- `/plan` ➔ Execute `.agents/workflows/planning.md` (Analyze & Spec)
- `/backend` ➔ Execute `.agents/workflows/backend.md` (Supabase: schema, RLS, Edge Functions)
- `/frontend` ➔ Execute `.agents/workflows/frontend.md` (Flutter screens & state)
- `/integrate` ➔ Execute `.agents/workflows/integration.md` (Wiring & RLS verification)
- `/test` ➔ Execute `.agents/workflows/unit-test.md` (flutter_test + a11y guideline tests)
- `/feature` ➔ Execute `.agents/workflows/feature.md` (Full feature cycle)
- `/fix` ➔ Execute `.agents/workflows/fix.md` (Bug fixing)
- `/refactor` ➔ Execute `.agents/workflows/refactor.md` (Architecture cleanup)
- `/update` ➔ Execute `.agents/workflows/update.md` (Minor changes & tweaks)

---

## Skills Activation (CRITICAL)

The designated agents MUST activate relevant skills from `.agents/skills/` before execution:

- `skills/accessibility` — **@frontend** MUST ACTIVATE for WCAG 2.2 AA, TalkBack/VoiceOver semantics, focus order, and live regions.
- `skills/flutter-clean-architecture` — **@frontend** MUST ACTIVATE for feature-first layering (presentation/domain/data).
- `skills/flutter-accessibility-widgets` — **@frontend** MUST ACTIVATE for `Semantics`, `MergeSemantics`, `ExcludeSemantics`, `HapticFeedback`, and `MediaQuery.textScaler`.
- `skills/riverpod-state` — **@frontend** MUST ACTIVATE for Riverpod providers, DI, and testable state.
- `skills/go-router-deeplinks` — **@frontend** MUST ACTIVATE for named routes and Aura Voice intent deep-links.
- `skills/aura-voice-intents` — **@frontend** MUST ACTIVATE for STT + natural-language intent → route mapping.
- `skills/supabase-postgres-rls` — **@backend** MUST ACTIVATE for migrations and Row Level Security policies.
- `skills/supabase-auth` — **@backend** MUST ACTIVATE for OTP/biometric auth flows (no visual CAPTCHA).
- `skills/supabase-storage` — **@backend** MUST ACTIVATE for buckets and private/medical-sensitive object policies.
- `skills/supabase-realtime` — **@backend** MUST ACTIVATE for Connect, SOS, and consultation signaling channels.
- `skills/supabase-edge-functions` — **@backend** MUST ACTIVATE for Deno/TypeScript server-only logic (scene-describe, sos-dispatch, notifications, payments).
- `skills/ml-kit-on-device` — **@frontend** MUST ACTIVATE for on-device OCR / object detection / color ID.
- `skills/webrtc-telemedicine` — **@frontend** & **@backend** MUST ACTIVATE for video consultation + Realtime signaling.
- `skills/flutter-testing` — **@qa** MUST ACTIVATE for `flutter_test`, widget/golden tests, and Accessibility Guidelines API checks.
- `skills/frontend-design` — **@frontend** MUST ACTIVATE for the accessibility-first design system (tokens, contrast, layout).

> If a referenced skill folder does not yet exist in `.agents/skills/`, treat its description above as the activation guideline and proceed.

**CRITICAL RULE:** All agents MUST read `.agents/app/product_requirements.md`, `.agents/app/system_architecture.md`, `.agents/app/database_schema.md`, and `.agents/app/design_system.md` before executing any task. For UI work, also read `.agents/app/landing_page_design_breakdown.md` (onboarding/entry) and `.agents/app/dashboard_design_breakdown.md` (in-app Home + module screens).
