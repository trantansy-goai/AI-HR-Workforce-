# GOAI Mobile App - Project Status (Phase 1)

Date: 2026-10-06
Target Completion: October 8 (Feature Complete) | October 9 (Release/Demo Ready)
Baseline: flutter_project_base v1.0.0

---

## Approved Information Architecture (Phase 1 Freeze)

The top-level navigation structure is organized into exactly 5 persistent bottom tabs using `StatefulShellRoute.indexedStack`:

1. **Timeline (Tab 1 — Default Landing Tab)**:
   - Primary presentation for internal company posts and news (`newsListProvider`).
   - Supports loading, empty, error states, and article detail navigation.
2. **Chat (Tab 2)**:
   - Discovery root screen categorized into **AI AGENTS** and **OTHER**.
   - **AI AGENTS**: Displays enterprise AI assistants (Mock Assistant, HR Assistant, Legal Assistant). Selecting an agent navigates to that agent's conversation history (`/home/chat/agent/:agentId`), with options to start a new conversation or open existing threads.
   - **OTHER**: Reserved for human-to-human conversations. Marked `BLOCKED` awaiting future backend human chat messaging/WebSocket contracts.
3. **E-learning (Tab 3)**:
   - Unified hub entry point for **Courses & Training** and **Certification Tests**.
   - Online Tests live under E-learning (not as a standalone bottom tab).
4. **Document (Tab 4)**:
   - Knowledge documents root tab (list, detail view, type chips, download action).
5. **My Profile (Tab 5)**:
   - Employee workspace and identity overview (avatar, name, email, role badge).
   - Secondary entry point to **Pending Approvals** (`/home/approvals`).
   - Entry points to Settings and Sign out.

### Header & Secondary Access Points:
- **Shared Main Header**: Shared across all 5 main root tabs; features employee greeting (`Xin chào, {name}`), enterprise workspace subtitle, notification bell button, and compact token quota bar.
- **Quota in Header**: Real-time token usage display (loading, available, warning >=80%, exceeded >=100%, unavailable) using `userQuotaProvider`. Detail screens use standard AppBars to preserve screen real estate.
- **Notification Access**: Notification bell icon in the shared header navigates to Notification Center (`/home/notifications`), supporting deep links to Approvals, Learning, and News.
- **Approval Access**: Kept secondary; accessible via Notification deep links and My Profile (not a bottom tab).

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
| **Documents** | IMPLEMENTED | BLOCKED | DocumentRepository, UI | Domain, fake repo, list/detail/download UI ready; awaiting API |
| **File Picker** | IMPLEMENTED | VERIFIED_ON_PHYSICAL_DEVICE | NativeFilePicker, DefaultFilePickerService | Native file picker (file_picker) verified on Samsung SM-X510 (Android 16) |
| **Remote Upload** | IMPLEMENTED | BLOCKED | FileUploader, FakeFileUploader | Upload abstraction ready; backend multipart upload API is BLOCKED |
| **E-learning** | IMPLEMENTED | BLOCKED | LearningRepository, UI | Domain, fake repo, course list/content UI ready; awaiting API |
| **Online Test** | IMPLEMENTED | BLOCKED | OnlineTestRepository, UI | Domain, fake repo, test/question/result UI ready; lives under E-learning |
| **News / Timeline** | IMPLEMENTED | BLOCKED | NewsRepository, UI | Domain, fake repo, presented through Timeline root tab |
| **Token Usage** | IMPLEMENTED | BLOCKED | QuotaRepository, UI | Displayed in SharedWorkspaceHeader; awaiting live API |
| **Human Approval** | IMPLEMENTED | BLOCKED | ApprovalRepository, UI | Secondary access via Profile & Notification; awaiting API |

---

## Status Legend

- IMPLEMENTED: Production Domain, Native Adapter, Controller, and UI presentation fully coded and unit/widget tested.
- REAL: Production-grade infrastructure code implemented with no mock fallbacks.
- UNVERIFIED_ON_DEVICE: Native production adapter implemented and compiles in APK, pending test on a physical Android/iOS handset.
- PARTIAL: Client adapter or UI ready; backend route mapping pending live verification.
- BLOCKED: Live endpoint URL, API key, or backend API contract required from client.

---

## Quality Gates Status

- `dart format lib test`: PASS (Clean format)
- `flutter analyze`: PASS (0 issues found!)
- `flutter test`: PASS (128/128 tests passing)
- `flutter build apk --debug`: PASS (`app-debug.apk` built with native record and file_picker plugins)
- Physical Device Baseline: Samsung SM-X510 (Android 16); smoke test suite green.