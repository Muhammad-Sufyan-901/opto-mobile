# Design System — Opto

**Target Audience:** UI/UX Accessibility Specialist, Flutter Engineer
**Design Theme:** "Invisible & Inclusive" — function before aesthetics, perfect when unseen, pleasant when seen.
**Brand:** **Opto — "Your world, made clear."** Designed for blind, low-vision & ocular-prosthesis users.
**Implementation:** Flutter `ThemeData` / `ColorScheme`, `Semantics`, `HapticFeedback`, `MediaQuery.textScaler`.

> This is the single canonical design document. It covers the foundation (tokens, type, components, haptics, voice, gestures, screen-reader rules) **and** the detailed screen-by-screen breakdown for both the onboarding/entry flow and the in-app experience. Data shapes/RLS live in `database_schema.md`; module/persona detail in `product_requirements.md`; architecture in `system_architecture.md`.

---

## TABLE OF CONTENTS

1. Overview & Principles
2. Color & Contrast
3. Typography
4. Spacing, Layout & Touch Targets
5. Core Components
6. Haptic Pattern Catalog
7. Voice Command Catalog (Aura Voice)
8. Gestures
9. Screen Reader Rules
10. Navigation Shell
11. Onboarding & Entry Flow (screens 1–14)
12. In-App Screen Anatomy (Home + modules)
13. Micro-Interactions & Haptics
14. Component States Matrix
15. Flutter Implementation Notes
16. Testing Hooks & Checklists

---

## 1. Overview & Principles

The interface must be **completable without looking at the screen** (totally blind users) while remaining **bright, clean, and legible** (low-vision and monocular ocular-prosthesis users). Opto's visual language is a calm **blue-on-white light theme** with large type, generous white space, soft rounded cards, and a single, predictable blue accent. Every important status is conveyed through **three redundant senses: visual + audio + haptic**.

- **Function before aesthetics:** every element is meaningful when read aloud by TalkBack/VoiceOver. Decorative elements use `ExcludeSemantics`.
- **Three senses, one piece of information:** confirmations, warnings, and danger are signaled visually, audibly, and haptically at once.
- **Voice-first, vision-optional:** every core task has an Aura Voice path and a touch path.
- **Clean & minimalist:** generous white space so screen readers cleanly separate content from chrome; shallow navigation (no deep sub-menus).
- **Simple over complete:** a small, predictable surface beats a dense one.

---

## 2. Color & Contrast

**Opto ships a Light (blue + white) theme as the default**, with **Dark** and **High-Contrast** themes offered as options in onboarding and Settings (stored in `accessibility_settings.theme`, default `light`). Text contrast ratio **≥ 4.5:1** (WCAG AA); large text, icons, and component boundaries **≥ 3:1**. Colors are authored in **OKLCH** for perceptual consistency; resolved hex values are listed for reference.

### 2.1 Light theme tokens (default — canonical palette)

| Token | OKLCH | Hex | Usage |
| :-- | :-- | :-- | :-- |
| `--blue` | `oklch(0.53 0.16 256)` | `#1E6AC5` | Primary actions, focus accent, active icons (5.35:1 on white) |
| `--blue-strong` | `oklch(0.46 0.15 256)` | `#0B56A9` | Pressed / hover variant |
| `--blue-tint` | `oklch(0.962 0.028 256)` | `#EBF3FF` | Selected card / icon chip background |
| `--bg` | — | `#FFFFFF` | App background, surfaces |
| `--ink` | `oklch(0.28 0.03 262)` | `#212938` | Titles & body text (14.6:1) |
| `--ink-2` | `oklch(0.47 0.022 262)` | `#545B68` | Sub-text, captions (6.8:1) |
| `--ink-3` | `oklch(0.565 0.016 262)` | `#717680` | Hint / placeholder text (4.56:1 — AA-corrected) |
| `--line` | `oklch(0.665 0.02 262)` | `#8D94A0` | Interactive component borders — inputs, option rows, toggles (3.05:1 — AA-corrected) |
| `--divider` | `oklch(0.90 0.013 262)` | `#D9DEE7` | Decorative hairlines / list separators only (non-functional) |
| `--green` | `oklch(0.60 0.13 152)` | `#1F8A5B` | Healthy / success status |
| `--green-tint` | `oklch(0.95 0.04 152)` | `#E6F6EE` | Success chip background |
| `--danger` | `oklch(0.55 0.17 27)` | `#C13C36` | SOS, destructive, errors (5.28:1 both ways — AA-corrected) |
| `--danger-tint` | — | `#FDECEC` | SOS card / error surface background |
| `--focus-ring` | = `--blue` | `#1E6AC5` | Visible focus outline (≥ 3px) + `0 0 0 4px` blue@16% halo |

