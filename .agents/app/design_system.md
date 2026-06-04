# Design System Brief — Opto

**Target Audience:** UI/UX Accessibility Specialist, Flutter Engineer
**Design Theme:** "Invisible & Inclusive" — function before aesthetics, perfect when unseen, pleasant when seen.
**Implementation:** Flutter `ThemeData` / `ColorScheme`, `Semantics`, `HapticFeedback`, `MediaQuery.textScaler`.

## 1. Overview

The interface must be **completable without looking at the screen** (totally blind users) while remaining **bright, clean, and legible** (low-vision and monocular ocular-prosthesis users). Every important status is conveyed through **three redundant senses: visual + audio + haptic**.

## 2. Design Principles

- **Function before aesthetics:** every element is meaningful when read aloud by TalkBack/VoiceOver. Decorative elements use `ExcludeSemantics`.
- **Three senses, one piece of information:** confirmations, warnings, and danger are signaled visually, audibly, and haptically at once.
- **Voice-first, vision-optional:** every core task has an Aura Voice path and a touch path.
- **Clean & minimalist:** generous white space so screen readers cleanly separate content from chrome; shallow navigation (no deep sub-menus).
- **Simple over complete:** a small, predictable surface beats a dense one.

## 3. Color & Contrast

**Default theme is High-Contrast (then Dark, then Light).** Text contrast ratio **≥ 4.5:1** (WCAG AA); large elements/icons **≥ 3:1**.

| Token       | High-Contrast (default) | Dark      | Usage                         |
| :---------- | :---------------------- | :-------- | :---------------------------- |
| `surface`   | `#000000`               | `#0E1116` | App background                |
| `onSurface` | `#FFFFFF`               | `#F5F7FA` | Primary text/icons            |
| `primary`   | `#3DA9FF`               | `#2D8CFF` | Primary actions, focus accent |
| `onPrimary` | `#000000`               | `#FFFFFF` | Text on primary               |
| `success`   | `#28E07A`               | `#1FB866` | Confirmation states           |
| `warning`   | `#FFD23F`               | `#E6B800` | Warnings, pending             |
| `danger`    | `#FF4D4D`               | `#E53935` | SOS, destructive, errors      |
| `focusRing` | `#FFD23F`               | `#FFD23F` | Visible focus outline (≥ 3px) |

- **Never encode meaning by color alone** — pair with text + icon + audio + haptic.
- Status badges always carry a text label and an audio announcement, not just a hue.

## 4. Typography

- **Default font:** **Atkinson Hyperlegible** (designed for low vision); fallback to the platform high-legibility font.
- **Scalable to 300%:** honor `MediaQuery.textScaler` (1.0–3.0). Layouts must **reflow** — no clipping, no overflow, no fixed-height text containers.
- **Minimum body size:** 16sp at scale 1.0; line height ≥ 1.5; ample letter spacing.
- Avoid all-caps for long text (hurts low-vision reading); avoid italics for critical info.

## 5. Spacing, Layout & Touch Targets

- **Touch target minimum: 48×48 dp**, with adequate spacing between adjacent targets.
- Generous padding (base unit 8dp; sections 24–32dp) and clear visual grouping; cards `merge` their semantics into a single readable unit.
- One primary action per screen where possible; keep the bottom navigation to 4–5 destinations.

## 6. Haptic Pattern Catalog (consistent app-wide)

| Event                            | Pattern                                       | Flutter                                       |
| :------------------------------- | :-------------------------------------------- | :-------------------------------------------- |
| Confirmation / success           | 1× short                                      | `HapticFeedback.lightImpact()`                |
| Warning / error                  | 2× medium                                     | two `mediumImpact()` spaced ~120ms            |
| Danger / SOS active              | Long, pulsing (distinctive; **never reused**) | custom vibration pattern via platform channel |
| Camera ready to scan (Vision AI) | 1× soft                                       | `HapticFeedback.selectionClick()`             |
| Nearby obstacle (navigation, P2) | Intensity increases with proximity            | escalating pattern                            |
| Tab navigation                   | Light tick                                    | `HapticFeedback.selectionClick()`             |

Haptic intensity respects `accessibility_settings.haptic_intensity` (`off`/`light`/`full`).

## 7. Voice Command Catalog (Aura Voice)

Activation: an Aura shortcut on **every** screen + optional hotword (off by default for battery/privacy). Natural-language → intent → `go_router` route. If ambiguous, Aura confirms by audio before acting.

| Command (ID/EN)                            | Route / Action                 |
| :----------------------------------------- | :----------------------------- |
| "Apa ini" / "Describe this"                | Vision AI — scene description  |
| "Baca teks" / "Read text"                  | Vision AI — OCR                |
| "Pesan prostetik" / "Order prosthetic"     | Prosthetic Hub → order flow    |
| "Cari dokter" / "Find a doctor"            | Health & Consultation → search |
| "Jadwal saya" / "My schedule"              | Consultation bookings          |
| "Buka komunitas" / "Open community"        | Connect                        |
| "Panggil darurat" / "Call emergency"       | Emergency SOS trigger          |
| "Fasilitas terdekat" / "Nearby facilities" | Accessibility Map              |
| "Perbesar teks" / "Dark mode"              | Accessibility settings         |

## 8. Gestures

- **Single tap** = replay audio for the focused element. **Double-tap** = activate/select. **Swipe** = move between content/menus.
- Never make a complex multi-finger gesture the **only** way to do something; always provide a button and a voice alternative.

## 9. Screen Reader Rules (TalkBack & VoiceOver)

- Every interactive element exposes `label`, `hint`, `role`, and `value` via `Semantics`/`MergeSemantics`.
- **Focus order:** logical top→bottom, left→right, following information hierarchy.
- **Live regions:** dynamic status (Vision AI result, form error, "SOS sent") announced via `SemanticsService.announce` / `liveRegion: true`.
- **No focus traps:** modals/bottom sheets are dismissible and never trap focus.

## 10. Core Accessible Components (Flutter)

- **`A11yButton`** — ≥ 48dp, semantic label + hint, success haptic on press, visible focus ring.
- **`A11yCard`** — `MergeSemantics` so a product/doctor card reads as one unit (e.g. "Acrylic ocular prosthesis, brown iris, custom, three hundred fifty thousand rupiah, double-tap to open").
- **`A11yField`** — label + hint + error announced via live region + error haptic; no placeholder-only labels.
- **`AuraVoiceButton`** — persistent shortcut, large target, announces "Aura listening".
- **`SosButton`** — oversized danger-colored Home control; long-press global gesture mirror; danger haptic + "SOS sent" announcement.

## 11. Testing Hooks

- Automated: `flutter_test` + Accessibility Guidelines API (`meetsGuideline(textContrastGuideline, androidTapTargetGuideline, iOSTapTargetGuideline, labeledTapTargetGuideline)`).
- Manual matrix: TalkBack (Android), VoiceOver (iOS), text scale 200–300%, dark/high-contrast, external keyboard. Accessibility KPIs validated with **real blind/low-vision users**.
