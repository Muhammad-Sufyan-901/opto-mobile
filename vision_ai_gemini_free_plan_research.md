# Gemini API Free Plan (Google AI Studio) — Viability for Opto Vision AI Sub-Features

> **Scope:** Research only — no code. Informs Phase 3F (`scene-describe` Edge Function) of
> `opto_backend_implementation_plan.md`, against `design_system.md` §12.2 (Vision AI "Aura")
> and `vision_ai_model_research.md`.
>
> **Date:** June 2026 · **Question:** Is the Gemini *free* tier viable, per sub-feature, for a
> pre-revenue **production** app?

---

## TL;DR

**No — the Gemini free tier is not viable for Opto production**, for two independent
disqualifying reasons that apply to every sub-feature that sends user data to the cloud:

1. **🔴 Privacy/training:** the free tier lets Google use your **inputs *and* outputs** to
   improve its models, with **no per-request opt-out**. Opto's only cloud sub-feature
   (scene description) sends **camera frames of blind/low-vision users and their
   environments** — faces, homes, documents, potential medical context. This violates
   **UU PDP** (Indonesia's data-protection law) and contradicts the design brief's
   proxy-and-discard requirement.
2. **🔴 Quota:** free-tier limits are **per Google Cloud project, not per user**. The whole app
   shares ~**1,000 requests/day** (Flash-Lite) and a **15 RPM** ceiling — it cannot serve a
   real user base.

Crucially, **most of Opto's Vision AI is on-device ML Kit and never calls Gemini at all**
(OCR, object detection, color). The free-tier question only meaningfully touches **scene
description** (and, later, P2 cloud navigation). For those, the answer is: **free = local dev
with non-sensitive test frames only; production = billing-enabled paid Gemini or Vertex AI**
(cost is near-zero, ~$1.70 per 10,000 calls — see `vision_ai_model_research.md`).

---

## 1. Free plan quota table (Google AI Studio, 2026)

| Model | RPM | RPD | TPM | Trains on your data? | Bahasa Indonesia quality | Free-tier status |
|---|---|---|---|---|---|---|
| **Gemini 3 Flash** | 15 | ~1,500 | ~250k (some sources cite 1M*) | ✅ **Yes** (inputs + outputs) | Top-tier (Flash family leads BI) | ✅ Default free model (early 2026) |
| **Gemini 2.5 Flash** | 10 | 250 | ~250k | ✅ **Yes** | Top-tier | ✅ Available |
| **Gemini 2.5 Flash-Lite** | 15 | 1,000 | ~250k | ✅ **Yes** | Top-tier | ✅ Available (most generous) |
| **Gemini 2.5 Pro** | — | — | — | (was yes) | Top-tier | ❌ **Free tier removed Apr 2026** |

\* **TPM discrepancy:** Google's official rate-limit page no longer lists fixed numbers (it
shows your live cap in AI Studio). Aggregator sources split between **250,000 TPM** (most) and
**1,000,000 TPM** (likely conflating TPM with the 1M-token *context window*). Treat **~250k TPM**
as the safe planning figure. All free quotas are **per Cloud project, not per API key**; RPD
resets at **00:00 PT**; varies by region/account age/billing status; no card, no expiry.

**Quality note:** free vs paid runs the *same models* — Bahasa Indonesia output quality is
**identical**. The free tier's problem is **privacy and quota, never quality**.

---

## 2. Sub-feature fit table

| Vision AI sub-feature | Uses Gemini? | Best free model | Viable for production? | Reason |
|---|---|---|---|---|
| **Scene description** ("Describe scene", cloud, < 3s BI) | ✅ Cloud | Gemini 2.5 Flash-Lite (or Gemini 3 Flash) | ❌ **No** | Sends real user camera frames → free tier **trains on them** (UU PDP breach); ~1k RPD/15 RPM shared cap can't serve users. **Dev-only.** |
| **OCR — "Read text"** (BI+EN, Rupiah) | ❌ On-device ML Kit | N/A | ✅ Yes (not Gemini) | Runs on-device per plan; no cloud call, no free-tier exposure. |
| **Object detection — "Identify"** | ❌ On-device ML Kit | N/A | ✅ Yes (not Gemini) | On-device; no Gemini dependency. |
| **Color detection — "Colors"** | ❌ On-device CV | N/A | ✅ Yes (not Gemini) | On-device color CV (also used for prosthetic iris match); no cloud. |
| **Navigation assistance** (P2) | ⚠️ On-device cues; cloud optional | Gemini 2.5 Flash-Lite *if* cloud-assisted | ❌ **No** (if cloud) / ✅ (if on-device only) | Any cloud frame inherits the **same training + quota blockers** as scene description. |
| **Aura voice output** (TTS of results / intent) | ❌ TTS + on-device intent | N/A (Gemini not required) | ✅ Yes | Speech output is device/cloud TTS, not Gemini multimodal. If Gemini ever parses voice intents, free tier still **trains on transcripts** → use paid for any real user voice. |