> **AA corrections (per accessibility mandate):** three tokens were darkened from the original mockup so the documented palette passes WCAG AA without changing the look — hint text `#818690 → #717680`, functional border `#D9DEE7 → #8D94A0` (the original light value is retained as `--divider` for decorative lines only), and `--danger #E23B3B → #C13C36`. White text on the corrected danger and danger-text on white both reach 5.28:1.

### 2.2 Dark & High-Contrast themes (options)

Opto provides Dark and High-Contrast as user-selectable themes for low-vision and light-sensitive users. They reuse the same token names with darker surfaces (`--bg` near-black, `--ink` near-white, `--blue` raised in lightness for ≥ 4.5:1 on dark). High-Contrast pushes every pair to ≥ 7:1 and thickens focus rings. These palettes are derived from the Light tokens and finalized during theming implementation; the Light palette above is the canonical source of truth.

### 2.3 Rules

- **Never encode meaning by color alone** — pair with text + icon + audio + haptic.
- Status (healthy / warning / danger) always carries a text label and an audio announcement, not just a hue.
- Use `--line` (not `--divider`) for any border a user must perceive to operate a control.

---

## 3. Typography

- **Default font:** **Atkinson Hyperlegible** (designed for low vision), weights 400 & 700 plus italic; fallback `system-ui, sans-serif`.
- **Scalable to 300%:** honor `MediaQuery.textScaler` (1.0–3.0). Layouts must **reflow** — no clipping, no overflow, no fixed-height text containers.
- **Minimum body size:** 16sp at scale 1.0; line height ≥ 1.5; ample letter spacing. Avoid all-caps for long text and italics for critical info; short uppercase eyebrows (letter-spaced) are acceptable as labels.

| Role | Size @1.0 | Weight | Notes |
| :-- | :-- | :-- | :-- |
| Splash wordmark | 48px | 700 | brand entry only |
| Done / Welcome / celebration title | 30px | 700 | `text-wrap: balance` |
| Auth title | 28px | 700 | |
| Form title (email/phone/OTP) | 27px | 700 | |
| Onboarding step title `H1` | 26px | 700 | |
| Screen / section title `H2` | 20–24px | 600–700 | |
| Card / option title | 18px | 700 | |
| Body | 16–18px | 400 | 18 in first-run for clarity |
| Label / sub-text | 14.5–15px | 400–700 | also exposed as `Semantics.hint` |
| Eyebrow (uppercase) | 14px | 700 | letter-spacing ~1.6px, `--blue` |

---

## 4. Spacing, Layout & Touch Targets

- **8dp base unit.** Screen padding 24dp (16–24dp in-app); section gaps 24–32dp; card padding 16–20dp.
- **Radius:** buttons 16dp, inputs 14dp, option/setting rows 18dp, cards 18–20dp, icon chips 14dp, phone shell 42–44dp.
- **Elevation:** soft, cool-tinted shadows (`rgba(20,40,80,.20)` range); avoid harsh drop shadows.
- **Touch target minimum: 48×48 dp.** Primary buttons 60dp tall; text inputs 58dp; back button 48dp; toggles 56×32dp (knob 26dp). Space adjacent targets to prevent mis-tap; one primary action per screen where possible; keep the bottom navigation to **5 destinations**.

---

## 5. Core Components

Opto has two component families sharing the same tokens: onboarding/auth primitives (`opt-*`) and the in-app dashboard set (`dash-*`). In Flutter both map to the shared `core/widgets` library.

