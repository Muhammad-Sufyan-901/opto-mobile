# On-Device / Offline Vision-Language Models for Opto's `scene-describe` — Research & Recommendation

> **Scope:** Research only — no code. Companion to `vision_ai_model_research.md` (which
> covers the *cloud* path and already selected **Gemini 2.5 Flash-Lite**). This document
> evaluates **on-device / offline VLMs** as an alternative or complement, informing
> Phase 3F of `opto_backend_implementation_plan.md`.
>
> **Date:** June 2026

---

## Context — why this research

Opto's Vision AI ("Aura") splits work between on-device and cloud:

- **On-device today (planned):** ML Kit Text Recognition (OCR), Object Detection, color CV.
  Fully offline, `< 1 s`, works on every phone. This is the *real* universal offline path.
- **Cloud (`scene-describe` Edge Function):** natural-language **scene description** spoken
  in **Bahasa Indonesia** in `< 3 s`, via Gemini 2.5 Flash-Lite (proxy-and-discard, paid tier).

The open question (`system_architecture.md` §4 "Hybrid strategy"; design_system §12.2 offline
behavior): **can a small on-device VLM produce the natural-language scene description itself**,
so that the rich "describe scene" feature keeps working with no connection — instead of only
falling back to ML Kit labels + a "needs internet" announcement?

This matters specifically because Opto's users are **blind / low-vision**, the output is
**read aloud** (so language fluency is paramount), and the target market is **Indonesia**, where
**budget Android devices (2–4 GB RAM) dominate**. Those three facts shape every conclusion below.

---

## 1. Offline candidate table

| Model | Size (params / on-disk Q4) | Min device to run acceptably | On-device image-caption latency | Bahasa Indonesia quality | Flutter integration path | License |
|---|---|---|---|---|---|---|
| **Gemma 4 E2B** (Apr 2026) | 2.3 B eff. / ~2 GB RAM at Q4; ~2 GB download | Flagship/upper-mid, ≥6 GB RAM + GPU/NPU. **Text+audio; vision is on E4B** — E2B not the captioner. | n/a for vision (use E4B) | 140-lang incl. BI; small-model fluency = modest | **`flutter_gemma`** (pub.dev) via MediaPipe/LiteRT-LM | **Apache 2.0** — clean commercial use |
| **Gemma 4 E4B** (Apr 2026) | 4.5 B eff. / ~5 GB RAM at Q4; ~5 GB download | **≥8 GB RAM + NPU** (Snapdragon 8-gen / Dimensity 9000+ / A17 Pro). On CPU only ~2–5 tok/s. | **Multi-second** on mid-range (image prefill dominates); near-real-time only on top NPUs | 140-lang incl. BI; best of the on-device set but **below cloud Gemini** | `flutter_gemma` (vision supported) | **Apache 2.0** |
| **Gemma 3n E4B** (2025 predecessor) | ~4 B eff. / ~3 GB RAM at Q4 | Same class as Gemma 4 E4B | Multi-second on mid-range | 140-lang incl. BI; slightly below Gemma 4 | `flutter_gemma` | **Gemma Terms of Use** (commercial OK, but redistribution conditions + Prohibited-Use Policy) |
| **Apple Foundation Models** (on-device 3 B) | ~3 B / bundled in OS (no app download) | **iOS only, A17 Pro+** → iPhone 15 **Pro**, iPhone 16+. Excludes iPhone 15 non-Pro and all older. | Fast on supported NPUs | **Uncertain for BI** — Indonesian is a *secondary* language group, not a primary-supported language | Native Swift `FoundationModels` via **platform channel / MethodChannel** | Free (part of OS); Apple devices only |
| **Llama 3.2 Vision 11B** | 11 B / ~7–8 GB+ even quantized | **Not phone-viable** for vision | n/a (impractical) | Llama family lags Gemini/Gemma on BI | **Blocked: `llama.cpp` does NOT support Llama 3.2 *vision*** (text 1B/3B only) | Llama Community License (<700 M MAU) |
| **Other VLMs** (Qwen2.5-VL, SmolVLM, FastVLM via MLC-LLM / ONNX RT Mobile / `flutter_gemma`) | ~0.5–3 B / 0.5–3 GB | Small ones run on mid-range; quality drops sharply | Varies; small = faster but weaker | **Weak for BI** (English/Chinese-centric) | `flutter_gemma` (FastVLM/Qwen2.5-VL) or MLC-LLM bridge | Mostly Apache/MIT; check per model |

**Cross-cutting infra note:** the MediaPipe LLM Inference API is now **maintenance-only**;
Google steers new work to **LiteRT-LM**. `flutter_gemma` is the practical Flutter on-ramp and
already wraps multimodal vision + GPU acceleration on Android/iOS.

---

## 2. Offline vs Cloud trade-off

