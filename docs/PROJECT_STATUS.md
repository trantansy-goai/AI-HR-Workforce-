# GOAI Mobile App - Project Status (Phase 1)

Date: 2026-10-07
Target Completion: October 8 (Feature Complete) | October 9 (Release/Demo Ready)
Baseline: flutter_project_base v1.0.0
Source of Truth: https://go-ai-hr-phase1-ui.trantansy.chatgpt.site/

---

## Approved Information Architecture (Phase 1 Freeze)

The top-level navigation structure is organized into exactly 5 persistent bottom destinations using `StatefulShellRoute.indexedStack`, superseding previous draft layouts:

1. **Trang chủ (Tab 1 — Default Landing Tab)**:
   - Workspace Dashboard (`/home/trang-chu`, backwards-compatible alias `/home/timeline`).
   - Employee greeting (`Xin chào, {name}`), enterprise workspace identity, notification bell, compact real-time token quota status.
   - Pending work overview & action shortcuts (Onboarding Checklist, My Work, Courses, Case Requests).
   - Recent internal news section ("Bản tin mới" via `newsListProvider`) with direct navigation to article details (`/home/news/:id`) and full list (`/home/news`).
2. **Hỏi HR (Tab 2)**:
   - Ask HR & Enterprise AI discovery root (`/home/ask-hr`, backwards-compatible alias `/home/chat`).
   - Question prompt input card and topic chips (Bảo hiểm, Nghỉ phép, Thuế & Lương, Quy chế).
   - Enterprise AI & HR agents catalog (HR Policy Assistant, Mock Assistant, Legal Assistant) with conversation count and status badges.
   - Agent conversation history (`/home/chat/agent/:agentId`), new thread creation, and conversation detail (`/home/chat/:id`).
   - Answers support source/citation presentation linking to referenced documents.
   - "Khác / Human chat" placeholder marked `BLOCKED` awaiting future backend WebSocket/messaging contracts.
3. **Việc của tôi (Tab 3)**:
   - Employee work workspace (`/home/my-work`).
   - Onboarding checklist (A3) with progress indicator, action items, and due dates.
   - Case / Request tracking (A0/A4) with multi-step progress indicators.
   - Permission-aware Human Approval inbox (M11) visible when user role/permission allows (`hasApprovalPermissionProvider`).
4. **Học tập (Tab 4)**:
   - Unified learning hub (`/home/learning`).
   - Courses & Training (`LearningRepository`).
   - Online Tests & Assessments (`OnlineTestRepository`), test taking (`/home/tests/:id/take`) with focused AppBar.
   - Online Test remains a feature/module in code, not a standalone bottom tab.
5. **Tài khoản (Tab 5)**:
   - Employee account and profile workspace (`/home/account`, backwards-compatible alias `/home/profile`).
   - Authenticated user profile identity (avatar, name, email, role badge).
   - "Bản tin nội bộ" navigation link leading to full internal news list (`/home/news`).
   - Entry points to Settings (`/home/settings`) and Sign out.

### Header & Secondary Access Points:
- **Shared Workspace Header**: Shared across all 5 main root tabs; features employee greeting (`Xin chào, {name}`), enterprise workspace subtitle, notification bell button, and compact token quota bar. Detail screens use standard AppBars.
- **Quota in Header**: Real-time token usage display (loading, available, warning >=80%, exceeded >=100%, unavailable) using `userQuotaProvider`. Quota backend remains authoritative.
- **Notification Access**: Notification bell icon in the shared header navigates to Notification Center (`/home/notifications`), supporting deep links to Approvals, Learning, and News. Not a bottom tab.
- **Bản tin / News Access**: Full news list accessible via Trang chủ shortcut and Tài khoản menu (`/home/news` and `/home/news/:id`). Not a bottom tab.
- **Documents Access**: Knowledge documents accessible via Hỏi HR citations, workspace shortcuts, and deep links (`/home/documents` and `/home/documents/:id`). Not a bottom tab.
- **Approval Access**: Secondary access via Việc của tôi and Notification deep links (`/home/approvals`), gated by role/permissions. Not a bottom tab.

---

