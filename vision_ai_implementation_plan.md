# Vision AI ("Aura") — Implementation Plan on the Gemini Free Plan

> **Scope:** Phase 3F (`opto_backend_implementation_plan.md`) — all Vision AI sub-features,
> operated on the **Gemini free plan** under the conditions flagged in
> `vision_ai_gemini_free_plan_research.md` §4.
> Cross-refs: `system_architecture.md` §4 (AI pipeline), `design_system.md` §12.2 / §15.2, `CLAUDE.md`.
>
> **Date:** June 2026 · **Status note:** the feature is **already implemented for the paid tier**.
> This plan is the **reconciliation + guardrail delta** to run it on the free plan within the
> research's conditions — *not* a from-scratch build.

---

## 0. Reality check (codebase scan result)

The full `presentation → domain → data` stack **already exists and is wired**:

- **Edge Function** `supabase/functions/scene-describe/index.ts` — Gemini 2.5 Flash-Lite, BI
  system prompt, proxy-and-discard, in-memory per-user rate limit (20/hr), `verify_jwt = true`,
  model swappable via `SCENE_DESCRIBE_MODEL`.
- **On-device** `ml_kit_vision_datasource.dart` (OCR + object), `color_detector.dart` (pure-Dart
  CV), `image_compressor.dart` (1024px/JPEG-85 in an isolate).
- **Cloud** `scene_describe_remote_datasource.dart` → `vision_repository_impl.dart` (layered
  offline/error fallback) → `vision_ai_cubit.dart` + freezed state → `vision_ai_screen.dart`
  (announce / Semantics / mode chips). **DI** registered; **route** `/vision-ai` wired with a
  voice-intent `VisionMode extra`.
- **pubspec.yaml** has `google_mlkit_text_recognition`, `google_mlkit_object_detection`,
  `camera`, `image_picker`, `image`, `permission_handler`, `supabase_flutter`. **No
  `google_mlkit_pose_detection` leftover** — Appendix A-4 dependency cleanup is done.

**Consequence:** the entire codebase is currently authored for the **paid** tier and explicitly
forbids the free tier for real frames. Switching to the free plan is therefore a deliberate,
guarded **development-only** posture (per research §4), plus a few correctness fixes — see §3.

---

## 1. Pre-condition check

| Pre-condition | Status | Evidence |
|---|---|---|
| **Phase 2 done — `core/voice/` exists** | ✅ Met | `lib/core/voice/` has `aura_tts.dart`, `intent_parser.dart`, `speech_recognizer.dart`, `voice_controller.dart`, `voice_intent.dart`. Cubit speaks results via `sl<AuraTts>()`. |
| **ML Kit dependencies present** | ✅ Met | `pubspec.yaml:67,69` (text + object recognition); color is pure-Dart `dart:ui`; pose-detection leftover removed. |
| **Camera / image / permission deps** | ✅ Met | `camera ^0.11.4`, `image_picker ^1.2.1`, `image`, `permission_handler ^12.0.1`. |
| **Gemini API key configured** | ⚠️ Manual | Edge Function reads `GEMINI_API_KEY` secret; not committed. Must be set via `supabase secrets set GEMINI_API_KEY=…`. On the **free plan** this is a free-tier key. |
| **Environment flag for dev-gating** | ✅ Met | `AppInfo.isDevelopment` / `isProduction` (`lib/core/config/app_info.dart`) from `APP_ENV_MODE`. |
| **Local persistence for consent** | ✅ Met | `lib/core/config/hive_client.dart`; `accessibility_settings_repository_impl.dart` precedent. |

### 🔴 Blockers (must be acknowledged before shipping on the free plan)

