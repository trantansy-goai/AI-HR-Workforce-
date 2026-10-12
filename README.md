# GOAI Mobile

Mobile app for **GO AI Workforce** (Android + iOS, Flutter): employees sign in,
ask HR and the GO AI agents (streamed answers with source citations, file
attachments), and use the workspace tabs — Trang chủ, Hỏi HR, Việc của tôi,
Học tập, Tài khoản.

| Area | What's included |
| --- | --- |
| Backend | Open WebUI: JWT sign-in, session check, agent list (`/api/models`), streamed chat, file upload for RAG — see [docs/OPENWEBUI_API_MAPPING.md](docs/OPENWEBUI_API_MAPPING.md) |
| Architecture | Feature-first Clean Architecture, Riverpod for state + DI |
| Environments | development (offline fakes) / staging / production via `--dart-define-from-file` |
| Networking | Dio client, bearer-token injection, 401 → sign-out, error normalization, redacted logging |
| Errors | Sealed `AppFailure` hierarchy + `Result<T>`; UI never sees library exceptions |
| Storage | `KeyValueStore` (preferences) and `SecureStore` (tokens) |
| Navigation | go_router, auth guard, 5-tab workspace shell, deep links, 404 page |
| Localization | ARB-based, Vietnamese + English |
| Chat | Conversations per agent, streaming, stop/regenerate, retry, citations, attachments, voice notes |
| CI/CD | Every PR into `main` → checks + staging APK on Firebase App Distribution ([docs/CI_CD.md](docs/CI_CD.md)) |
| Tests | 219 unit, widget and app smoke tests |

> Module status is tracked in [docs/PROJECT_STATUS.md](docs/PROJECT_STATUS.md)
> and [docs/REPORT.md](docs/REPORT.md).

---

## Requirements

- Flutter **3.47+** (stable), Dart **3.13+** — see `environment` in `pubspec.yaml`
- Android SDK (for Android builds), Xcode on macOS (for iOS builds)

## Quick start

```bash
flutter pub get
flutter run --dart-define-from-file=config/development.json
```

The development config uses an **in-process fake backend**
(`USE_FAKE_BACKEND=true`), so the app runs with no server and shows demo data.
Staging/production use the real Open WebUI server and sign in with email +
password (test accounts come from the backend team; never commit them).

## Environments

Configuration is compile-time (`--dart-define`), read by
[`AppConfig.fromEnvironment`](lib/core/config/app_config.dart).

| File | Purpose |
| --- | --- |
| `config/development.json` | Local development, fake backend, network logs on |
| `config/staging.json` | Staging API URL |
| `config/production.json` | Production; network logs are forced off in code |

```bash
flutter run   --dart-define-from-file=config/staging.json
flutter build apk --release --dart-define-from-file=config/production.json
```

Keys: `APP_ENV`, `APP_NAME`, `API_BASE_URL`, `USE_FAKE_BACKEND`,
`ENABLE_NETWORK_LOGS`, `LOG_NETWORK_BODIES`, `CONNECT_TIMEOUT_MS`,
`RECEIVE_TIMEOUT_MS`, `TOKEN_QUOTA_LIMIT` (tokens per user per 30 days, shown
against Open WebUI usage; default 200000), `EMPLOYEE_GROUPS` (comma-separated
Open WebUI group names of plain employees; members of any other group, and
admins, get the HR layouts of Hỏi HR and Việc).

**Secrets:** nothing compiled into an app is secret. Do not put API keys for
paid services (LLM vendors, payment providers) in these files — call them
through your backend. For per-developer overrides create
`config/<env>.local.json` (git-ignored).

Staging and production talk to Open WebUI (`OPEN_WEBUI_BASE_URL`,
`USE_FAKE_BACKEND=false`); see `docs/OPENWEBUI_API_MAPPING.md`.

Running without any `--dart-define` uses development defaults.

## Test, analyze, format, build

```bash
flutter analyze
flutter test
dart format lib test
flutter build apk --debug --dart-define-from-file=config/development.json
```

## Project structure

```
lib/
├── main.dart                 # entry → bootstrap()
├── app/                      # composition root: App widget, bootstrap, router, splash/404
│   ├── bootstrap/
│   └── router/               # routes, guard wiring
├── core/                     # feature-agnostic infrastructure
│   ├── auth/                 # AccessTokenSource, SessionStatus (contracts only)
│   ├── config/               # AppConfig, AppEnvironment
│   ├── di/                   # core Riverpod providers
│   ├── error/                # AppFailure, Result, ErrorMapper, localized messages
│   ├── localization/         # ARB files + generated AppLocalizations
│   ├── logging/              # AppLogger, Redactor
│   ├── navigation/           # RouteAccess + RouteGuard (pure logic)
│   ├── network/              # ApiClient, DioFactory, interceptors
│   ├── storage/              # KeyValueStore, SecureStore
│   └── theme/                # AppTheme, spacing/radius/breakpoint tokens
├── shared/                   # reusable widgets, models, utils (no business logic)
└── features/
    ├── auth/                 # Open WebUI sign-in, session (domain / data / application / presentation)
    ├── chat/                 # chat engine + Open WebUI provider (see docs/CHAT_MODULE.md)
    ├── file/                 # attachments, MIME, Open WebUI uploader, pickers
    ├── home/                 # workspace shell + Trang chủ
    ├── my_work/, approval/   # Việc của tôi, approvals
    ├── elearning/, online_test/  # Học tập
    ├── news/, document/, quota/, notification/, voice/
    ├── profile/
    └── settings/
```

Each feature follows `domain → data → application → presentation`; folders are
only created when they contain something.

## Documentation

- [AGENTS.md](AGENTS.md) — rules for humans and AI agents working on this repo
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — layers, dependency rules, DI, networking, routing, errors
- [docs/CHAT_MODULE.md](docs/CHAT_MODULE.md) — chat engine and providers (realtime, remote AI, local AI, RAG)
- [docs/ADDING_FEATURE.md](docs/ADDING_FEATURE.md) — checklists to add features, APIs, screens, routes, tests
- [docs/REPORT.md](docs/REPORT.md) — current status, decisions, known issues, review guide
- [docs/CI_CD.md](docs/CI_CD.md) — PR builds to Firebase App Distribution (setup, secrets, QA flow)

## Adding a language

1. Copy `lib/core/localization/arb/app_en.arb` to `app_<code>.arb` and
   translate the values (keep keys and placeholders).
2. Run `flutter gen-l10n` (also runs automatically on `flutter run`/`build`).
   Generated files in `lib/core/localization/generated/` are committed.
3. Add the language name to `SettingsPage._languageName`.
4. For iOS, add the locale to `CFBundleLocalizations` in `ios/Runner/Info.plist` (en and vi are already listed).
