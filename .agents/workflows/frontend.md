---
description: Build accessibility-native Flutter screens and feature modules against the Supabase data contract, completable entirely without sight.
---

# Workflow: Frontend Development (Flutter)

**Objective:** Build the Flutter UI for a feature against the agreed Supabase contract, with accessibility as part of "done".
**Trigger:** When the Supabase foundation is ready, or the user specifically requests UI/UX implementation.
**Execution Order:** @frontend -> @integration

**Steps:**

1. **@frontend** creates Dart files in the correct `features/<module>/` (presentation/domain/data) following feature-first Clean Architecture; shared accessible widgets go in `core/`.
2. **@frontend** defines Dart models mapping 1:1 to the Supabase row shape, and feature repositories that wrap `supabase_flutter` (widgets never call the SDK directly).
3. **@frontend** builds the UI from the `ColorScheme` tokens (high-contrast default) and shared accessible components. **CRITICAL:** every interactive element gets `Semantics` (label/hint/role/value); decorative elements get `ExcludeSemantics`; dynamic status uses live-region announcements; haptics follow the catalog; targets ≥ 48dp; text scales to 300% with reflow.
4. **@frontend** wires Riverpod providers + `go_router` route and the **Aura Voice intent**, handling loading/empty/error/offline states explicitly (and announcing them).
5. Once built and wired to its repository, **@frontend** passes execution to **@integration** (or @qa).