1. **Free tier trains on inputs + outputs (UU PDP).** Sending real users' camera frames to the
   free tier is non-compliant (`research` §3 blocker #1). **Mitigation in this plan:** scene
   description on the free plan is **hard-gated to `AppInfo.isDevelopment`** and, where a cloud
   call is allowed, sits behind a one-time **consent gate**. In `isProduction`, the free-tier
   cloud path is disabled and the app uses the on-device fallback.
2. **Quota is per-project (~1,000 RPD / 15 RPM, Flash-Lite).** Shared across all users; cannot
   serve a user base (`research` §3 blocker #2). **Mitigation:** keep the Edge Function rate
   limiter, add explicit `429` handling, and treat free-tier scene description as a
   dev/demo-only capability.
3. **No free high-capability fallback** (2.5 Pro free tier removed Apr 2026). Accept Flash-Lite
   quality; no action beyond pinning the model id behind `SCENE_DESCRIBE_MODEL`.

> **Production exit:** the only real production path for scene description is enabling billing
> (paid Gemini / Vertex). This plan keeps the swap to one secret change
> (`SCENE_DESCRIBE_MODEL` + a billing-enabled `GEMINI_API_KEY`) and one config flag — no code
> change — exactly as the existing switchable-adapter design intends.

---

## 2. Sub-feature plan

| Sub-feature | Where it runs | Model | Free-plan quota/privacy guard |
|---|---|---|---|
| **OCR — "Read text"** (BI+EN, Rupiah) | On-device ML Kit `TextRecognizer` | n/a (no Gemini) | None needed — never leaves device. Production-ready as-is. |
| **Object — "Identify"** | On-device ML Kit `ObjectDetector` | n/a | None needed — production-ready as-is. |
| **Colors** | On-device pure-Dart CV (`ColorDetector`) | n/a | None needed — production-ready as-is. Also feeds prosthetic iris match. |
| **Scene description — "Describe scene"** | Cloud via `scene-describe` Edge Function | **`gemini-2.5-flash-lite`** (free tier; default free model `gemini-flash` also OK via env) | **All of:** dev-only gate (`AppInfo.isDevelopment`), one-time consent sheet before first cloud call, proxy-and-discard (exists), Edge-Function per-user rate limit (exists) + explicit `429`→quota message, graceful on-device fallback (exists). |
| **Navigation assistance (P2)** | On-device cues (escalating haptic) only | n/a in this phase | Out of scope for Phase 3F cloud work; do **not** add a cloud frame path (would inherit both blockers). |
| **Aura voice output** | On-device TTS (`AuraTts`) + on-device intent parser | n/a | None needed. If Gemini ever parses voice intents, that transcript path inherits the training blocker — keep intent parsing on-device. |

**Net:** 4 of 6 sub-features (OCR, object, colors, voice) are fully on-device and **production-ready
now**. Only **scene description** touches the free plan, and only in **development**.

---

## 3. Ordered file plan (dependency-safe)

> Order: error types → config/env → backend → data → domain → repository → presentation → docs.
> Most entries are **MODIFY** (reconcile paid→free-with-conditions and fix stale comments).
> No deletions required.

1. **MODIFY** `lib/core/error/failures.dart`
   Add `class RateLimitFailure extends Failure` (distinct from `ServerFailure`) so quota
   exhaustion (`429`) can be surfaced with its own spoken message rather than the generic
   offline fallback.

2. **MODIFY** `lib/core/constants/app_env_keys.dart`
   Add `static const String sceneDescribeTier = 'SCENE_DESCRIBE_TIER';` (values `free` | `paid`,
   default `free`) so the free/paid posture is config-driven and testable.

3. **CREATE** `lib/features/vision_ai/data/vision_ai_config.dart`
   Small helper: `VisionAiConfig.isFreeTier` (reads `SCENE_DESCRIBE_TIER`) and
   `VisionAiConfig.cloudSceneAllowed` = `!isFreeTier || AppInfo.isDevelopment`. Single source of
   truth for the dev-gate decision.

4. **MODIFY** `supabase/functions/scene-describe/index.ts`
   - Map Gemini upstream **`429`** to a distinct response (`{ "error": "...", "code": "quota" }`,
     HTTP 429) with a BI quota message; keep existing in-memory limiter.
   - Reconcile the header comment block from "paid tier (mandatory)" to "free plan = dev-only
     under UU PDP conditions; paid for production" (mirror research §4).

5. **MODIFY** `supabase/config.toml`
   Update the `[functions.scene-describe]` comment block (lines ~388–405) to describe the
   free-plan dev-only posture + conditions instead of "paid mandatory". `verify_jwt = true`
   stays.

6. **MODIFY** `lib/features/vision_ai/data/datasources/scene_describe_remote_datasource.dart`
   - Detect the `429`/`code: "quota"` response and throw the new `RateLimitFailure`.
   - Reconcile the doc comment (paid→free-with-conditions; keep proxy-and-discard note).

7. **MODIFY** `lib/features/vision_ai/domain/entities/vision_mode.dart`
   Fix stale comment on `describeScene` (line ~16): "Claude multimodal LLM" → "Gemini 2.5
   Flash-Lite via `scene-describe`".

8. **MODIFY** `lib/features/vision_ai/domain/repositories/vision_repository.dart`
   Fix stale "Claude LLM" comments (lines ~33–35) → "Gemini 2.5 Flash-Lite".

9. **MODIFY** `lib/features/vision_ai/domain/entities/vision_result.dart`
   Extend `SceneResultSource` with `quotaExhausted` (distinct from `offlineFallback`) and a
   matching spoken BI line in `toSpokenString()` ("Batas harian deskripsi tercapai — coba lagi
   besok. OCR masih berfungsi."). Keeps the UI from conflating "offline" with "quota hit".

10. **MODIFY** `lib/features/vision_ai/data/repositories/vision_repository_impl.dart`
    - Before the cloud attempt, gate on `VisionAiConfig.cloudSceneAllowed`; when not allowed
      (free tier + production), skip the cloud call and return the on-device fallback with a
      spoken "scene description disabled in this build" notice.
    - Catch the new `RateLimitFailure` → on-device fallback tagged `quotaExhausted`.

11. **CREATE** `lib/features/vision_ai/presentation/widgets/scene_consent_sheet.dart`
    One-time, screen-reader-first consent sheet shown before the **first** cloud scene
    description: explains the frame is sent to Google's free-tier Gemini and may be used to
    improve models; requires explicit "Setuju / Agree". Persists the decision via
    `hive_client.dart`. (UU PDP consent, research §4 conditional path.)

12. **MODIFY** `lib/features/vision_ai/presentation/cubit/vision_ai_cubit.dart`
    For `VisionMode.describeScene`: check persisted consent (and `cloudSceneAllowed`) before
    `_analyze`; if not yet consented, emit a state that asks the screen to present the consent
    sheet; proceed only on agreement. Speak the `quotaExhausted` message distinctly when that
    source is returned.

13. **MODIFY** `lib/features/vision_ai/presentation/cubit/vision_ai_state.dart`
    Add a `consentRequired` state (carrying `mode`) so the screen can show the sheet; run
    `build_runner` to regenerate `vision_ai_state.freezed.dart` (do **not** hand-edit the
    generated file).

14. **MODIFY** `lib/features/vision_ai/presentation/screens/vision_ai_screen.dart`
    - Handle `consentRequired` → present `SceneConsentSheet`; on agree, call
      `cubit.capture()`/re-run.
    - Announce the `quotaExhausted` message via both `AuraTts` and `SemanticsService` (same
      belt-and-suspenders pattern already used for offline).

15. **MODIFY** `lib/core/di/dependencies_injection_container.dart`
    No new singletons required (config helper is static); confirm registration order unchanged.
    Only touch if the consent persistence needs a registered dependency.

16. **MODIFY** `vision_ai_model_research.md` *(optional housekeeping)*
    Add a one-line pointer to this plan and to `vision_ai_gemini_free_plan_research.md` so the
    "paid tier" recommendation reads alongside the free-plan dev decision.

---

## 4. Risk flags

| # | Risk | Mitigation in this plan |
|---|---|---|
| 1 | **Free-tier quota exhaustion** (1,000 RPD / 15 RPM, per project, shared across all users) | New `RateLimitFailure` + Edge `429` mapping → on-device fallback tagged `quotaExhausted` with a distinct spoken BI message; existing Edge per-user limiter (20/hr) retained; scene description treated as a dev/demo capability, not a user-scale feature. |
| 2 | **UU PDP — camera frames on free tier (trains on data)** | Hard dev-gate (`AppInfo.isDevelopment` via `VisionAiConfig.cloudSceneAllowed`); one-time consent sheet before first cloud call; proxy-and-discard already enforced server-side (no Storage write, no frame logging); production builds disable the free-tier cloud path entirely. |
| 3 | **Offline / cloud-unavailable per sub-feature** | OCR / object / colors are fully on-device — unaffected. Scene description already degrades: offline → on-device object labels (`offlineFallback`); timeout (>8s) and Gemini `5xx` → same path; now `429` → `quotaExhausted`. UI never goes silent (`design_system.md` §12.2): every path speaks + announces. |
| 4 | **Posture drift (free key reused in prod)** | `SCENE_DESCRIBE_TIER` + `cloudSceneAllowed` make the gate explicit and unit-testable; production exit is a single secret/flag change with no code edit. |

---

## 5. Verification

- **Static:** `flutter analyze` clean; `flutter pub run build_runner build --delete-conflicting-outputs`
  after the freezed state change (step 13).
- **Unit:** repository tests — (a) free tier + production ⇒ no cloud call, on-device fallback;
  (b) `429` ⇒ `quotaExhausted` source; (c) offline ⇒ `offlineFallback`. Cubit test — consent
  gate blocks the first cloud call until agreement.
- **Edge Function:** `supabase functions serve scene-describe --env-file .env.local` with a
  **non-sensitive** test JPEG; assert BI output < 3 s and a `429` mapping when the free quota
  trips.
- **On-device (real device):** OCR (Rupiah note), object identify, color detect all work in
  airplane mode; TalkBack/VoiceOver reads every result; consent sheet is reachable and operable
  without sight; quota/offline messages are spoken and announced.
- **Accessibility regression:** mode chips, shutter, consent sheet — 48dp targets, contrast,
  300% text reflow (`design_system.md` §15.4).

---

## Sources / inputs
- `vision_ai_gemini_free_plan_research.md` (free-tier quota, training policy, conditional path)
- `vision_ai_model_research.md` (model choice, BI quality, proxy-and-discard pattern)
- `opto_backend_implementation_plan.md` §3F · `system_architecture.md` §4 · `design_system.md` §12.2/§15.2 · `CLAUDE.md`
