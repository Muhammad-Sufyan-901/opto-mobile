---
description: Write and execute Flutter tests (including accessibility guideline tests) and Supabase RLS/Edge Function tests to guarantee stability and prevent regressions.
---

# Workflow: Unit & Feature Testing

**Objective:** Guarantee stability, prevent regressions, and secure both business logic and accessibility before release.
**Trigger:** After a feature is integrated, or when the user explicitly requests test coverage.
**Execution Order:** @qa -> @backend/@frontend (if fixes needed) -> (Wait for User)

**Steps:**

1. **@qa** writes **Flutter tests** (`flutter_test`) — unit tests for domain/use cases and repositories (mocked Supabase), widget tests for screens, and golden tests where layout matters.
2. **@qa** writes **accessibility tests** using the Accessibility Guidelines API: `meetsGuideline(textContrastGuideline, androidTapTargetGuideline, iOSTapTargetGuideline, labeledTapTargetGuideline)`; covers focus order and text scale at 200–300%.
3. **@qa** covers **Supabase RLS** with happy paths (owner allowed) and sad paths (stranger/revoked-caregiver/unrelated-doctor denied), and tests Edge Functions (Deno tests) for `scene-describe`, `sos-dispatch`, etc.
4. **@qa** ensures clean test state (reset/seed) for each case. If a test fails, flag **@backend**/**@frontend** to fix; once green, write the test report into `.artifacts/logs/` and notify the user.