**Bottom line:** only **scene description** (and optional P2 cloud navigation) actually depend
on Gemini. For those, the free tier is **not** production-viable. The rest are unaffected
because they never leave the device.

---

## 3. Critical blockers (disqualifying for production)

| # | Blocker | Severity | Detail |
|---|---|---|---|
| 1 | **Free tier trains on inputs *and* outputs** | 🔴 Critical | Google's free-tier terms permit using your prompts/responses to improve models, with **no per-request opt-out**. Camera frames of users (faces, homes, documents, medical/prosthetic context) being used for training **violates UU PDP** and the brief's "proxy-and-discard" rule. The *only* fix is paid tier or Vertex AI (neither trains on data). |
| 2 | **Quota is per-project, not per-user** | 🔴 Critical | Flash-Lite ~**1,000 RPD** / Flash **250 RPD**, **15 RPM** ceiling — shared across *all* Opto users. A handful of active users exhausts the daily cap; bursts hit the per-minute wall and fail. Adding more API keys does **not** add quota (limits bind to the Cloud project). |
| 3 | **Gemini 2.5 Pro free tier removed (Apr 2026)** | 🟠 High | No free high-capability tier remains for hard/low-light scenes; free tier tops out at Flash/Flash-Lite. |
| 4 | **No SLA / live-variable caps** | 🟡 Medium | Free caps vary by region, account age, and billing status and can change without notice — unacceptable for a feature blind users rely on. |

Privacy quality/latency are **not** blockers — the models are identical to paid; the free tier
fails purely on **data-training policy** and **shared quota**.

---

## 4. Conditional path (when, if ever, free tier is acceptable)

The free tier is acceptable **only for non-production** use, under all of these conditions:

- **Local development & internal QA only** — never a shipped/beta build serving real users.
- **Non-sensitive test frames only** — synthetic scenes, stock images, or the developer's own
  consented test material; **never** real end-user camera frames, faces, or medical context.
- **Stay under project quota** — keep test volume below ~1,000 RPD / 15 RPM; the single
  dev project is the shared bucket.
- **Treat output as throwaway** — assume anything sent may be used by Google for training.

**For any production or user-facing beta**, the conditions collapse to a single requirement:

- **Enable billing → use the paid Gemini API (or Vertex AI).** Paid tier and Vertex **do not
  train on your data**, lifting blocker #1, and remove the punishing free RPD/RPM caps
  (blocker #2). Cost stays near-zero at Opto's scale (~$1.70 / 10,000 scene-describe calls).
  Pair this with the controls already specified in `vision_ai_model_research.md` §2: Edge
  Function proxy-and-discard (no frame persisted/logged), per-user rate limiting to protect
  spend, capped `max_output_tokens`, and provider behind a single env var.

A "free tier in closed beta with a consent screen" path is **not recommended**: obtaining
meaningful UU PDP consent to *train Google's models on a blind user's live camera feed* is
impractical and ethically poor for this user group, and the shared 1k-RPD cap would still
throttle the beta. The paid tier removes both problems at trivial cost — there is no real
free-tier production path for the cloud sub-features.

---

## Sources

- [Rate limits — Gemini API (official)](https://ai.google.dev/gemini-api/docs/rate-limits)
- [Gemini Developer API pricing (official)](https://ai.google.dev/gemini-api/docs/pricing)
- [Gemini API Free Tier 2026: 1,500 Req/Day, 1M TPM — TokenMix](https://tokenmix.ai/blog/gemini-api-free-tier-limits)
- [Gemini API Rate Limits per Tier 2026 — AI Free API](https://www.aifreeapi.com/en/posts/gemini-api-rate-limits-per-tier)
- [Gemini API Free Tier 2026: Limits & Quotas — PE Collective](https://pecollective.com/tools/gemini-free-tier-guide/)
- [Gemini API Free Tier Limits 2026 explained — Harboratory](https://harboratory.com/gemini-api-free-tier-limits-in-2026-explained/)
- [Does Gemini Free Tier Train on Your Data? — BSWEN](https://docs.bswen.com/blog/2026-03-23-gemini-free-tier-data-privacy/)
- [Pro free tier becomes paid in April 2026 — Apiyi](https://help.apiyi.com/en/google-gemini-api-free-tier-changes-april-2026-guide-en.html)
- [Gemini API free-tier quota is per project, not per key — LaoZhang AI](https://blog.laozhang.ai/en/posts/gemini-api-free-tier)
- Internal: `vision_ai_model_research.md` (model comparison, BI quality, paid-tier cost)