| Dimension | On-device VLM (Gemma 4 E4B, best case) | Cloud `scene-describe` (Gemini 2.5 Flash-Lite) |
|---|---|---|
| **Latency** | Multi-second on mid-range; `< 3 s` only on top NPUs. Image prefill is the bottleneck. | ~0.3–0.4 s TTFT + round-trip; reliably `< 3 s` on **any** phone with a connection |
| **Cost** | $0 marginal per call (all on device) | ~$0.00017/call (~$1.70 / 10k). Negligible at Opto scale |
| **Privacy** | **Best — frame never leaves the device** | Strong — proxy-and-discard, paid tier (no training), in-memory only. Still a cross-border transfer (UU PDP consent needed) |
| **Offline availability** | **Works with no connection** (the whole point) | **None** — requires network |
| **Output quality / richness** | Good on flagship; **BI fluency below cloud**; weaker on cluttered scenes | **Top-tier BI fluency + richer descriptions** — the quality axis that matters most for read-aloud |
| **Device fragmentation risk** | **Severe** — excludes the 2–4 GB budget Android phones that dominate Indonesia; iOS path excludes non-Pro/older iPhones | **None** — server-side; runs identically on the cheapest phone |
| **Battery / thermal** | Sustained VLM inference heats the device and drains battery; repeated scans compound it | Negligible on-device (just camera + network) |
| **App size impact** | **2–5 GB model** — cannot be bundled; needs post-install download (Play Asset Delivery / On-Demand Resources) | Near-zero (just an HTTPS call) |

---

## 3. Top concerns per model (Opto-specific: blind users · Bahasa Indonesia · Indonesian budget devices)

**Gemma 4 / 3n E4B (best on-device candidate)**
1. **Device exclusion** — needs ~8 GB RAM + NPU; the budget 2–4 GB Android majority in Indonesia can't run it, so it can't be a *universal* offline answer.
2. **App-size / data cost** — a ~5 GB model download is prohibitive on metered Indonesian data plans and breaks the Play Store 200 MB initial-download expectation.
3. **BI fluency gap for read-aloud** — small-model Indonesian is "okay," noticeably below cloud Gemini; for a blind user who only hears the result, wrong/awkward phrasing is a real accessibility cost.

**Apple Foundation Models**
1. **Indonesian not a first-class language** — BI is in a secondary group; output quality for read-aloud is unverified.
2. **Hardware + platform exclusion** — iOS-only, A17 Pro+; leaves the entire Android base and older iPhones uncovered. Cannot anchor a cross-platform feature.
3. **No control / non-portable** — behavior tied to OS version and Apple Intelligence availability; can't standardize the Aura voice/prompt contract across platforms.

**Llama 3.2 Vision 11B**
1. **Not phone-viable** — 11 B vision model far exceeds budget-device memory.
2. **Tooling blocker** — `llama.cpp` doesn't support its vision path; no clean mobile route today.
3. **BI weaker** than Gemini/Gemma anyway.

**Existing cloud choice — Gemini 2.5 Flash-Lite** (for completeness)
1. **Hard network dependency** — zero output offline; degraded mode must be graceful and spoken.
2. **Cross-border transfer under UU PDP** — needs consent disclosure + strict proxy-and-discard (already in the cloud plan).
3. **Free-tier-trains-on-data footgun** — production must stay on the paid/Vertex tier (already flagged in `vision_ai_model_research.md`).

---

## 4. Recommendation per path

**Cloud (Gemini 2.5 Flash-Lite) → PRIMARY.** Unchanged. It is the only path that delivers
top-tier Bahasa Indonesia, `< 3 s`, and identical behavior on the cheapest phone — the exact
profile Opto needs. Keep the proxy-and-discard + paid-tier rules from `vision_ai_model_research.md`.

