# Vision-Language Model Research for `scene-describe` Edge Function

> **Scope:** Research only — no code changes. This document informs Phase 3F of
> `opto_backend_implementation_plan.md` (Aura / Vision AI).
>
> **Date:** June 2026

---

## Background & Constraints

Opto's Phase 3F requires a Supabase Edge Function (`scene-describe`) that proxies a camera
frame to a cloud multimodal LLM and returns a **concise, natural-language scene description
spoken in Bahasa Indonesia in under 3 seconds** (`design_system.md` §12.2, `system_architecture.md` §3.5).
OCR / object detection / color stay **on-device** (ML Kit) and serve as the offline fallback.

**Hard constraints driving model selection:**

| Constraint | Source |
|---|---|
| Latency < 3 s end-to-end | design_system.md §12.2 + §13 KPI checklist |
| Bahasa Indonesia output quality (read aloud to blind users) | design_system.md §7 Voice Command Catalog |
| Near-zero cost (pre-revenue, Indonesian market) | product_requirements.md |
| Privacy-sensitive images must NOT be used for training | UU PDP (Indonesia data law) |
| Available / callable from Indonesia | deployment reality |
| Offline fallback already handled by ML Kit | system_architecture.md §4 |

---

## 1. Candidate Comparison Table

| Model | Price (input / output per 1M tokens) | Free tier | TTFT / throughput | Bahasa Indonesia quality | Data privacy & region |
|---|---|---|---|---|---|
| **Gemini 2.5 Flash-Lite** | **$0.10 / $0.40** | ✅ ~5–15 RPM, ~1–1.5k req/day, 1M TPM; no card | **~0.3–0.4 s TTFT**, ~390 tok/s — fastest here | **Top-tier** — Gemini Flash family leads BI in multilingual evals | Available in Indonesia. ⚠️ **Free tier trains on data; paid tier & Vertex AI do not.** |
| **Gemini 2.5 Flash** | $0.30 / $2.50 | ✅ Same quotas | Very fast (slightly below Lite) | Top-tier | Same caveat. Flagged for Vertex AI EOL 16 Oct 2026. |
| **GPT-4o-mini** | $0.15 / $0.60 | ❌ No perpetual free API tier | Fast, vision-capable | Good — slightly more variance on BI vs Gemini | Available in Indonesia. API data not used for training by default; 30-day abuse-log retention. ZDR available on approval. |
| **GPT-5.4 mini** | ~$0.75 / $4.50 | ❌ | Fast, native vision, 400K ctx | Good | ~5–7× cost of GPT-4o-mini. Not justified for short captions. |
| **Claude Haiku 4.5** | $1.00 / $5.00 | ❌ | 0.69 s TTFT, ~108 tok/s | Strong | Available in Indonesia (direct API + Bedrock CRIS incl. ID region). Best-in-class privacy posture. Cost ~10× Flash-Lite. |
| **Groq — Llama 3.2 11B Vision** | $0.18 / $0.18 (input+output same) | ✅ 30 RPM / 6k TPM / ~1k req/day; no card | **Extremely fast** (Groq LPU) | Weaker — Llama family lags Gemini/Claude on BI | Groq does not train on user data. Good zero-cost failover. |
| **Groq — Llama 4 Scout** | (Preview pricing) | ✅ Same Groq free quotas | Extremely fast | Better than Llama 3.2 but still below Gemini | ⚠️ **Preview — not production-ready.** Vision input up to 20 MB. |
| **OpenRouter free tier** (Qwen2.5-VL, Llama 4 Scout/Maverick, Kimi-VL) | $0 on free endpoints | ✅ 20 RPM, 50–1k req/day (one-time $10 unlocks 1k/day) | Varies by upstream | Inconsistent — Qwen2.5-VL decent | ⚠️ Free routes may log/route data through third parties. **Not suitable for privacy-sensitive user images.** Prototyping only. |
| **ML Kit (on-device)** — OCR, Object Detection, color CV | $0 (bundled) | n/a | < 1 s, fully offline | Labels/text only — not prose | Already planned as the **offline fallback**. Not a cloud scene-description substitute. |