- **`OptoButton`** — three kinds: `primary` (blue fill, white label, trailing arrow icon, ≥ 60dp), `onblue` (white fill, blue label — on blue surfaces), `outline` (white fill, ink label, 2px `--line` border, leading icon — auth method choices). Success haptic on press; visible focus ring; never color-only state. Disabled announces *why*, never a silent grey-out.
- **`OptionRow`** — large selectable row (icon chip + title + description + control). Control is a `radio` (single choice) or `check` (multi). Selected = `--blue` border + `--blue-tint` fill + filled control; `MergeSemantics` so it reads as one unit with its `value` ("Selected, Low vision").
- **`Toggle`** — 56×32 pill; off = `--line` track, on = `--blue` track; announces new state + fires the matching sample haptic.
- **`OptoField`** — label above the input (never placeholder-only), 58dp input, focus = `--blue` border + 4px halo + caret; error announced via live region + 2× medium haptic, with visible error text + icon (not color alone).
- **`Slider`** — track + fill + knob for text-size / speaking-speed; paired with a stepper for screen-reader operability; exposes `Semantics(value: "200 percent")`; live preview reflows, never clips.
- **`ProgressBar` / `Dots`** — `ProgressBar` for stepped setup ("Step N of M" announced), `Dots` for the welcome carousel.
- **`BottomNav`** — 5 tabs: **Home · Vision AI · Community · Consult · Profile**. Active = `--blue` with a small top **dot indicator**; icons always paired with visible text labels.
- **Cards** — `AuraVoiceCard` (blue-tint, mic chip, waveform), `SosCard` (danger-tint, oversized danger icon), reminder / nearby / quick-action tiles, community `Post`, `DocRow`, hub status card. All cards merge into a single semantic unit.
- **`Avatar`, `ScreenHeader`, `SectionLabel`, `Chip`, `Placeholder`** — supporting primitives. `Chip` (relationship / topic filters) is selectable, labeled, ≥ 44dp.
- **Icons** — geometric line icons, `stroke = currentColor`, stroke width ~2–2.4, inheriting context color (in Flutter: `flutter_svg` or `CustomPaint`, tinted from `ColorScheme`).

---

## 6. Haptic Pattern Catalog (consistent app-wide)

| Event | Pattern | Flutter |
| :-- | :-- | :-- |
| Confirmation / success | 1× short | `HapticFeedback.lightImpact()` |
| Warning / error | 2× medium | two `mediumImpact()` spaced ~120ms |
| Danger / SOS active | Long, pulsing (distinctive; **never reused**) | custom vibration pattern via platform channel |
| Camera ready to scan (Vision AI) | 1× soft | `HapticFeedback.selectionClick()` |
| Nearby obstacle (navigation, P2) | Intensity increases with proximity | escalating pattern |
| Tab navigation / focus move | Light tick | `HapticFeedback.selectionClick()` |

Haptic intensity respects `accessibility_settings.haptic_intensity` (`off`/`light`/`full`). The danger/SOS pattern is reserved and never reused for any other event.

---

## 7. Voice Command Catalog (Aura Voice)

Activation: an **Aura Voice** shortcut on every screen + optional **"Hey Opto"** hotword (off by default for battery/privacy). Natural-language → intent → `go_router` route. If ambiguous, Aura confirms by audio before acting.

| Command (ID / EN) | Route / Action |
| :-- | :-- |
| "Apa ini" / "What's in front of me?" / "Describe this" | Vision AI — describe scene |
| "Baca teks" / "Read text" / "Read my messages" | Vision AI — OCR / read |
| "Pesan prostetik" / "Order prosthetic" | Prosthetic Hub → order / care flow |
| "Cari dokter" / "Find a doctor" / "Call Dr. ___" | Consult → search / call |
| "Jadwal saya" / "My schedule" | Consultation bookings |
| "Buka komunitas" / "Open community" | Community |
| "Navigasi ke ___" / "Navigate to the pharmacy" | Accessibility Map → guided walking |
| "Panggil darurat" / "Call emergency" | Emergency SOS trigger |
| "Perbesar teks" / "Dark mode" | Accessibility settings |

---

## 8. Gestures

- **Single tap** = replay audio for the focused element. **Double-tap** = activate/select. **Swipe** = move between content/menus.
- Never make a complex multi-finger gesture the **only** way to do something; always provide a button and a voice alternative.
- **Global SOS gesture:** hold anywhere for 3 seconds triggers Emergency SOS (in addition to the Home `SosCard` and the "Call emergency" voice command).

---

## 9. Screen Reader Rules (TalkBack & VoiceOver)

