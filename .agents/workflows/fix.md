---
description: Investigate, diagnose, and fix reported bugs, errors, accessibility regressions, or RLS gaps.
---

# Workflow: Bug Fixing

**Trigger:** When the user reports an error, bug, accessibility regression, or unexpected behavior.
**Execution Order:** @qa -> @backend OR @frontend -> @qa

**Steps:**

1. **@qa** analyzes the report (stack trace, screen-reader behavior, or RLS leak) and writes a brief, direct fix-plan in `.artifacts/technical_spec_review.md` (approval skipped for rapid hotfixes). Accessibility and medical-data leaks are treated as high severity.
2. **@qa** delegates to **@backend** (schema/RLS/Edge Function/data issue) OR **@frontend** (UI/state/accessibility issue).
3. The assigned specialist executes the fix exactly, ensuring no regression — and for UI fixes, re-verifies labels, focus order, contrast, targets, haptic, and text-scale behavior.
4. **@qa** verifies the fix, ensures the build passes, re-runs the relevant accessibility/RLS checks, writes a summary in `.artifacts/logs/`, and notifies the user.
