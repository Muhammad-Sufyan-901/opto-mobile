# AI Agent Instruction Context

## Project Overview

- **Name:** IDS Elder Rehab App (Digital Physical Rehabilitation)
- **Architecture:** Feature-First Clean Architecture
- **Language:** Dart (Strict Null Safety)
- **Framework:** Flutter (Mobile/Tablet)

## Tech Stack

- **State Management:** Flutter BLoC (`flutter_bloc`)
- **Routing:** GoRouter (Declarative, URL-based routing)
- **Dependency Injection:** GetIt (`get_it`)
- **HTTP Client:** Dio
- **Local Storage / Offline Sync:** Hive (`hive_flutter`)
- **Data Modeling:** Freezed & JSON Serializable (`freezed`, `json_serializable`)
- **AI & AR (Core Features):** Google ML Kit Pose Detection (Offline AI), Model Viewer Plus (AR 3D)

## Strict Architecture Rules & Best Practices

### 1. Feature-Based Isolation & Clean Architecture

- NEVER place domain-specific logic, pages, or complex UI in `lib/core/`.
- `lib/core/` is strictly reserved for global configurations, themes, network clients, and globally shared "dumb" UI widgets.
- Group everything by business domain inside `lib/features/[feature-name]/` (e.g., `auth`, `ar_treatment`).
- **Clean Architecture Layers:** Every feature folder MUST be subdivided into `data`, `domain`, and `presentation` layers. Never skip layers. UI (`presentation`) can only communicate with `domain` (UseCases), never directly with `data`.

### 2. STRICT Routing & Middleware Enforcement (GoRouter)

- **CENTRALIZED ROUTING:** All routes MUST be defined inside `lib/core/router/app_router.dart`. Do not define standalone navigations (e.g., `Navigator.push`) inside UI components. Always use `context.go()` or `context.push()`.
- **ROUTE GUARDS (MIDDLEWARE):** Do not write inline authentication logic inside the UI screens. All route protection (e.g., checking if the user is logged in, or if the user is a Doctor vs. Elder) MUST be handled inside the `redirect` callback of GoRouter.
- **Example of CORRECT routing guard:**

```dart
  redirect: (BuildContext context, GoRouterState state) {
    final isAuthenticated = GetIt.I<AuthBloc>().state is AuthAuthenticated;
    final isLoginRoute = state.matchedLocation == '/login';

    if (!isAuthenticated && !isLoginRoute) return '/login';
    if (isAuthenticated && isLoginRoute) return '/home';
    return null;
  }

```

### 3. STRICT State Management Rules (BLoC & Offline-First)

- **UI State & Business Logic:** MUST use `flutter_bloc`. Never use standard `setState` for complex business logic, API calls, or global states. `setState` is strictly for localized, temporary UI animations/toggles.
- **Immutable States:** All BLoC States and Events MUST be generated using `freezed` to ensure immutability.
- **Offline-First Data Handling:** Use `hive_flutter` for local storage. When fetching data, the BLoC should ideally load from Hive first, show to the UI, then silently sync with the Dio API in the background.

### 4. STRICT API & Data Layer

- **Location:** `lib/features/[feature-name]/data/` and `lib/features/[feature-name]/domain/`.
- **Pattern:** - `RemoteDataSource`: Handles Dio HTTP calls.
- `LocalDataSource`: Handles Hive offline storage.
- `RepositoryImpl`: Implements the Domain repository, decides whether to fetch from local or remote based on network status.
- `UseCase`: A class with a single `call()` method executing one specific business action.

### 5. STRICT Form Handling & Typing

- **Models & Serialization:** All data models coming from APIs MUST be parsed using `json_serializable` and `freezed`. DO NOT write manual `fromJson` or `toJson` methods.
- **Form Validation:** Use standard Flutter `Form` and `TextFormField` combined with `GlobalKey<FormState>`.
- **Validation Logic:** Extract validation logic (e.g., password strength, email format) into reusable mixins or utility classes inside `lib/core/utils/validators.dart`. Do not write complex regex inline inside the UI.

### 6. STRICT Component Hierarchy & Accessibility (A11y)

- **`lib/core/widgets/`**: Common, globally used UI components (e.g., `PrimaryButton`, `CustomTextField`).
- **`lib/features/.../presentation/widgets/`**: Feature-specific UI components.
- **`lib/features/.../presentation/pages/`**: Smart components (Screens) that wrap UI with `BlocBuilder` or `BlocProvider`.
- **ACCESSIBILITY IS MANDATORY:** Because the target audience is the elderly, you MUST:
- Use `Semantics` widgets for screen readers.
- Ensure large tap targets (minimum `48x48`).
- Use high contrast colors from `lib/core/theme/app_colors.dart`.
- Avoid complex gestures (no double-taps or complex swipes). Rely on simple, large tap buttons.

