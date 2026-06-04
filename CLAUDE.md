# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies
flutter pub get

# Run code generation (required after creating/modifying Freezed models)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app (real device strongly recommended for AI/AR features)
flutter run

# Analyze code
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart
```

> **Note:** AI (pose detection) and AR (3D model viewer) features require a real physical Android/iOS device.

## Architecture

**Feature-First Clean Architecture** — every business domain lives under `lib/features/[feature-name]/` and is split into exactly three layers:

- `data/` — DTOs, remote (Dio) and local (Hive) data sources, repository implementations
- `domain/` — pure Dart entities, repository interfaces (contracts), use cases (one `call()` method each)
- `presentation/` — BLoC (events/states), screens, and feature-scoped widgets

`lib/core/` is strictly for cross-cutting concerns: config, constants, DI, error types, router, themes, utils, and globally shared "dumb" UI widgets. No feature-specific logic belongs here.

### Key files

| File | Purpose |
|------|---------|
| `lib/main.dart` | Entry point — loads `.env`, initializes Hive, runs GetIt DI |
| `lib/app.dart` | Root widget, wires themes and GoRouter |
| `lib/core/router/app_router.dart` | **Single source of truth for all routes** |
| `lib/core/constants/app_routes.dart` | Route path/name constants (`AppRoutes`) |
| `lib/core/di/dependencies_injection_container.dart` | GetIt registrations (`sl`) |
| `lib/core/middlewares/authentication_middleware.dart` | Global auth guard (token check → redirect) |
| `lib/core/middlewares/roles_middleware.dart` | Role-based route guard (lansia / doctor / caregiver) |
| `lib/core/utils/route_helper.dart` | Helpers: `isPublicRoute()`, `getDashboardRouteByRole()` |

### Routing rules

- All routes are declared in `app_router.dart`. **Never use `Navigator.push`** in UI — always `context.go()` or `context.push()`.
- Auth guard runs globally via GoRouter's top-level `redirect` (`AuthenticationMiddleware.guard`).
- Role guards are applied per `ShellRoute` using `RolesMiddleware.requireRole()`.
- Role-prefixed routes (`/doctor`, `/caregiver`, `/lansia`) redirect to the matching dashboard when accessed directly.
- The `/developer` route (`DevScreen`) is only registered when `AppInfo.isDevelopment` is true.

### State management

- Use `flutter_bloc` for all business logic, API calls, and global state.
- `setState` is only acceptable for localized, temporary UI animations/toggles.
- All BLoC States and Events **must** be generated with `freezed` (immutable).
- Data flow: Hive (local) → show UI → silently sync with Dio API in background.

### Dependency injection

GetIt is the service locator (`sl`). Register dependencies in `dependencies_injection_container.dart`. The singleton `sl` is exported from that file and used throughout the app.

### Data modeling

- API response models go in `features/[name]/data/models/` and **must** use `freezed` + `json_serializable`. Do not write manual `fromJson`/`toJson`.
- Domain entities go in `features/[name]/domain/entities/` — pure Dart objects with no external dependencies.
- After adding or modifying any `@freezed` class, run `build_runner` to regenerate `.g.dart`/`.freezed.dart` files.

### Global UI components (`lib/core/widgets/`)

Predefined accessible components for the elderly target audience:

| Widget | Location |
|--------|---------|
| `AppButton` | `buttons/app_button.dart` |
| `AppInputField` | `inputs/app_input_field.dart` |
| `AppOtpField` | `inputs/app_otp_field.dart` |
| `AppSelectField` | `inputs/app_select_field.dart` |
| `AppFormField` | `forms/app_form_field.dart` |
| `AppCard` | `cards/app_card.dart` |
| `AppCalendar` | `calendars/app_calendar.dart` |
| `AppSwitch` | `switches/app_switch.dart` |
| `AppTabs` | `tabs/app_tabs.dart` |
| `AppTable` | `tables/app_table.dart` |
| `AppAccordion` | `accordions/app_accordion.dart` |
| `AppBadge` | `badges/app_badge.dart` |
| `AppAlert` | `alerts/app_alert.dart` |
| `AppBreadcumb` | `breadcumbs/app_breadcumb.dart` |
| `AppDropdownMenu` | `dropdowns/app_dropdown_menu.dart` |
| `AppSlider` | `sliders/app_slider.dart` |

Feature-specific widgets belong in `features/[name]/presentation/widgets/`.

### Constants

- Colors: `lib/core/constants/app_colors.dart` (WCAG AAA contrast required)
- Typography: `lib/core/constants/app_typography.dart`
- Assets: `lib/core/constants/app_assets.dart`
- API endpoints: `lib/core/constants/api_endpoints.dart`
- Environment keys: `lib/core/constants/app_env_keys.dart`

**Never hardcode colors, paddings, or API URLs directly in the widget tree.**

### Accessibility (mandatory)

The target users are elderly. Every UI component must:
- Wrap interactive elements in `Semantics` for screen readers
- Use minimum `48×48` tap targets
- Use high-contrast colors from `app_colors.dart`
- Avoid complex gestures (no double-tap, no complex swipes)

### Type safety

- `dynamic` is not allowed — use explicit types everywhere.
- Use `const` constructors for widgets wherever possible.
- Errors are returned as typed `Failure` objects (see `lib/core/error/failures.dart`), not raw exceptions.

### Offline-first sync flow

1. BLoC loads data from Hive (local) and emits to UI immediately.
2. `internet_connection_checker` monitors connectivity.
3. On reconnect, background sync pushes locally cached data (XP, session results) to the API via Dio.