- Every interactive element exposes `label`, `hint`, `role`, and `value` via `Semantics`/`MergeSemantics`.
- **Focus order:** logical top→bottom, left→right, following information hierarchy.
- **Live regions:** dynamic status (Vision AI result, form error, "SOS sent") announced via `SemanticsService.announce` / `liveRegion: true`.
- **No focus traps:** modals/bottom sheets are dismissible and never trap focus.
- Decorative art (illustration placeholders, the striped art blocks, status-bar chrome, camera preview) is excluded with `ExcludeSemantics`.

---

## 10. Navigation Shell

- **Bottom Navigation (5, shallow):** Home · Vision AI · Community · Consult · Profile. Prosthetic Hub, SOS, and Map are reached from Home, voice, and the SOS global gesture. On switch → `selectionClick` haptic + announce "Home tab, screen 1 of 5".
- **Persistent Aura Voice:** an `AuraVoiceCard`/shortcut on Home and a persistent voice entry; activating announces "Aura listening" and routes the spoken intent via `go_router`.
- **Global SOS gesture:** hold-3-seconds anywhere → Emergency SOS, confirmed by the danger haptic + "SOS sent".

---

## 11. Onboarding & Entry Flow (screens 1–14)

The first screens a user meets. The web landing page is **out of scope** for the mobile client (web = marketing/admin only). Everything must be completable **100% via TalkBack/VoiceOver**, voice-first, and haptic-redundant. Default theme is **Light**; if the OS reports an active screen reader or large font scale, Opto pre-selects the matching option and announces it.

**Entry primitives:** `AuraVoiceButton` (persistent, ≥ 56dp, "Aura listening"), `ReplayAudioButton` (single tap replays the screen summary), `OptoButton` (primary / onblue / outline), `OptoField` (label-above, caret, live error), `OptionRow`, `Toggle`, `Slider`, `Chip`. Focus ring ≥ 3px (`--focus-ring`) + 4px blue@16% halo, always visible.

1. **Splash / First Contact (blue):** white aperture mark + "Opto" wordmark + tagline "Your world, made clear."; loading dots + footnote "Designed for blind, low-vision & prosthetic users." Aura speaks a one-line welcome; `selectionClick` when ready; detects OS a11y settings and proposes auto-apply.
2–4. **Welcome carousel (3 slides):** "One app for your whole day", "Speaks your language, listens too" (TalkBack + voice), "Set up the way that fits you." Each = eyebrow + balanced title + body + striped illustration placeholder + `Dots` + primary button ("Next" → "Get started"); "Skip" top-trailing.
5. **Sign-in hub:** aperture mark + "Welcome to Opto" + sub; three `outline` methods — **Continue with Google / email / phone**; an "or" divider; a **caregiver / assisted-setup** card ("I'm helping someone set up"); Terms & Privacy line.
6. **Email / Password:** back-only `TopNav` + title + two `OptoField`s (email focused, password) + "Forgot password?" + primary "Continue"; mock QWERTY (decorative).
7. **Phone number:** country-code chip (🇮🇩 +62) + number field + "Standard message rates may apply." + "Send code"; mock numeric keypad.
8. **OTP:** six OTP boxes (active box shows caret) + "Resend in 0:24" + "Verify". **No visual CAPTCHA anywhere.**
9. **Caregiver / assisted setup (optional):** banner — the account stays the supported person's; "Who are you setting up for?" → name field + relationship chips (Family/Friend/Carer/Other); consent + revocability explained aloud.
10. **Setup — Vision profile (Step 1 of 4):** `ProgressBar` + "How do you experience your vision?" `OptionRow` radios: **Blind**, **Low vision**, **Ocular prosthetic**, **Prefer not to say**.
11. **Setup — Display (Step 2 of 4):** live `PREVIEW` card ("Bus 12 arrives in 4 minutes…") + **Text size** slider + **High contrast** toggle; applies live and announces; preview reflows to 300% without clipping.
12. **Setup — Voice & sound (Step 3 of 4):** toggles **Spoken guidance**, **Voice commands** ("Say 'Hey Opto'") + **Speaking speed** slider; works alongside TalkBack.
13. **Setup — Permissions (Step 4 of 4):** `PermRow`s — **Camera** (read text / identify), **Microphone** (voice & calling for help), **Location** (walking directions); shield note "You're always in control. Change these in Settings any time." + "Finish setup."
14. **All set (blue):** big check, "You're all set, {name}", summary rows (Vision / Text size / Voice), `onblue` "Enter Opto" → Home.