### 7. TypeScript to Dart Equivalents & Best Practices

- NO `dynamic` types allowed. Use explicit types for everything.
- Use `const` constructors for Widgets wherever possible to optimize performance and prevent unnecessary rebuilds.
- Handle all failures using a functional error handling approach (e.g., returning `Either<Failure, T>` using the `fpdart` or `dartz` package, or custom Result classes).

### 8. STRICT Constants & Configuration

- **Assets (`assets/`):** Located in the project root. Separated into `images/`, `sounds/`, and `models/` (for AR .glb files).
- **Config & Constants (`lib/core/constants/`):** For hardcoded, immutable values.
- `api_endpoints.dart`: All API URLs.
- `app_colors.dart` & `app_sizes.dart`: Centralized design system.
- Do NOT hardcode colors or paddings directly in the widget tree.

## Base Features Included

- **Authentication Module:** Multi-role login (Elder, Doctor, Caregiver).
- **AR Treatment Module:** 3D Instructor viewer using `model_viewer_plus`.
- **AI Movement Tracker Module:** Offline real-time pose estimation using ML Kit to count reps.
- **Gamification & Schedule:** XP, Badges, and adaptive local notifications.

## Directory Structure

````text
```text
ids_elder_rehab_app/
├── assets/                             # Static physical files
│   ├── images/
│   ├── models/                         # AR 3D Models (.glb)
│   └── sounds/                         # Gamification SFX & Voice Guides
├── lib/
│   ├── core/                           # ⚙️ GLOBAL CORE (Shared everywhere)
│   │   ├── config/                     # api_client.dart (Dio config & interceptors)
│   │   ├── constants/                  # app_colors.dart, app_sizes.dart, api_endpoints.dart
│   │   ├── di/                         # injection_container.dart (GetIt setup)
│   │   ├── error/                      # failures.dart, exceptions.dart
│   │   ├── middlewares/                # auth_middleware.dart, role_guard.dart
│   │   ├── router/                     # app_router.dart (GoRouter Registry & Guards)
│   │   ├── themes/                     # app_theme.dart (High contrast, A11y focus)
│   │   ├── utils/                      # angle_calculator.dart, date_formatter.dart
│   │   └── widgets/                    # 🧱 Global Reusable UI (PrimaryButton, CustomDialog)
│   │
│   ├── features/                       # 📦 MAIN FEATURE MODULES (Clean Architecture)
│   │   │
│   │   ├── auth/                       # Authentication & Role Selection
│   │   │   └── data/                   # Datasources, Models, Repository Impl
|   |   |       ├── models/             # Models
│   │   |       ├── repositories/       # Repository Impl
│   │   |       └── usecases/           # UseCases
│   │   │   ├── domain/                 # Entities, Repository Interface, UseCases
|   |   |       ├── entities/           # Entities
│   │   |       ├── repositories/       # Repository Interface
│   │   |       └── usecases/           # UseCases
│   │   │   └── presentation/           # Screens, Widgets, BLoC
│   |   |       ├── screens/            # Screens
│   |   |       ├── widgets/            # Widgets
│   |   |       └── bloc/               # BLoC
│   │   │
│   │   ├── ar_treatment/               # AR 3D Instruction Module
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/           # ar_viewer_page.dart, ar_instruction_overlay.dart
│   │   │
│   │   ├── ai_movement_tracker/        # AI Camera & Pose Detection (Offline)
│   │   │   ├── domain/                 # detect_pose_usecase.dart, count_reps_usecase.dart
│   │   │   └── presentation/           # smart_camera_page.dart, pose_painter.dart
│   │   │
│   │   ├── rehab_learning/             # 2D Video Micro-learning
│   │   ├── gamification/               # XP, Badges, Leveling System
│   │   ├── schedule_reminder/          # Local adaptive scheduling & notifications
│   │   └── caregiver_feedback/         # Dashboard & monitoring module
│   │
│   └── main.dart                       # App Entry Point & Provider Init
│
├── pubspec.yaml                        # Dependencies (flutter_bloc, dio, hive, get_it, etc.)
├── build.yaml                          # Freezed/Code Generation config
└── gemini.md                           # 🤖 AI Agent Instructions
````