## Module Status Overview (Implementation vs. Live Integration)

| Module | Implementation Status | Live Integration Status | Integrated Component | Notes / Pending Work |
| :--- | :--- | :--- | :--- | :--- |
| **Auth (Business)** | IMPLEMENTED | BLOCKED | AuthController, AuthSessionStorage | Domain + Fake DataSource complete; awaiting /api/v1/auth/login |
| **Session** | REAL | REAL | SecureStore, 401 refresh queue | Production-ready token lifecycle & HTTP refresh interceptor |
| **RBAC / User Roles** | IMPLEMENTED | BLOCKED | AppRoutes.access, HomePage | Server-driven UI gating ready; awaiting backend permissions array |
| **Open WebUI Client** | REAL | BLOCKED | OpenWebUiClient | Client & SSE parser complete; awaiting live server host & key |
| **Agent Catalog** | IMPLEMENTED | PARTIAL | AgentRepository, ModelRepositoryImpl | GET /api/models wired; enterprise agent mapping pending |
| **AI Chat** | REAL | BLOCKED | OpenWebUiChatProvider, ChatRepositoryImpl | Streaming, retry, cancel, citations wired; awaiting live endpoint |
| **SSE Streaming** | REAL | BLOCKED | OpenWebUiSseParser | Parses text deltas, citations, [DONE], malformed JSON, server errors |
| **Voice Recording** | IMPLEMENTED | VERIFIED_ON_PHYSICAL_DEVICE | NativeVoiceRecorder, FakeVoiceRecorder | Native recorder (record) verified on Samsung SM-X510 (Android 16). STT is BLOCKED |
| **Documents** | IMPLEMENTED | BLOCKED | DocumentRepository, UI | Domain, fake repo, list/detail/download UI ready; secondary feature |
| **File Picker** | IMPLEMENTED | VERIFIED_ON_PHYSICAL_DEVICE | NativeFilePicker, DefaultFilePickerService | Native file picker (file_picker) verified on Samsung SM-X510 (Android 16) |
| **Remote Upload** | IMPLEMENTED | BLOCKED | FileUploader, FakeFileUploader | Upload abstraction ready; backend multipart upload API is BLOCKED |
| **E-learning** | IMPLEMENTED | BLOCKED | LearningRepository, UI | Domain, fake repo, course list/content UI ready; under Học tập tab |
| **Online Test** | IMPLEMENTED | BLOCKED | OnlineTestRepository, UI | Domain, fake repo, test/question/result UI ready; under Học tập tab |
| **News / Bản tin** | IMPLEMENTED | BLOCKED | NewsRepository, UI | Domain, fake repo; accessed via Trang chủ & Tài khoản |
| **Token Usage** | IMPLEMENTED | BLOCKED | QuotaRepository, UI | Displayed in SharedWorkspaceHeader; awaiting live API |
| **Việc của tôi** | IMPLEMENTED | BLOCKED | FakeMyWorkRepository, MyWorkPage | Onboarding checklist, case tracker, approval entry; awaiting live API |
| **Human Approval** | IMPLEMENTED | BLOCKED | ApprovalRepository, UI | Secondary permission-gated access via Việc của tôi & Notifications |

---

## Status Legend

- IMPLEMENTED: Production Domain, Native Adapter, Controller, and UI presentation fully coded and unit/widget tested.
- REAL: Production-grade infrastructure code implemented with no mock fallbacks.
- VERIFIED_ON_PHYSICAL_DEVICE: Native production adapter implemented and verified on physical hardware.
- PARTIAL: Client adapter or UI ready; backend route mapping pending live verification.
- BLOCKED: Live endpoint URL, API key, or backend API contract required from client.

---

## Quality Gates Status

- `dart format lib test`: PASS (Clean format)
- `flutter analyze`: PASS (0 issues found!)
- `flutter test`: PASS (130/130 tests passing)
- `flutter build apk --debug`: PASS (`app-debug.apk` built with native record and file_picker plugins)
- Physical Device Baseline: Samsung SM-X510 (Galaxy Tab S9 FE, Android 16); smoke test suite green, all 5 tabs and secondary flows verified without overflows.