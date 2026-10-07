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
| **Auth (UI/UX)** | IMPLEMENTED | READY | SignInPage, GoAI Branding | Redesigned per approved HR auth mockup (#0E3CAF, #D99F37, GoAI logo) |
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

## Official GoAI Brand & Splash Specification

- **Brand:** GoAI
- **Primary Brand Color:** Deep blue sampled and derived from the "Go" letters in the official logo: `Color(0xFF0E3CAF)` (`#0E3CAF`, RGB 14, 60, 175).
  - Contrast ratio against white: 9.15:1 (exceeds WCAG AAA requirements).
  - Defined centrally in `AppBrandColors.primaryBlue` (`lib/core/theme/app_tokens.dart`) and injected into `AppTheme.seedColor` and `ColorScheme.primary`.
  - Applied to primary buttons, active bottom navigation destinations, links, focus borders, tabs, and brand accents.
- **Secondary Accent:** Warm gold sampled from the "AI" letters in the official logo: `Color(0xFFD99F37)` (`#D99F37`, RGB 217, 159, 55).
  - Defined centrally in `AppBrandColors.secondaryGold`.
  - Used sparingly for badge highlights, quota warning state, and brand accents. Content text remains readable dark neutral / near-black.
- **Splash Screen:** Official GoAI logo on a clean white background (`#FFFFFF`).
  - Responsive centering with `BoxFit.contain` preserving 1:1 original logo aspect ratio without distortion or cropping.
  - Native splash updated on Android (including Android 12+ API 31 `windowSplashScreenAnimatedIcon` with `@drawable/splash_icon` on white `windowSplashScreenBackground`).
  - Seamless visual transition from native launch to Flutter session restoration with 0 white/black flash.

---

## Responsive Phone + Tablet UI Pass

- **Responsive UI:** VERIFIED
- **Phone (< 600dp):** VERIFIED (~360x800, ~390x844)
- **Tablet Portrait (>= 600dp):** VERIFIED (~720x1152 on Samsung Tab S9 FE / ~800x1280)
- **Tablet Landscape (>= 840dp):** VERIFIED (~1152x720 on Samsung Tab S9 FE / ~1280x800)

### Breakpoints & Content Constraints
- `ResponsiveBreakpoints`:
  - `compact`: `< 600dp` (Mobile phone portrait & landscape)
  - `tablet`: `>= 600dp` (Standard tablet portrait)
  - `wideTablet`: `>= 840dp` (Wide tablet landscape / foldable unfolded)
  - `desktop`: `>= 1200dp`
- `ContentConstraints`:
  - `reading`: `760dp` (Reading, forms, settings, notifications)
  - `dashboard`: `1100dp` (Trang chủ dashboard canvas)
  - `chat`: `800dp` (Chat message bubbles and composer max width)
  - `dialog`: `560dp`

### Adaptive Navigation Strategy
- Single unified navigation model with `StatefulShellRoute.indexedStack` preserving all 5 branches (`Trang chủ`, `Hỏi HR`, `Việc của tôi`, `Học tập`, `Tài khoản`).
- Width-driven adaptive rendering via `LayoutBuilder`:
  - `< 600dp`: Material 3 `NavigationBar` at bottom with GoAI primary blue active tint.
  - `>= 600dp`: Side `NavigationRail` with official GoAI splash logo header, preserving full vertical canvas for dashboard.

### Adaptive Screen Compositions
1. **Trang chủ (Dashboard):**
   - Phone: Natural single-column scroll flow (Greeting & quota -> pending tasks -> quick actions -> work/learning cards -> Bản tin mới).
   - Tablet: Adaptive 2-column dashboard layout (Left: Việc sắp đến hạn A3 + Yêu cầu HR A0; Right: Khóa học của tôi A7 + Bài kiểm tra chứng chỉ A4; Bottom: 2-column Bản tin mới cards).
2. **Shared Workspace Header:**
   - Phone: Compact stacked greeting with full-width token quota status bar.
   - Tablet: Horizontal row pairing employee greeting and role on the left with token quota status and notification bell on the right.
3. **Hỏi HR (Enterprise AI Discovery & Chat):**
   - Phone: Single-column discovery root navigating to agent history and conversation.
   - Wide Tablet (`>= 840dp`): Master-detail split layout (Left: Search prompt, chips, and AI Agent catalog; Right: Embedded active conversation or start prompt).
4. **Việc của tôi:**
   - Tablet: 2-column layout (Left: A3 Onboarding checklist; Right: A0/A4 Case tracking and M11 Approvals inbox).
5. **Học tập (Learning Hub):**
   - Courses: 1 column on `< 600dp`, 2 columns on `600–960dp`, 3 columns on `>= 960dp`.
   - Tests: 1 column on `< 600dp`, 2 columns on `>= 600dp`.
6. **Account, News, Notifications & Settings:**
   - Constrained to `ContentConstraints.reading` (`760dp`); News & Documents use 2-column card grids on tablet.

---

## Quality Gates Status

- `dart format lib test`: PASS (Clean format)
- `flutter analyze`: PASS (0 issues found!)
- `flutter test`: PASS (151/151 tests passing across all suites including auth widget tests)
- `flutter build apk --debug`: PASS (`app-debug.apk` built with native record, file_picker, responsive layouts, and redesigned auth)
- Physical Device Baseline: Samsung SM-X510 (Galaxy Tab S9 FE, Android 16); verified both portrait and landscape orientation with 0 layout overflows.