**Entry data contract:** reads/writes `accessibility_settings` (owner-only RLS; `theme` default `light`); auth via Supabase Auth (Google / phone / email OTP); optional `caregiver_links` insert with `status='pending'`. Local session is the source of truth during onboarding; persist to Supabase each step so settings survive reinstall.

---

## 12. In-App Screen Anatomy (Home + modules)

The authenticated, day-to-day experience. Every screen: title auto-focus + spoken one-line summary + "Replay audio"; honors the saved theme (Light default); status colors always paired with text + icon + audio.

### 12.1 Home Hub
Top→bottom focus order: (1) top bar — greeting "Good morning, Rian" + notifications bell + avatar; (2) **`AuraVoiceCard`** (blue-tint, mic chip, waveform) — "Tap and ask Opto anything", `aria-label: "Aura Voice. Tap to speak."`; (3) **Quick actions** grid — Vision AI, Prosthetic Hub, Consult Doctor, Community (merged tiles); (4) **`SosCard`** (danger-tint, oversized icon) — "Emergency SOS — Hold 3 seconds or say 'Call emergency'"; (5) contextual rows — care reminder ("Prosthetic cleaning — Tomorrow · 09:00"), "Navigate nearby", "Recent activity" list. States: loading / empty (reminders omitted) / error (cached + "Showing saved data, offline").

### 12.2 Vision AI ("Aura")
Mode chips: **Read text** (OCR, on-device), **Identify** (object, on-device), **Describe scene** (cloud), **Colors** (on-device); Navigation cues P2. Anatomy: full-bleed camera preview (decorative → `ExcludeSemantics`), framing **reticle**, **readout** region that is a **live region** ("Bank Mandiri — Jl. Sudirman No. 12. Open until 15:00."), large shutter, side controls (document, mic). Scene flow: stable focus → "ready to scan" soft haptic → capture → result spoken < 3 s; single tap replays, double-tap = extended detail. OCR: haptic/audio positioning, recognized text spoken + saveable, BI + EN, detects Rupiah. Offline: OCR/object on-device; scene announces "Scene description needs internet — OCR still works".

### 12.3 Prosthetic Hub (Ocular)
Status card: `--green` healthy chip, "Right eye prosthesis", "Next cleaning in 1 day", "Log care". Care & support links: Fitting appointments, Care guides, Order supplies, Message my specialist. **Custom order (guided, medical-sensitive 🔒):** iris/sclera match (on-device color CV; photo + `matched_iris_hex` owner-only) → anthropometric fields (manual or ocularist record) → confirmation reads full summary aloud + requires **explicit consent** (`consent_given`) before submit. Tutorials: audio narration + text transcript + video with audio description (insert/remove/clean/lubricate/case use). Reminders (P1): scheduled notifications + haptic; optional caregiver link.

### 12.4 Consult (Health & Consultation)
Next-appointment card: doctor avatar, "Ophthalmologist · Video visit", **Join call** / **Message**. Available now: searchable doctor/ocularist list with status (Online / In 30 min); fully voice-completable ("Find the nearest eye doctor for tomorrow"); "Book a new appointment". Consultation (video / **non-verbal mode**): WebRTC; patient aims camera at their eye while doctor instructions are read aloud / shown as text; haptic/audio guides positioning; recording opt-in with explicit, read-aloud consent. History & prescriptions (P1, owner+doctor RLS, replayable); eye-care exercises (P1, audio-guided + haptic timer + medical disclaimer).

### 12.5 Community (Connect)
Feed: topic chips (For you / Low vision / Prosthetics / Tech tips) + short text threads. Each `Post` is a merged semantic unit (author, body, time) with actions like / reply / **Listen** (read aloud); compose FAB. Composer supports **voice dictation**; on image attach, prompts for `alt_text` and blocks posting without it. Moderation/report fully screen-reader accessible; report reasons are labeled choices.

### 12.6 Emergency SOS (active state)
Full **danger** screen: "Emergency active", pulsing rings around the SOS core, "Calling emergency services…", live location ("Jl. Merdeka No. 24, Bandung — accuracy 5 m"), contacts being notified ("Siti (Sister) — Notified · 3s ago"). On trigger: distinctive long pulsing **danger haptic** + audio "SOS sent"; location streamed to active caregivers + emergency contacts (Realtime + `sos-dispatch` Edge Function). Cancel: "Hold to cancel" with a short cooldown; cancellation announced.

