# DESIGN BREAKDOWN: Opto — Onboarding & Entry Flow (Flutter)

### _Accessibility-first first-run, setup, and authentication for blind, low-vision, and ocular-prosthesis users_

> This document is the Flutter equivalent of a "landing" experience: the very first screens a user meets. The web landing page is **out of scope** for the mobile client (web is for marketing/admin only). Everything here must be completable **100% via TalkBack/VoiceOver**, voice-first, and haptic-redundant. All colors come from `ColorScheme` tokens — never hardcode hex. See `design_system.md` for the canonical token, haptic, and voice catalogs.

---

## PART 1 — DESIGN TOKENS (Entry Context)

### 1.1 Theme & Color

- **Default theme on first launch: High-Contrast** (pure black surface, white text, `#3DA9FF` primary). If the OS reports an active screen reader or large font scale, Opto pre-selects High-Contrast and announces it.
- Tokens used here: `surface`, `onSurface`, `primary`, `onPrimary`, `success`, `danger`, `focusRing`. No decorative gradients, no imagery that carries meaning.
- Focus ring: ≥ 3px, `focusRing` color, always visible on the focused control.

### 1.2 Typography (Entry Context)

| Role                | Size @1.0 | Weight | Notes                                         |
| :------------------ | :-------- | :----- | :-------------------------------------------- |
| Screen title (`H1`) | 28sp      | 700    | one per screen, first in focus order          |
| Step heading (`H2`) | 22sp      | 600    |                                               |
| Body                | 18sp      | 400    | larger than app default for first-run clarity |
| Helper / hint       | 16sp      | 400    | also exposed as `Semantics.hint`              |

- Font: **Atkinson Hyperlegible**. All text honors `MediaQuery.textScaler` to 300% with reflow.

### 1.3 Layout & Spacing

- Single-column, one primary decision per screen. Vertical rhythm in multiples of 8dp; screen padding 24dp.
- Primary action pinned to a reachable bottom zone; secondary ("Skip", "Replay audio") clearly separated and never adjacent enough to mis-tap.
- All targets ≥ 48×48dp.

---

## PART 2 — COMPONENT ANATOMY

### 2.1 `AuraVoiceButton` (persistent)

- Present on every entry screen (top-trailing or pinned). Large (≥ 56dp), `primary` fill.
- `Semantics(label: "Aura voice assistant", hint: "Double tap and speak a command", button: true)`.
- On activate: `selectionClick` haptic + announce "Aura listening"; opens STT and maps the spoken intent to a route.

### 2.2 `ReplayAudioButton`

- Single tap on any screen replays that screen's spoken summary. Mirrors the global "single tap = replay" gesture.
- `Semantics(label: "Replay audio", button: true)`; `selectionClick` haptic.

### 2.3 `A11yButton` (primary / secondary)

- ≥ 48dp; label + hint; `lightImpact` success haptic on press; visible focus ring; never color-only state (also changes label/icon).
- Disabled state announces _why_ ("Continue — complete the previous step first"), never a silent grey-out.

### 2.4 `A11yField` (OTP / phone)

- Label above the field (not placeholder-only). `Semantics` exposes label, value, and live error.
- Errors announced via `SemanticsService.announce` (live region) + 2× medium error haptic; error text is also visible with an icon (not color alone).

### 2.5 `ChoiceTile` (theme / text-size / haptic options)

- Large selectable rows in a `RadioGroup` semantics container; each tile states its current selection in `value` ("Selected, High contrast").
- Selecting a tile applies the change **live** and announces the result ("Text size two hundred percent applied").

---

## PART 3 — SCREEN ANATOMY (Step by Step)

### 3.1 Splash / First Contact

- On launch, Aura speaks a one-line welcome and immediately offers: "Set up Opto for you, or sign in." `selectionClick` haptic when ready.
- Detects OS accessibility settings (`MediaQueryData.accessibleNavigation`, `textScaleFactor`, `boldText`, `highContrast`) and proposes auto-apply.
- Focus order: Title → "Auto-apply my phone's accessibility settings?" (Yes/No) → Continue.

### 3.2 Accessibility Setup — Theme

- **Goal:** choose Theme (High-Contrast default / Dark / Light).
- `ChoiceTile` group; selection applies live and announces. "Replay audio" and "Skip" available.
- Haptic: `selectionClick` on focus move; `lightImpact` on selection.

### 3.3 Accessibility Setup — Text Size

- Slider **and** stepper (slider alone is hard for screen readers): `Semantics(value: "200 percent")`, increment/decrement actions exposed.
- Live preview reflows on screen; never clips. Range 100–300%.

### 3.4 Accessibility Setup — Voice & Haptic