**On-device ML Kit (OCR / object / color) → UNIVERSAL OFFLINE FALLBACK.** Already planned.
This — not an on-device VLM — is the real "works on every phone, offline" path. When
`scene-describe` is unreachable, Aura announces the planned message ("Scene description needs
internet — OCR still works") and degrades to ML Kit labels.

**On-device VLM (Gemma 4 E4B) → OPTIONAL, OPT-IN ENHANCEMENT FOR HIGH-END DEVICES ONLY.**
Not recommended as a baseline or universal fallback. Reasonable as a **future, gated** feature:
a user on a capable device may *opt in* to download the model for richer offline descriptions.
Treat as post-MVP.

**Apple Foundation Models / Llama 3.2 Vision / other small VLMs → NOT RECOMMENDED** for Opto
now. Apple: platform-locked + unverified BI. Llama 3.2 Vision: not phone-viable. Others: weak BI.

**Is a hybrid (cloud primary + on-device VLM fallback) feasible?**
Yes, but **only conditionally** — and it does **not** replace the ML Kit fallback. An on-device
VLM fallback is realistic only on devices meeting roughly:

> **Minimum spec for on-device VLM scene description:** **≥ 8 GB RAM + a modern NPU**
> (Snapdragon 8-gen / Dimensity 9000+ class on Android; A17 Pro+ on iOS) **plus ~5 GB free
> storage** for the model.

That spec excludes the majority of Indonesian budget phones, so the **universal** offline
fallback must remain **ML Kit + spoken status**. The recommended layering:

1. Online → **Gemini cloud** (primary, all devices).
2. Offline + capable device that opted in → **on-device VLM** (future, gated by the spec above).
3. Offline + everything else → **ML Kit labels + "needs internet" announcement** (baseline).

---

## 5. Risk flags (adoption blockers for the on-device path)

| # | Risk | Severity | Note |
|---|---|---|---|
| 1 | **App-size / Play Store limit** — a 2–5 GB model can't ship in the 200 MB AAB; requires Play Asset Delivery / On-Demand Resources post-install download | 🔴 Critical | Big friction on metered Indonesian data; users may never download it |
| 2 | **Budget-device exclusion** — 2–4 GB RAM phones (the Indonesian majority) cannot run even E2B comfortably; E4B needs ~8 GB | 🔴 Critical | On-device VLM can never be the *universal* offline answer |
| 3 | **BI read-aloud quality below cloud** — accessibility cost for blind users who only hear the output | 🟠 High | Keep cloud as the quality bar; on-device is "degraded, better-than-labels" at best |
| 4 | **Latency on mid-range exceeds 3 s** — image prefill dominates; only top NPUs hit the budget | 🟠 High | Don't promise `< 3 s` offline; announce "describing… one moment" |
| 5 | **Battery / thermal** under repeated scans | 🟡 Medium | Cap concurrent inference; prefer cloud when online |
| 6 | **Llama 3.2 Vision blocked in `llama.cpp`**; MediaPipe LLM API in maintenance-only (→ LiteRT-LM) | 🟡 Medium | Pin to `flutter_gemma` + LiteRT-LM if/when pursued |
| 7 | **License hygiene** — Gemma 4 is clean **Apache 2.0** (preserve license + notices); Gemma 3n carries the stricter **Gemma Terms of Use** | 🟢 Low | Prefer Gemma **4** for the cleaner license if pursued |

---

## Sources

- [Introducing Gemma 3n (Google Developers Blog)](https://developers.googleblog.com/en/introducing-gemma-3n/)
- [Gemma 3n model overview (Google AI)](https://ai.google.dev/gemma/docs/gemma-3n)
- [Welcome Gemma 4: Frontier multimodal intelligence on device (Hugging Face)](https://huggingface.co/blog/gemma4)
- [Gemma 4 model overview (Google AI)](https://ai.google.dev/gemma/docs/core)
- [Gemma 4 E2B vs E4B edge models (MindStudio)](https://www.mindstudio.ai/blog/gemma-4-e2b-vs-e4b-edge-models-audio-vision-phone)
- [Gemma 4 for Edge Deployment — E2B/E4B on phones (MindStudio)](https://www.mindstudio.ai/blog/gemma-4-edge-deployment-e2b-e4b-models)
- [Gemma 4 local VRAM / quantization table (KnightLi)](https://knightli.com/en/2026/05/01/gemma-4-local-vram-quantization-table/)
- [Gemma 4 Apache 2.0 license (gHacks)](https://www.ghacks.net/2026/04/06/google-releases-gemma-4-in-four-model-sizes-under-apache-2-0-license/) · [Gemma Terms of Use](https://ai.google.dev/gemma/terms)
- [MediaPipe LLM Inference guide (Google AI Edge)](https://ai.google.dev/edge/mediapipe/solutions/genai/llm_inference/android)
- [flutter_gemma (pub.dev)](https://pub.dev/packages/flutter_gemma) · [fluttergemma.dev](https://fluttergemma.dev/)
- [Llama 3.2 edge & vision (Meta AI)](https://ai.meta.com/blog/llama-3-2-connect-2024-vision-edge-mobile-devices/) · [Llama 3.2 vision local inference notes (Medium)](https://medium.com/@shamim_ru/how-to-use-llama-3-2-vision-models-from-local-inference-to-api-integration-part-1-072ddf509b35)
- [Unleashing AI on Mobile — Llama 3.2 with ExecuTorch/KleidiAI (PyTorch)](https://pytorch.org/blog/unleashing-ai-mobile/)
- [Apple Foundation Models framework / on-device 3B (Apple ML Research)](https://machinelearning.apple.com/research/introducing-third-generation-of-apple-foundation-models)
- [Apple Intelligence supported devices (TechPP)](https://techpp.com/2026/04/01/apple-intelligence-supported-devices/)
- [Google Play app size limits / Play Asset Delivery (Play Console Help)](https://support.google.com/googleplay/android-developer/answer/9859372?hl=en)
