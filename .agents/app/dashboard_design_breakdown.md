# DESIGN BREAKDOWN: Opto — In-App Experience (Flutter)

### _Home hub + the eight module screens, accessibility-first_

> This is the authenticated, day-to-day experience after onboarding. Every screen must be completable **without sight** (TalkBack/VoiceOver), be **voice-first** (an Aura Voice path for each core task), and signal status through **visual + audio + haptic** redundantly. All colors come from `ColorScheme` tokens — never hardcode hex. Canonical tokens, haptic catalog, and voice catalog live in `design_system.md`; data shapes/RLS in `database_schema.md`.

---

## PART 1 — DESIGN TOKENS (In-App Context)

### 1.1 Theme

- Honors the user's saved theme (High-Contrast default / Dark / Light) from `accessibility_settings`. Changes made in Settings apply **live** and are announced.
- Status colors (`success`, `warning`, `danger`) are **always** paired with text + icon + audio; never color-only.

### 1.2 Typography Scale (App Context)

| Role              | Size @1.0 | Weight |
| :---------------- | :-------- | :----- |
| Screen title `H1` | 24sp      | 700    |
| Section `H2`      | 20sp      | 600    |
| Card title        | 18sp      | 600    |
| Body              | 16sp      | 400    |
| Caption / hint    | 14sp      | 400    |

Atkinson Hyperlegible; all text scales to 300% with reflow; line height ≥ 1.5.

### 1.3 Spacing & Targets

- 8dp base unit; screen padding 16–24dp; section gaps 24–32dp.
- Touch targets ≥ 48dp; adjacent targets spaced to prevent mis-tap; one primary action per screen where possible.

---

## PART 2 — NAVIGATION SHELL

### 2.1 Bottom Navigation (4–5 destinations, shallow)

- **Home** · **Vision AI** · **Connect** · **Consult** · **Profile**. (Prosthetic Hub, SOS, and Map are reachable from Home, voice, and the SOS global gesture.)
- Each tab: `Semantics(label, selected: true/false)`; on switch → light `selectionClick` haptic + announce "Home tab, screen 1 of 5".
- Icons always paired with visible text labels.

### 2.2 Persistent Aura Voice Shortcut

- `AuraVoiceButton` available on every screen (e.g. pinned FAB-style, ≥ 56dp). Activating it announces "Aura listening" and routes the spoken intent via `go_router` deep-link.

### 2.3 Global SOS Gesture

- Hold-3-seconds anywhere triggers Emergency SOS (in addition to the Home SOS button and the "Call emergency" voice command). Confirmed by the distinctive danger haptic + "SOS sent".

---

## PART 3 — SCREEN ANATOMY (Per Module)

### 3.1 Home Hub

- **Purpose:** a calm, shallow launchpad. Auto-focuses the title, then a spoken one-line summary of what's available.
- **Layout (top→bottom focus order):**
  1. Greeting + `ReplayAudioButton`.
  2. **Large SOS button** (`SosButton`, `danger` color, oversized) — first actionable control so it's quick to reach.
  3. Primary module shortcuts as large `A11yCard`s: Vision AI, Prosthetic Hub, Consult, Connect, Map — each a single merged semantic unit ("Vision AI, describe your surroundings, double tap to open").
  4. Contextual row: upcoming consultation / due care reminder (if any), announced succinctly.
- **States:** loading (announced "Loading your home"), empty (no reminders → simply omitted, not an empty box), error (cached content + "Showing saved data, offline").
- **Voice:** any catalog command works from Home.

### 3.2 Vision AI ("Aura")

- **Modes:** Scene description (cloud), OCR (on-device), Object/Color (on-device, P1), Navigation cues (P2).
- **Anatomy:** full-bleed camera preview (decorative → `ExcludeSemantics`), a single large capture/scan control, and a results region that is a **live region**.
- **Scene flow:** stable focus → "ready to scan" soft haptic → capture → result spoken automatically in < 3 s (cloud); single tap replays, double-tap requests extended detail.
- **OCR flow:** haptic/audio positioning guidance ("move left", "full document visible"); recognized text spoken; "Save" stores it for replay. Supports BI + EN, detects Rupiah.
- **Offline:** OCR/object work on-device; scene description announces "Scene description needs internet — OCR still works".
- **States:** scanning (announced), success (result + replay), low-confidence ("I'm not sure — try again"), offline, permission-denied (read-aloud reason + path to settings).

### 3.3 Prosthetic Hub (Ocular)

