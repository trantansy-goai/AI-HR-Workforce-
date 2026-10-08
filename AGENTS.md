# AGENTS.md — Instructions for AI coding agents (and humans)

This repository is **GOAI Mobile**, the GO AI Workforce employee app
(Flutter, Android + iOS). It talks to Open WebUI for auth, AI agents, chat
and files (`docs/OPENWEBUI_API_MAPPING.md`).

> **Golden rule: `lib/core` and the generic domains (chat, file, auth) stay
> product-neutral. GO AI–specific screens, API shapes and wording live in the
> feature's `data/` and `presentation/` layers.**

A vendor- or backend-specific detail (an endpoint, a model id, a response
shape) belongs in a data source or provider implementation, never in core
or domain entities. Add an extension point instead of special-casing.

## Before you start

1. Read `README.md`, `docs/ARCHITECTURE.md` and, for chat work,
   `docs/CHAT_MODULE.md`.
2. Check `docs/REPORT.md` for current status and known issues.
3. Follow the checklists in `docs/ADDING_FEATURE.md`.

## Architecture rules

- **Feature-first + Clean Architecture.** Each feature lives in
  `lib/features/<name>/` with `domain/`, `data/`, `application/`,
  `presentation/` — create only the folders you need.
- **Dependency direction** (never reverse it):

  ```
  presentation → application → domain ← data
  features → core, shared
  core → (nothing in features)        shared → core only
  app/ (composition root) → everything
  ```

  - `domain/` is pure Dart: no Flutter widgets, no Dio, no Riverpod, no
    platform plugins. (Small exceptions already present: `ThemeMode`/`Locale`
    in settings domain.)
  - `core/` must **never import from `features/`**. When core needs something
    a feature owns (e.g. the access token), define an interface in core and
    let the feature implement it; wire it in `app/bootstrap`
    (see `AccessTokenSource`).
  - Features should not import other features' `data/` layers. Depending on
    another feature's `domain/` or `application/` providers is acceptable
    (e.g. chat reads the current user from auth).
- **State management and DI: Riverpod only** (`flutter_riverpod`, no code
  generation). Do not add Bloc, Provider, GetX, get_it, MobX, etc.
  - Infrastructure: `Provider`. Feature state: `Notifier` / `AsyncNotifier`.
  - Swap implementations by overriding providers, not by `if` branches in UI.
- **Errors:** data sources throw `AppFailure`; repositories return
  `Result<T>` (use `guard()`); UI turns failures into text with
  `failure.localizedMessage(l10n)`. Never surface `DioException`,
  `PlatformException` etc. above `data/`.
- **Navigation:** add paths to `AppRoutes`, access rules to
  `AppRoutes.access`, routes in `app/router/app_router.dart`. Do not navigate
  after sign-in/out manually — the guard reacts to auth state.
- Don't create abstractions without a real second implementation or test
  seam. Don't create empty folders "for architecture".

## Chat module rules

- The chat domain is **generic**. It must keep working for user↔user,
  user↔support agent, user↔bot, user↔remote AI, user↔local AI and RAG.
- Never add AI-vendor concepts (OpenAI/Anthropic/Gemini types, model names,
  API keys) to `Message`, `Conversation`, `Participant`, `ChatRepository` or
  the UI. AI-specific data goes in typed `MessageExtension`s
  (`domain/extensions/`) or behind `TextGenerationEngine`.
- New transports = new `ChatProvider` implementation. The repository, state
  and widgets must not need changes.
- `MessageMetadata` holds typed extensions only; do not add a free-form
  `Map<String, dynamic>` to messages.

## Coding conventions

- Files `snake_case.dart`; types `UpperCamelCase`; providers end with
  `Provider` (`chatRepositoryProvider`); controllers end with `Controller`.
- Interfaces are `abstract interface class`; fakes/in-memory implementations
  are named `Fake…`, `InMemory…`, `Mock…` or `Noop…`.
- Relative imports inside `lib/` (lint-enforced); package imports in `test/`.
- Single quotes, `final` locals, trailing commas; run `dart format`.
- All user-visible strings go through ARB files (`context.l10n`). Add keys to
  **both** `app_en.arb` and `app_vi.arb`.
- Use design tokens (`AppSpacing`, `AppRadius`) and shared widgets
  (`AppButton`, `AppTextField`, `LoadingView`, `EmptyView`, `ErrorView`,
  `showAppSnackBar`, `showConfirmDialog`) instead of ad-hoc styling.
- No hardcoded screen sizes; use `ResponsiveCenter`, `context.windowSize`.

## Security rules

- **Never commit secrets**: `.env`, API keys, tokens, keystores,
  `key.properties`, `google-services.json`, credentials, personal paths.
  `.gitignore` covers the common cases — check `git diff --cached` anyway.
- Compile-time config (`config/*.json`) is **not** secret. LLM/payment keys
  live on a backend, never in the app.
- Tokens only in `SecureStore`. Never in `KeyValueStore`, logs or URLs.
- Never log passwords, tokens or personal data. Network logging goes through
  `Redactor`; add new sensitive keys there.

## Testing requirements

- Every new repository/controller/provider with logic gets unit tests.
- Every new reusable widget gets a widget test.
- Use `test/helpers/test_helpers.dart` (`createTestContainer`,
  `baseTestOverrides`, `testApp`) — in-memory stores, zero-latency fakes.
- Keep `test/app_smoke_test.dart` green; extend it for new top-level flows.
- Test behavior, not implementation details. No coverage padding.

## Quality gates (run before every commit)

```bash
flutter pub get
dart format lib test
flutter analyze            # must report: No issues found!
flutter test               # all green
flutter build apk --debug --dart-define-from-file=config/development.json
```

Then audit the diff: `git status`, `git diff`, `git diff --cached` — look for
secrets, absolute local paths, build outputs.

## Git

- Small, logical commits with conventional prefixes (`feat:`, `fix:`,
  `test:`, `docs:`, `chore:`, `refactor:`).
- Never force push or rewrite shared history.
- Update `docs/REPORT.md` when module status changes.
