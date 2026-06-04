# Product Requirements Document (PRD): Opto — "Invisible & Inclusive" Super App

**Platform:** Mobile (Flutter) — Android & iOS (primary client)
**Tech Stack:** Flutter (Dart) + Riverpod + `go_router` (Client), Supabase (Backend: Postgres + Row Level Security, Auth, Storage, Realtime, Edge Functions/Deno), Google ML Kit (on-device OCR/object detection), Cloud Multimodal LLM via Edge Function (scene description), WebRTC (telemedicine), Firebase Cloud Messaging (push, dispatched via Edge Functions).

> **Core focus:** blind users, low-vision users, and ocular-prosthesis wearers. Every feature must be completable **without looking at the screen**.

## 1. Product Overview

Opto is a unified, accessibility-first super app that empowers people with visual disabilities through assistive technology, ocular medical access, and community support. It consolidates eight modules that are otherwise fragmented across many inaccessible mainstream apps into a single voice-first, screen-reader-perfect experience.

### Project Objectives

- **Independence:** Let users complete core tasks (read text, order/care for an ocular prosthesis, consult a specialist, trigger emergency help) independently and quickly.
- **Verified ocular marketplace:** Become the leading ocular + assistive platform in Indonesia, backed by a verified ocular-prosthetics marketplace.
- **Accessibility compliance:** Pass a **WCAG 2.2 AA** audit on all critical flows and achieve full TalkBack & VoiceOver compatibility.
- **Medical privacy by default:** Treat ocular photos, anthropometric data, and consultation history as sensitive medical data, protected at the database layer (Row Level Security) and in storage.

## 2. The Eight Modules (Ecosystem)

| # | Module | Role |
| :-- | :-- | :-- |
| 1 | **Prosthetic Hub (Ocular)** | Verified catalog of eye prosthetics & self-cleaning cases; anthropometric custom orders; usage & care tutorials (video + text + audio). |
| 2 | **Health & Consultation** | Telemedicine with eye specialists/ocularists; camera-based non-verbal consultation; schedule booking & clinic-manufacturer locations. |
| 3 | **Vision AI ("Aura")** | Real-time digital eye: scene description, text reading (OCR), object/color ID, lightweight navigation cues. |
| 4 | **Connect (Community)** | A Threads-like space for sharing experiences, motivation, and Q&A. |
| 5 | **Emergency SOS** | Location-based emergency trigger + notifications to caregivers and the nearest community. |
| 6 | **Accessibility Map** | Collaborative map of disability-friendly facilities (ramp, elevator, tactile path, wheelchair access). |
| 7 | **Aura Voice** | Voice-navigation layer across every screen ("Order prosthetic", "Find a doctor", "Call emergency"). |
| 8 | **Profile & Accessibility Settings** | Full control over theme, typography, haptics, voice, caregiver linking, and medical data export/delete. |

## 3. User Personas & Roles

Opto's user base spans a **vision spectrum**, not a single condition. The UI must be both visually pleasant (for monocular/low-vision users) and perfect when invisible (for totally blind users).

### A. "Rian" — Totally Blind (Power Screen Reader User)
- 24, student; 100% reliant on screen reader + audio + haptic. Uses TalkBack, headset, Bluetooth Braille keyboard.
- **Needs:** fast & accurate Vision AI, Aura Voice, Emergency SOS, Connect.
- **Frustrations:** unlabeled buttons, focus-trapping pop-ups, long registration flows.

### B. "Sari" — Low Vision (Magnifier + Contrast)
- 38, office worker; retinitis pigmentosa, ~10° tunnel vision. Uses 200% magnification, dark mode, occasional TalkBack.
- **Needs:** scalable typography (up to 300%), high contrast, Accessibility Map, Vision AI scene description.
- **Frustrations:** text that breaks layout when enlarged, low contrast, maps that don't mark ramps/elevators.

### C. "Bima" — Ocular Prosthesis User (Monocular)
- 31, lost his right eye (enucleation), wears an ocular prosthesis; usually does not need a screen reader but needs a bright, clear UI.
- **Needs:** Prosthetic Hub (anthropometric custom order), care tutorials, camera-based non-verbal consultation, Connect.
- **Frustrations:** unsure how to care for the prosthesis, hard to find an ocularist, afraid of ordering the wrong size online, embarrassed to consult.

### D. "Ibu Lestari" — Caregiver
- 55, mother of a blind user.
- **Needs:** caregiver linking, SOS notifications, booking access & reminders.
- **Frustrations:** doesn't know when her child needs help; medical info is scattered.

### Accessibility Needs Matrix

| Need | Rian (blind) | Sari (low vision) | Bima (ocular) | Lestari (caregiver) |
| :-- | :--: | :--: | :--: | :--: |
| Full screen reader | Required | Partial | Optional | Optional |
| High contrast / Dark | Audio-first | Required | Preference | — |
| Scalable text 300% | — | Required | Some | Some |
| Haptic feedback | Required | Important | Some | Some |
| Voice navigation | Required | Important | Some | Some |

## 4. Product Principles ("Invisible & Inclusive")