- **Catalog screen:** list of `A11yCard`s; each card's `audio_description` is the primary content (material, size, care, price), not the image. Filters (iris color, size, custom/ready-stock) are labeled controls in an accessible sheet that never traps focus.
- **Product detail:** full spoken description; "Order" primary action; care info link.
- **Custom order flow (guided, medical-sensitive 🔒):**
  1. Iris/sclera match: camera photographs the healthy eye (on-device color CV); the captured photo and `matched_iris_hex` are owner-only.
  2. Anthropometric fields (socket size, curvature) entered manually or pulled from ocularist records.
  3. Confirmation reads a full summary aloud and requires **explicit consent** (`consent_given`) before submit.
- **Tutorials:** each step has audio narration + text transcript + video with audio description; covers insert/remove/clean/lubricate/case use.
- **Reminders (P1):** scheduled notifications + haptic; optional caregiver link.
- **States:** empty catalog, filtered-empty ("No prosthetics match — adjust filters"), order draft saved, submitting, consent-required (blocks submit + announces).

### 3.4 Health & Consultation

- **Find/Book:** searchable list of doctors/ocularists with **available slots** + clinic-manufacturer location; entire flow voice-completable ("Find the nearest eye doctor for tomorrow").
- **Booking detail:** slot, mode (video / non-verbal / in-person), confirmation announced; `booked_via_voice` recorded.
- **Consultation (video / non-verbal):** WebRTC video; **non-verbal mode** lets the patient aim the camera at their eye while the doctor's instructions are read aloud / shown as text; haptic/audio guides camera positioning. Recording is opt-in with explicit, read-aloud consent.
- **History & prescriptions (P1):** stored under strict owner+doctor RLS; replayable.
- **Eye-care exercises (P1):** audio-guided with a haptic timer; medical disclaimer displayed + read aloud.
- **States:** searching, no-slots, in-call (connection quality announced), reconnecting, ended (summary).

### 3.5 Connect (Community)

- **Feed:** short text threads; each post is a merged semantic unit (author, body, time). Images **must** carry `alt_text` (enforced at upload).
- **Composer:** supports **voice dictation**; on image attach, prompts for alt-text and blocks posting without it.
- **Moderation/report:** fully screen-reader accessible; report reasons are labeled choices.
- **States:** loading, empty ("No posts yet — be the first"), posting, post-success (`lightImpact` + "Posted").

### 3.6 Emergency SOS

- **Triggers (redundant):** oversized Home `SosButton` **+** global hold-3-seconds gesture **+** voice "Call emergency".
- **On trigger:** distinctive long pulsing **danger haptic** + audio "SOS sent"; real-time location streamed to active caregivers + emergency contacts (via Realtime + `sos-dispatch` Edge Function); option to call emergency services.
- **Cancel:** clearly labeled cancel with a short cooldown to prevent false alarms; cancellation announced.
- **States:** active (location streaming announced), cancelled, resolved, no-contacts (warns + routes to add contacts).

### 3.7 Accessibility Map

- **Find facilities:** nearby POIs with read-aloud accessibility attributes (ramp, elevator, tactile path, wheelchair); navigation integrated with audio guidance.
- **Contribute/verify (P2):** add or confirm attributes; contributions queued for verification.
- **States:** locating, no-results-nearby, offline (cached POIs), permission-denied (read-aloud reason).

### 3.8 Profile & Accessibility Settings

- **Controls:** theme, typography (to 300%), haptic intensity, voice/hotword, caregiver linking. Changes apply **live without restart** and are announced.
- **Medical data:** export and delete (UU PDP-aligned), each behind explicit confirmation.
- **Caregiver:** link/approve/revoke; revocation cuts access at the RLS layer immediately.
- **States:** saving (live announce), export-ready, delete-confirm (double confirmation, read aloud).

---

## PART 4 — MICRO-INTERACTIONS & HAPTICS

| Moment             | Visual             | Audio               | Haptic                  |
| :----------------- | :----------------- | :------------------ | :---------------------- |
| Screen enter       | title auto-focus   | spoken summary      | —                       |
| Tab switch         | active indicator   | "Home tab 1 of 5"   | `selectionClick`        |
| Card focus         | focus ring         | merged label spoken | `selectionClick`        |
| Action success     | state/icon change  | confirmation phrase | `lightImpact`           |
| Validation error   | error text + icon  | live-region error   | 2× medium               |
| Vision AI ready    | preview steady cue | —                   | soft (`selectionClick`) |
| Vision AI result   | result text        | auto-spoken result  | —                       |
| SOS active         | danger banner      | "SOS sent"          | **long pulsing danger** |
| Obstacle near (P2) | —                  | optional cue        | escalating intensity    |

The danger/SOS haptic pattern is reserved and never reused for any other event.