### 12.7 Aura Voice (listening overlay)
Blue full-screen overlay: close button, "Aura Voice", "Listening…" + animated **waveform**, recognized phrase ("Read my messages"), "TRY SAYING" suggestion list ("What's in front of me?", "Navigate to the pharmacy", "Call Dr. Anwar"), large mic control. Result routes via `go_router` deep-link; ambiguous → Aura confirms by audio first.

### 12.8 Profile & Accessibility Settings
Profile card: avatar, name, "Low vision · Member since 2025", Edit. Accessibility group: Text size, High contrast, Voice & speech, Vision profile (each a `SetRow` with current value + chevron). Account group: Privacy & safety, Help & support. Changes apply **live without restart** and are announced. Medical data export/delete (UU PDP-aligned) behind explicit double-confirmation; caregiver link/approve/revoke (revocation cuts RLS access immediately).

### 12.9 Accessibility Map
Find facilities: nearby POIs with read-aloud accessibility attributes (ramp, elevator, tactile path, wheelchair); navigation integrated with audio guidance ("Navigate nearby" from Home / "Navigate to ___" voice). Contribute/verify (P2): add or confirm attributes; queued for verification.

---

## 13. Micro-Interactions & Haptics

| Moment | Visual | Audio | Haptic |
| :-- | :-- | :-- | :-- |
| Screen enter | title auto-focus | spoken summary | — |
| Option focus / card focus | focus ring | element/merged label | `selectionClick` |
| Option selected | `--blue` border + tint + icon | "X applied" | `lightImpact` |
| Tab switch | `--blue` + dot indicator | "Home tab 1 of 5" | `selectionClick` |
| Step advance | `ProgressBar` updates | "Step 3 of 4" | `selectionClick` |
| Action success | state/icon change | confirmation phrase | `lightImpact` |
| Validation error | error text + icon | live-region error | 2× medium |
| Vision AI ready | reticle steady cue | — | soft (`selectionClick`) |
| Vision AI result | readout text | auto-spoken result | — |
| SOS active | danger screen + rings | "SOS sent" | **long pulsing danger** |
| Setup complete | check | "Setup complete" | `lightImpact` |
| Obstacle near (P2) | — | optional cue | escalating intensity |

Progress is announced as "Step N of M" (text + audio), never a bare visual bar.

---

## 14. Component States Matrix

| Component | Default | Focused | Active/Selected | Loading | Empty | Error/Offline | Disabled |
| :-- | :-- | :-- | :-- | :-- | :-- | :-- | :-- |
| `OptoButton` | label | focus ring + `selectionClick` | label/icon change + `lightImpact` | — | — | dispatch retry announced | announces reason |
| `OptionRow` | `--line` border | focus ring | "Selected, X" + `--blue`/tint | — | — | — | — |
| `OptoField` / `SetRow` | label + value/hint | focus ring + caret | value spoken | — | — | live error + 2× medium haptic | announces reason |
| `Toggle` | off (`--line` track) | focus ring | on (`--blue`) + sample haptic | — | — | — | — |
| Quick-action tile / `Post` | merged label | focus ring + `selectionClick` | `lightImpact` on open | skeleton + "Loading" | omitted or "Nothing here yet" | cached + "Offline" announce | — |
| Bottom nav item | label | focus ring | `--blue` + dot, selected announced | — | — | — | — |
| Vision AI shutter | label | focus ring | scanning announced | spinner + announce | — | "Needs internet / try again" | — |
| `SosCard` | "Emergency SOS" | focus ring | danger haptic + "SOS sent" | — | "Add a contact first" | dispatch retry announced | — |
| `AuraVoiceButton` | "Aura voice assistant" | focus ring | "Aura listening" | — | — | "Didn't catch that, try again" | — |

---

## 15. Flutter Implementation Notes (Feature-First)

### 15.1 Folder Mapping