1. **Function before aesthetics** — every element must be meaningful when read aloud.
2. **Three senses, one piece of information** — important status is delivered via **visual + audio + haptic** redundantly.
3. **Voice-first, vision-optional** — all core tasks completable without looking at the screen.
4. **Medical privacy by default** — ocular data and camera input are sensitive; enforced via Supabase RLS + Storage policies.
5. **Simple over complete** — shallow navigation; avoid deep sub-menus.

## 5. Core Workflows (Summary)

### Flow 1 — Onboarding & Accessibility Setup (P0)
1. First launch detects OS accessibility settings (font scale, screen reader active) and offers to auto-apply.
2. User sets theme (Light default; Dark & High-Contrast optional), text size, voice, and haptic — each step has "Skip" and "Replay audio" (single tap), 100% completable via TalkBack/VoiceOver.
3. Login via voice/SMS OTP or biometrics — **no visual CAPTCHA**. Field errors announced via live region + haptic error pattern.

### Flow 2 — Vision AI "Aura" (P0)
1. User opens scene-description mode; "ready to scan" haptic fires when the camera is stable.
2. Cloud LLM (via Edge Function) returns a description in < 3 s; output is read aloud automatically (single tap to replay, double-tap for extended detail).
3. OCR mode (on-device ML Kit) reads printed/handwritten text and Rupiah; haptic/audio guides camera positioning; recognized text can be saved and replayed.

### Flow 3 — Prosthetic Hub Custom Order (P0)
1. User browses a verified catalog; every product has a full **audio description** (material, size, care, price), not just an image. Filter by iris color, size, type.
2. Guided measurement: camera photographs the healthy eye for iris/sclera color matching (**medically sensitive**; on-device capture → ocularist review). Anthropometric fields filled manually or pulled from ocularist records.
3. Order confirmation reads a summary aloud and requires explicit consent.

### Flow 4 — Health & Consultation (P0)
1. Find/book eye specialists/ocularists by available slot & clinic-manufacturer location; entire flow completable via Aura Voice.
2. Camera-based **non-verbal mode**: patient points the camera at their eye; doctor's instructions are read aloud / shown as text; haptic/audio guides camera position. WebRTC video, signaling via Supabase Realtime; recording is opt-in with explicit consent.

### Flow 5 — Emergency SOS (P0)
1. Redundant triggers: large Home button **+** global gesture (hold 3 s) **+** voice ("Call emergency").
2. Sends real-time location to caregivers & emergency contacts + option to call emergency services.
3. Long, pulsing danger-haptic + audio confirmation "SOS sent". Cancellation cooldown prevents false alarms.

### Flow 6 — Connect, Map, Settings (P1/P0)
- **Connect:** voice-dictated short text threads; images **must** have alt-text (enforced at upload); moderation/reporting screen-reader accessible.
- **Accessibility Map:** POIs expose read-aloud accessibility attributes; navigation integrated with audio guidance.
- **Settings:** live changes (no restart) announced by screen reader; medical data export/delete available.

## 6. Detailed Feature Specs (Acceptance Highlights)

- **Audio-complete product cards:** every catalog item exposes a full audio description and merges into a single semantic unit.
- **Hybrid Vision AI:** latency-critical/private tasks (OCR, object detection) run **on-device**; rich scene description runs in the **cloud** via Edge Function with a brief offline fallback announced by audio.
- **Medical-sensitive data handling:** eye photos / anthropometric data / consultation history are encrypted at rest & in transit and gated by Row Level Security; granular camera & location permissions with read-aloud purpose strings.
- **Redundant SOS:** three independent triggers, real-time location dispatch via Realtime + Edge Function, distinctive danger haptic, false-alarm cooldown.

## 7. Scope

**In-Scope (phased — see Roadmap):** all eight modules on Flutter (Android & iOS), backed by Supabase.

**Out-of-Scope (initial version):**
- Limb prosthetics (hands/feet) — explicitly excluded; focus is ocular.
- Full web/desktop client (web is for landing & admin only; out of this agent team's scope).
- BPJS/insurance integration (post-MVP).
- Wearable hardware (smart glasses) — Aura stays phone-camera-based in V1.

## 8. Phased Roadmap

| Phase | Focus | Modules |
| :-- | :-- | :-- |
| **MVP (P0)** | Core independence & safety | Onboarding, Vision AI (scene + OCR), Prosthetic Hub (catalog + order + tutorials), Health & Consultation (booking + consultation), Emergency SOS, Profile/Settings |
| **V1 (P1)** | Community & retention | Connect, Accessibility Map, care reminders, eye-care exercises, Vision AI object/color |
| **V2 (P2)** | Advanced | Obstacle navigation, topic follow, map contribution, insurance integration (evaluate) |

## 9. Success Metrics (North Star + KPIs)

**North Star:** independent task completions per active user per week (core tasks done without visual/human assistance).

Key targets: scene-description latency **< 3 s**; OCR accuracy **≥ 95%** (ID/EN); semantic-label coverage **100%** of critical flows; SOS trigger→alert median **< 5 s**, false-alarm **< 5%**; onboarding completion **≥ 85%**; voice-only booking completion **≥ 70%**; SUS **≥ 80**. Accessibility KPIs **must be validated with real blind/low-vision users**, not only automated audits.

---

*This is the agent team's working summary of the full Opto PRD. For exhaustive user stories and acceptance criteria, defer to the canonical PRD document maintained by the product owner.*