- Toggles: Aura Voice (on by default), Hotword (off by default — explain battery/privacy in `hint`), Haptic intensity (`off`/`light`/`full`).
- Each toggle change announces its new state and fires the matching sample haptic so the user feels what they selected.

### 3.5 Authentication

- **Phone/email OTP** or **biometric** (if a prior session exists). **No visual CAPTCHA anywhere.**
- OTP entry: `A11yField` with per-digit semantics or a single labeled field; resend is a clearly labeled `A11yButton` with a spoken countdown ("Resend available in thirty seconds").
- Errors: live-region announcement + error haptic; success: `lightImpact` + "Signed in".

### 3.6 Caregiver Link (optional, skippable)

- Offer to link a caregiver now or later. Explains consent and revocability aloud.
- If skipped, clearly state it can be added in Profile.

### 3.7 Handoff to Home

- On completion, announce "Setup complete. Opening Home." and route to the Home hub (see `dashboard_design_breakdown.md`).

---

## PART 4 — MICRO-INTERACTIONS & HAPTICS

| Moment          | Visual                     | Audio                     | Haptic           |
| :-------------- | :------------------------- | :------------------------ | :--------------- |
| Screen enters   | Title auto-focused         | Spoken summary            | —                |
| Option focused  | Focus ring                 | Element label (by reader) | `selectionClick` |
| Option selected | State + icon change        | "X applied" announcement  | `lightImpact`    |
| Field error     | Error text + icon          | Live-region error message | 2× medium        |
| Step advance    | Progress indicator updates | "Step 3 of 5"             | `selectionClick` |
| Setup complete  | —                          | "Setup complete"          | `lightImpact`    |

- Progress is announced as "Step N of M" (text + audio), never a bare visual bar.

---

## PART 5 — COMPONENT STATES MATRIX

| Component         | Default                | Focused                       | Selected/Active                   | Error                          | Disabled         |
| :---------------- | :--------------------- | :---------------------------- | :-------------------------------- | :----------------------------- | :--------------- |
| `A11yButton`      | label                  | focus ring + `selectionClick` | label/icon change + `lightImpact` | —                              | announces reason |
| `ChoiceTile`      | unselected             | focus ring                    | "Selected, X" + live apply        | —                              | —                |
| `A11yField`       | label + hint           | focus ring                    | value spoken                      | live error + 2× medium haptic  | announces reason |
| `AuraVoiceButton` | "Aura voice assistant" | focus ring                    | "Aura listening"                  | "Didn't catch that, try again" | —                |

---

## PART 6 — IMPLEMENTATION NOTES (Flutter, Feature-First)

### 6.1 Folder Mapping

```
features/onboarding/
├── presentation/
│   ├── pages/            # splash, theme_step, text_step, voice_haptic_step, auth_page, caregiver_step
│   ├── widgets/          # ChoiceTile, ReplayAudioButton, StepProgress
│   └── providers/        # onboarding_controller (Riverpod)
├── domain/               # SetupPreferences entity, use cases (ApplyPreferences, CompleteOnboarding)
└── data/                 # AccessibilitySettingsRepository (supabase_flutter)
```

### 6.2 Data Contract (Supabase)

- Reads/writes `accessibility_settings` (owner-only RLS). Auth via Supabase Auth (phone/email OTP). Optional `caregiver_links` insert with `status='pending'`.
- The local session is the source of truth for theme/text scale during onboarding; persist to Supabase on each step so settings survive reinstall.

### 6.3 Accessibility (mandatory checklist)

- Entire flow completable via TalkBack/VoiceOver with no sighted assistance.
- Every step exposes "Replay audio" (single tap) and "Skip".
- OS accessibility settings detected and offered for auto-apply.
- High-Contrast theme is the default option.
- No visual CAPTCHA; errors announced via live region + haptic.
- Text scales to 300% on every screen without clipping.

### 6.4 Voice Intents

- "Set up my app" → start setup; "Sign in" → auth; "Use dark mode" → apply theme live; "Skip" / "Continue" / "Repeat" navigation. Ambiguous input → Aura confirms by audio before acting.

### 6.5 Performance

- Defer heavy initialization until after the welcome is spoken; never block first audio on network. Cache chosen preferences locally for instant subsequent launches.

---

## IMPLEMENTATION CHECKLIST (Frontend Team)

- [ ] First audio plays before any network call completes.
- [ ] OS a11y settings detected + auto-apply offered.
- [ ] Theme/Text/Voice/Haptic steps apply live and announce results.
- [ ] OTP/biometric only — no CAPTCHA.
- [ ] Every screen: title auto-focus, logical focus order, "Replay audio", "Skip".
- [ ] All targets ≥ 48dp, contrast ≥ 4.5:1, text scale to 300% verified.
- [ ] `meetsGuideline(...)` passes for contrast, tap target, and labeled-tap-target.
