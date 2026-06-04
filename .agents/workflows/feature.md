---
description: Execute a complete development cycle to add a new feature, screen, or module across the Flutter + Supabase stack.
---

# Workflow: Feature Development

**Trigger:** When the user asks to add a new feature, screen, or capability.
**Execution Order:** @pm -> (Wait for User) -> @backend -> @frontend -> @qa

**Steps:**

1. **@pm** analyzes the request, maps it to the right Opto module + persona, designs the Supabase schema/RLS contract and the Flutter feature/route/voice-intent, and writes accessibility acceptance criteria in `.artifacts/technical_spec_review.md`.
2. **@pm** explicitly pauses and asks for user approval.
3. Upon approval, **@backend** implements migrations, **RLS policies**, Storage/Realtime config, and any Edge Functions, documenting the typed row shape.
4. Once the contract is ready, **@frontend** builds the isolated Flutter feature (presentation/domain/data) against it — accessibility-native, voice-first, haptic-redundant.
5. **@qa** audits for PRD alignment, runs the **accessibility checklist** + Accessibility Guidelines API, verifies **RLS happy/sad paths**, confirms integration, and writes the execution log into `.artifacts/logs/`.
