# REPORT — GOAI Mobile

Date: 2026-10-08

---

## 1. Summary

GOAI Mobile is the GO AI Workforce employee app (Flutter, Android + iOS).

- Phase 1 workspace UI (5 tabs) built from the approved mockup — §3.
- Staging/production connected to Open WebUI (`https://workforce.ai-iep.vn`):
  sign-in, session check, sign-out, agent list, streamed chat with
  citations, file upload for RAG — all verified live on 2026-10-08
  ([OPENWEBUI_API_MAPPING.md](OPENWEBUI_API_MAPPING.md)).
- Development config runs fully offline on fakes.
- CI/CD: every PR into `main` runs the quality gates and ships a staging APK
  to Firebase App Distribution ([CI_CD.md](CI_CD.md)).
- App id `com.goaiapp.goai` (Android staging: `com.goaiapp.goai.staging`); package `goai_mobile`.
- Quality: `flutter analyze` clean, **219 tests passing**.

Detailed per-module status: [PROJECT_STATUS.md](PROJECT_STATUS.md).

## 2. Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md) for details.

```
lib/app        composition root (bootstrap, App, router, splash/404)
lib/core       infrastructure, never imports features
lib/shared     reusable widgets/models/utils
lib/features/  auth, chat, file, home, my_work, approval, elearning, online_test,
               news, document, quota, notification, voice, profile, settings
               each: domain / data / application / presentation (as needed)
```

Key decisions:
- **Riverpod 3 without codegen** for state + DI (one tool, overridable,
  testable, no build_runner).
- **Dependency inversion at core boundaries**: `AccessTokenSource` (core) is
  implemented by auth and wired in bootstrap; routing uses core
  `SessionStatus`.
- **`Result<T>` + sealed `AppFailure`**; `ErrorMapper` is the only place
  aware of library exceptions.
- **Two Dio clients** (public / authenticated) to avoid refresh recursion;
  queued auth interceptor refreshes once on 401.
- **Route access as data** (`AppRoutes.access`) + pure `RouteGuard`.
- **Chat = events + repository**: providers only translate transport ⇄
  `ChatEvent`; the repository owns optimistic send, retry, streaming,
  pagination, typing, uploads; UI reads the cache.
- **Typed message metadata** (`MessageExtension`) instead of a dynamic map.
- **No database bundled**; `ChatCache` / repositories are the seams.

## 3. Phase 1 Approved Workspace Navigation & Information Architecture

Reference UI Mockup: https://go-ai-hr-phase1-ui.trantansy.chatgpt.site/

- **5 Persistent Root Destinations (`StatefulShellRoute.indexedStack`)**:
  1. Trang chủ (`/home/trang-chu`, alias `/home/timeline`) — Workspace dashboard: greeting, identity, token quota status, pending items strip, shortcuts, upcoming work/courses/cases cards, and internal news list ("Bản tin mới").
  2. Hỏi HR (`/home/ask-hr`, alias `/home/chat`) — Ask HR & AI discovery root: search card, topic chips, AI agents catalog, conversation history per agent, source/citation references to documents, and BLOCKED human chat placeholder.
  3. Việc của tôi (`/home/my-work`) — Employee workspace: Onboarding checklist (A3), Case / request tracking (A0/A4), and permission-aware Human Approval inbox (M11).
  4. Học tập (`/home/learning`) — Unified learning hub for Courses & Training and Certification Tests.
  5. Tài khoản (`/home/account`, alias `/home/profile`) — Employee identity, "Bản tin nội bộ" link, Settings, Sign out.
- **Shared Workspace Header**: Displayed across all 5 root tabs (employee greeting `Xin chào, {name}`, enterprise subtitle, notification icon, token quota usage bar).
- **Secondary Access**:
  - Notifications (`/home/notifications`): accessed from the header bell icon; deep links to Approvals, Learning, and News.
  - Bản tin (`/home/news`): accessed via Trang chủ and Tài khoản.
  - Documents (`/home/documents`): accessed via Hỏi HR citations and workspace shortcuts.
  - Approvals (`/home/approvals`): permission-gated access via Việc của tôi and Notifications.
- **Verification**: 130 tests green, 0 analysis issues, debug APK compiles cleanly, physical Samsung SM-X510 (Android 16) smoke verified with 0 layout overflows.

## 4. Known issues

1. `HR Chief Manager` is listed by `/api/models` but chat returns
   `400 Model not found` (server model config).
2. Hỏi HR uses agent `employee_service`; to be confirmed by the business.
3. Image/voice attachments use the same upload pipeline; only text files were
   verified live.
4. Chat history lives in Open WebUI (`/api/v1/chats/*`), shared with the
   website (verified on SM-X510, 2026-10-09). The app lists the newest 60
   chats only, and new chats are titled with the first question (the website
   asks a model for a title).
5. Backend (2026-10-09): no new APIs — use Open WebUI's own APIs or embed
   the website ([BACKEND_INTEGRATION_TODO.md](BACKEND_INTEGRATION_TODO.md)).
   Token quota (usage vs. `TOKEN_QUOTA_LIMIT` = 200,000), Tài liệu (knowledge) and Bản tin (shared
   notes) now use Open WebUI; Tài liệu and Bản tin are empty for `hr@` until
   an admin shares knowledge/notes with employees. Việc, Học tập, Bài kiểm
   tra and Phê duyệt still use fake data: Open WebUI has no API for them and
   the website is Open WebUI itself. Feature-by-feature coverage:
   [OPENWEBUI_API_MAPPING.md](OPENWEBUI_API_MAPPING.md) §8.
6. HR vs employee layouts (Hỏi HR, Việc) follow Open WebUI groups:
   `EMPLOYEE_GROUPS` = `Knowledge-IT`: `knowledge@` gets the employee
   layouts, every other test account the HR ones. Việc HR blocks are still
   fake data.
7. Android staging builds use `com.goaiapp.goai.staging` (from `APP_ENV`);
   iOS still has one bundle id for all environments.
8. iOS distribution is not set up (needs Apple signing assets).

## 5. Next steps

- Backend: fix `HR Chief Manager`.
- Admin: share knowledge bases and news notes with the employees' group.
- Việc, Học tập, Bài kiểm tra, Phê duyệt: WebView once the backend names
  the website pages and how they authenticate.
- Firebase: configure App Distribution secrets so PR builds reach QA.
- iOS: Ad Hoc signing + App Distribution job.
- Chat list paging beyond 60 chats; offline cache of server chats.