```
features/
├── onboarding/   splash · welcome(carousel) · signin_hub · email · phone · otp ·
│                 caregiver · vision_profile · display · voice · permissions · done
├── home/         presentation(pages: home) · domain · data(HomeSummaryRepository)
├── vision_ai/    scene · ocr · identify · colors   (MlKit + scene-describe Edge Fn)
├── prosthetic_hub/ status · care_links · custom_order · tutorials · reminders
├── consultation/ search · booking · call(WebRTC) · history · exercises
├── connect/      feed(community) · composer · report
├── sos/          sos_trigger · sos_active   (also bound to global gesture + voice)
├── map/          map · poi_detail · contribute
└── profile/      settings · caregiver · medical_data
core/
├── accessibility/ (Semantics helpers, announce(), haptic catalog)
├── theme/  router/  supabase/  voice/  widgets/  utils/
```

### 15.2 Data Contracts (Supabase)

- **Onboarding/Profile:** `accessibility_settings` (`theme` default `light`, owner-only), `caregiver_links`; export/delete via an audited Edge Function.
- **Home:** aggregates upcoming `consultation_bookings`, due `care_reminders` (owner-only RLS).
- **Vision AI:** OCR/object on-device (no DB); scene description via `scene-describe` Edge Function; saved OCR text local + optional sync.
- **Prosthetic Hub:** `prosthetic_products` (public read), `prosthetic_orders` + `anthropometric_data` + `eye_photos` (owner-only 🔒), `care_tutorials` (public read).
- **Consultation:** `doctors`/`doctor_availability` (public read), `consultation_bookings` (patient+doctor), `consultations` 🔒; WebRTC signaling over Realtime.
- **Community:** `posts`/`post_replies` (public read, author write), `post_media.alt_text` NOT NULL, `content_reports`.
- **SOS:** `sos_events` 🔒 + `emergency_contacts`; dispatch via `sos-dispatch` Edge Function; location via Realtime channel.
- **Map:** `accessibility_pois` (public read), `poi_contributions` (P2).

### 15.3 Performance

- Lazy-load module features via `go_router`; keep the Home hub instant. Camera/WebRTC initialized only on entering Vision AI / Consultation. Cache tutorials and settings for offline. Defer heavy init until after the welcome is spoken; never block first audio on network.

### 15.4 Accessibility (mandatory per screen)

- Title auto-focus + spoken summary + "Replay audio"; every interactive element labeled; cards merged; decorative excluded.
- Dynamic results/errors/SOS via live-region announcements; haptic per catalog.
- Contrast ≥ 4.5:1 (≥ 3:1 large/borders); targets ≥ 48dp; text scale to 300% with reflow.
- A working Aura Voice path for the screen's core task; no visual CAPTCHA.
- Medical-sensitive screens never display or cache data outside owner scope.

---

## 16. Testing Hooks & Checklists

**Automated:** `flutter_test` + Accessibility Guidelines API (`meetsGuideline(textContrastGuideline, androidTapTargetGuideline, iOSTapTargetGuideline, labeledTapTargetGuideline)`).
**Manual matrix:** TalkBack (Android), VoiceOver (iOS), text scale 200–300%, Light / Dark / High-Contrast, external keyboard. Accessibility KPIs validated with **real blind/low-vision users**.

**Frontend checklist:**
- [ ] First audio plays before any network call completes; OS a11y settings detected + auto-apply offered.
- [ ] Light theme default; Dark & High-Contrast selectable in Display step and Settings.
- [ ] Onboarding completable via TalkBack/VoiceOver with no sighted help; every step has "Replay audio" + "Skip".
- [ ] Google / email / phone OTP only — no CAPTCHA; errors via live region + haptic.
- [ ] Bottom nav = 5 destinations (Home, Vision AI, Community, Consult, Profile); shallow hierarchy.
- [ ] Aura Voice entry + global SOS gesture present app-wide; each module titled, summarized, replayable, voice-reachable.
- [ ] Vision AI: < 3 s scene description, on-device OCR < 1 s, offline fallback announced.
- [ ] Prosthetic custom order: explicit read-aloud consent before submit; iris photo owner-only.
- [ ] Community: alt-text enforced on image upload.
- [ ] SOS: three redundant triggers, danger haptic, cancel cooldown.
- [ ] Settings apply live and are announced; medical export/delete double-confirmed.
- [ ] `meetsGuideline(...)` passes for contrast, tap target, labeled-tap-target on every screen; manual TalkBack/VoiceOver + 300% text pass.