---

## PART 5 — COMPONENT STATES MATRIX

| Component                   | Default         | Focused                       | Active                     | Loading              | Empty                         | Error/Offline                |
| :-------------------------- | :-------------- | :---------------------------- | :------------------------- | :------------------- | :---------------------------- | :--------------------------- |
| `A11yCard` (module/product) | merged label    | focus ring + `selectionClick` | `lightImpact` on open      | skeleton + "Loading" | omitted or "Nothing here yet" | cached + "Offline" announce  |
| Bottom nav item             | label           | focus ring                    | selected announced         | —                    | —                             | —                            |
| Vision AI capture           | label           | focus ring                    | scanning announced         | spinner + announce   | —                             | "Needs internet / try again" |
| `SosButton`                 | "Emergency SOS" | focus ring                    | danger haptic + "SOS sent" | —                    | "Add a contact first"         | dispatch retry announced     |
| `A11yField`                 | label + hint    | focus ring                    | value spoken               | —                    | —                             | live error + haptic          |

---

## PART 6 — IMPLEMENTATION NOTES (Flutter, Feature-First)

### 6.1 Folder Mapping

```
features/
├── home/         presentation(pages: home) · domain · data(HomeSummaryRepository)
├── vision_ai/    presentation(scene, ocr, object) · domain(use cases) · data(MlKit + scene-describe Edge Fn)
├── prosthetic_hub/ catalog · product_detail · custom_order · tutorials · reminders
├── consultation/ search · booking · call(WebRTC) · history · exercises
├── connect/      feed · composer · report
├── sos/          sos_trigger · sos_active   (also bound to global gesture + voice)
├── map/          map · poi_detail · contribute
└── profile/      settings · caregiver · medical_data
core/
├── accessibility/ (Semantics helpers, announce(), haptic catalog)
├── theme/  router/  supabase/  voice/  widgets/  utils/
```

### 6.2 Data Contracts (Supabase)

- **Home:** aggregates upcoming `consultation_bookings`, due `care_reminders` (owner-only RLS).
- **Vision AI:** OCR/object on-device (no DB); scene description via `scene-describe` Edge Function; saved OCR text local + optional sync.
- **Prosthetic Hub:** `prosthetic_products` (public read), `prosthetic_orders` + `anthropometric_data` + `eye_photos` (owner-only 🔒), `care_tutorials` (public read).
- **Consultation:** `doctors`/`doctor_availability` (public read), `consultation_bookings` (patient+doctor), `consultations` 🔒; WebRTC signaling over Realtime.
- **Connect:** `posts`/`post_replies` (public read, author write), `post_media.alt_text` NOT NULL, `content_reports`.
- **SOS:** `sos_events` 🔒 + `emergency_contacts`; dispatch via `sos-dispatch` Edge Function; location via Realtime channel.
- **Map:** `accessibility_pois` (public read), `poi_contributions` (P2).
- **Profile:** `accessibility_settings`, `caregiver_links`; export/delete touch all owner data via an audited Edge Function.

### 6.3 Performance

- Lazy-load module features via `go_router`; keep the Home hub instant. Camera/WebRTC initialized only on entering Vision AI / Consultation. Cache tutorials and settings for offline.

### 6.4 Accessibility (mandatory per screen)

- Title auto-focus + spoken summary + "Replay audio".
- Every interactive element labeled; cards merged; decorative excluded.
- Dynamic results/errors/SOS via live-region announcements.
- Haptic per catalog; contrast ≥ 4.5:1; targets ≥ 48dp; text scale to 300%.
- A working Aura Voice path for the screen's core task.
- Medical-sensitive screens never display or cache data outside owner scope.

---

## IMPLEMENTATION CHECKLIST (Frontend Team)

- [ ] Bottom nav ≤ 5 destinations; shallow hierarchy; no deep sub-menus.
- [ ] Aura Voice shortcut + global SOS gesture present app-wide.
- [ ] Each module: titled, summarized, replayable, voice-reachable.
- [ ] Vision AI: < 3 s scene description, on-device OCR < 1 s, offline fallback announced.
- [ ] Prosthetic catalog: audio descriptions are primary content, not images.
- [ ] Custom order: explicit read-aloud consent before submit; iris photo owner-only.
- [ ] Connect: alt-text enforced on image upload.
- [ ] SOS: three redundant triggers, danger haptic, cancel cooldown.
- [ ] Settings apply live and are announced; medical export/delete double-confirmed.
- [ ] `meetsGuideline(...)` passes for contrast, tap target, labeled-tap-target on every screen; manual TalkBack/VoiceOver + 300% text pass.