### Cost sanity check

One scene-describe call ≈ 1,024-px frame → ~1,300 input tokens + ~100 output tokens (concise BI caption):

| Model | Est. cost per call | Cost per 10,000 calls |
|---|---|---|
| Gemini 2.5 Flash-Lite | ~$0.00017 | ~$1.70 |
| GPT-4o-mini | ~$0.00025 | ~$2.50 |
| Claude Haiku 4.5 | ~$0.00150 | ~$15.00 |

Cost is negligible at small scale; the main cost driver is request volume, which makes the cheapest fast model with good Indonesian the clear winner.

---

## 2. Primary Recommendation — Gemini 2.5 Flash-Lite (paid tier)

**Why it best fits Opto's constraints:**

- **Latency:** lowest TTFT in the field (~0.3–0.4 s); highest throughput. Even factoring in
  Indonesia→US round-trip + image upload + short output, clearing **< 3 s** is straightforward.
- **Indonesian:** the Gemini Flash family consistently ranks at the top for Bahasa Indonesia in
  multilingual benchmarks — the single most important quality axis since the result is **read
  aloud to a blind user**.
- **Cost:** cheapest credible option at $0.10/$0.40 per 1M — effectively fractions of a cent
  per call.
- **Region:** fully available from Indonesia.
- **Maturity:** not Preview; stable production API.

### Critical implementation nuance — MUST use the paid tier in production

Gemini's **free tier uses inputs/outputs for model training**. Because `scene-describe` proxies
**camera frames of users and their environments** (potentially including faces and medical
context), the free tier violates UU PDP (Indonesia's data-protection law) for a production app.

**Rule:** Free tier = local dev only, with non-sensitive test frames.  
**Rule:** Production = billing-enabled paid Gemini API, or Vertex AI.

Paid-tier cost remains near-zero at Opto's expected scale.

### Recommended implementation pattern inside the Edge Function

1. Resize/compress the frame client-side before sending (e.g. 1024-px longest edge, JPEG 85) to
   minimize upload time against the 3 s budget.
2. Short, constrained system prompt: force a 1–2 sentence Bahasa Indonesia description, no
   markdown, no lists.
3. Cap `max_output_tokens` at ~150 — concise spoken output is the goal.
4. **Proxy-and-discard:** the Edge Function must not persist the frame in Supabase Storage or
   any log. Process in-memory and return the text only.
5. Apply Edge Function–level rate limiting (requests per user per minute) to protect cost.
6. Keep the model name and provider in a **single env var** — see "switchable adapter" note below.

---

## 3. Fallback Recommendation — GPT-4o-mini

If Gemini hits rate limits, availability issues, or unexpected latency spikes in Indonesia,
**GPT-4o-mini** is the immediate fallback:

- Comparable price ($0.15 / $0.60), fast vision-capable inference.
- Privacy-safe by default (no "must-be-paid-to-be-private" footgun) — API data not used for
  training; 30-day abuse-log retention acceptable under UU PDP with consent disclosure.
- Mature, reliable API; available in Indonesia.
- Indonesian quality is "good," occasionally more variable than Gemini Flash — acceptable
  as a backup.

**Tertiary zero-cost emergency fallback:** Groq free tier with Llama 3.2 11B Vision
(30 RPM / ~1k req/day). Accept weaker Indonesian as a temporary degraded mode; have Aura
announce "Scene description quality is reduced right now — try again shortly."

### Switchable provider adapter

Design the Edge Function so the provider/model is a **single config env var**
(`SCENE_DESCRIBE_PROVIDER=gemini | openai | groq`). All three speak similar
image+text chat request shapes. A provider swap becomes a redeploy with a new env value —
not a code change. This also neutralises the deprecation risk below.

---

## 4. Risk Flags

| # | Risk | Severity | Mitigation |
|---|---|---|---|
| 1 | **Gemini free tier trains on user images** | 🔴 Critical | Production must use paid Gemini or Vertex AI. Document in code + UU PDP review. |
| 2 | **Free-tier rate limits don't scale** | 🔴 Critical for prod | Any real user volume requires billing. Keep Edge Function rate limiter to protect cost. |
| 3 | **Gemini 2.5 Flash Vertex EOL 16 Oct 2026** | 🟠 High | Pin to **Flash-Lite** (not 2.5 Flash); keep model id behind env var for one-line migration. |
| 4 | **Groq Llama 4 Scout is Preview** | 🟠 High | Do not use in production. Groq Llama 3.2 11B Vision is the stable free-tier choice if needed. |
| 5 | **OpenRouter free routes log/route data** | 🟠 High | OpenRouter free tier is suitable for prototyping only — not for real user images. |
| 6 | **Indonesia → US latency tail** | 🟡 Medium | Compress frame client-side; cap output tokens; short prompt; stream response; measure p95 latency from Indonesia, not just median. |
| 7 | **Indonesian output variance** | 🟡 Medium | Constrain prompt to short factual descriptions; avoid long free-form prose; consider a sanity check before TTS. |
| 8 | **Cross-border image transfer (UU PDP)** | 🟡 Medium | Read-aloud consent via Camera permission screen (design_system.md §13); proxy-and-discard in Edge Function; existing offline fallback message already covers degraded mode. |

---

## Sources

- [Gemini API pricing 2026 (AI Cost Check)](https://aicostcheck.com/blog/google-gemini-pricing-guide-2026)
- [Gemini API pricing 2026 (TLDL)](https://www.tldl.io/resources/google-gemini-api-pricing)
- [Gemini free tier limits 2026 (TokenMix)](https://tokenmix.ai/blog/gemini-api-free-tier-limits)
- [Gemini free-tier data/privacy (BSWEN)](https://docs.bswen.com/blog/2026-03-23-gemini-free-tier-data-privacy/)
- [Gemini 2.5 Flash-Lite latency & performance (Artificial Analysis)](https://artificialanalysis.ai/models/gemini-2-5-flash-lite/providers)
- [Indonesian language model benchmark (Artificial Analysis)](https://artificialanalysis.ai/models/multilingual/indonesian)
- [Gemini multilingual / Indonesian (Skywork)](https://skywork.ai/blog/llm/gemini-3-multilingual-power-140-languages-tested-2025/)
- [OpenAI API pricing 2026 (PE Collective)](https://pecollective.com/tools/openai-api-pricing/)
- [GPT-4o-mini pricing 2026 (PricePerToken)](https://pricepertoken.com/pricing-page/model/openai-gpt-4o-mini)
- [GPT-5.4 mini pricing 2026 (GlobalGPT)](https://www.glbgpt.com/hub/how-much-is-gpt-5-4-mini-nano/)
- [OpenAI data controls / retention policy](https://developers.openai.com/api/docs/guides/your-data)
- [Claude API pricing 2026 (MetaCTO)](https://www.metacto.com/blogs/anthropic-api-pricing-a-full-breakdown-of-costs-and-integration)
- [Claude Haiku 4.5 specs & latency (PricePerToken)](https://pricepertoken.com/pricing-page/model/anthropic-claude-haiku-4.5)
- [Anthropic supported countries](https://anthropic.com/supported-countries)
- [Claude on Bedrock incl. Indonesia region (AWS)](https://aws.amazon.com/blogs/machine-learning/global-cross-region-inference-for-latest-anthropic-claude-opus-sonnet-and-haiku-models-on-amazon-bedrock-in-thailand-malaysia-singapore-indonesia-and-taiwan/)
- [Groq free tier limits 2026 (TokenMix)](https://tokenmix.ai/blog/groq-free-tier-limits-2026)
- [Groq pricing 2026 (eesel)](https://www.eesel.ai/blog/groq-pricing)
- [OpenRouter free tier 2026 (Klymentiev)](https://klymentiev.com/blog/openrouter-free-tier)
- [OpenRouter free models list (CostGoat)](https://costgoat.com/pricing/openrouter-free-models)
