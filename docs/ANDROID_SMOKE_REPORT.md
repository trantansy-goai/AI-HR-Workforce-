# Android Physical Device Smoke Test Report

Date: 2026-10-07
Device Model: Samsung SM-X510 (Galaxy Tab S9 FE)
Android Version: Android 16 (API 36)
Build Target: `app-debug.apk` with `--dart-define-from-file=config/development.json`
Quality Gate: `flutter analyze` (0 issues), `flutter test` (130/130 PASS), APK debug build (PASS)

---

## Approved Navigation & Information Architecture

The application implements the approved 5-tab persistent bottom navigation with `StatefulShellRoute.indexedStack` based on the approved GO AI HR Workforce Phase 1 UI mockup (`https://go-ai-hr-phase1-ui.trantansy.chatgpt.site/`):

| Destination / Flow | Route / Path | Structure & Behavior | Status |
| :--- | :--- | :--- | :--- |
| **Tab 1: Trang chủ** | `/home/trang-chu` | Default landing workspace dashboard; employee greeting, quota bar, notification bell, pending work shortcuts (Checklist, My Work, Courses, Case Requests), and recent news list ("Bản tin mới"). | PASS |
| **Tab 2: Hỏi HR** | `/home/ask-hr` | Ask HR & Enterprise AI assistant root; question search card, topic chips (Bảo hiểm, Nghỉ phép, v.v.), AI Agents catalog (HR Policy Assistant, Mock Assistant, Legal Assistant) and conversation history list. | PASS |
| **Agent History** | `/home/chat/agent/:agentId` | Shows historical conversations for selected agent; action to start new conversation; clicking thread opens detail. | PASS |
| **Chat Detail** | `/home/chat/:id` | Full conversation view with `ChatComposer`, `NativeVoiceRecorder`, `NativeFilePicker`, and citation sources; hides bottom navigation via `rootNavigatorKey`. | PASS |
| **Tab 3: Việc của tôi** | `/home/my-work` | Employee work workspace: Onboarding checklist (A3) with progress indicators, Case tracking (A0/A4) with multi-step status, and permission-aware Human Approval inbox (M11). | PASS |
| **Tab 4: Học tập** | `/home/learning` | Unified learning hub for **Courses & Training** and **Certification Tests**; tabs switch cleanly. | PASS |
| **Test Taking** | `/home/tests/:id/take` | Immersive exam taking view; hides bottom navigation via `rootNavigatorKey`. | PASS |
| **Tab 5: Tài khoản** | `/home/account` | Employee identity card (avatar, name, email, role badge), "Bản tin nội bộ" link, Settings, and Sign out. | PASS |
| **Shared Header** | (All 5 root tabs) | Employee greeting (`Xin chào, {name}`), notification bell, and compact real-time token quota progress bar. | PASS |
| **Bản tin / News** | `/home/news` | Internal company posts list and article detail (`/home/news/:id`); accessed via Trang chủ and Tài khoản. | PASS |
| **Documents** | `/home/documents` | Knowledge documents list, detail view (`/home/documents/:id`), and download actions; accessed via Hỏi HR citations or shortcuts. | PASS |
| **Notifications** | `/home/notifications` | Deep links to Approvals, Learning, and News. Accessed via header bell icon. | PASS |
| **Approvals** | `/home/approvals` | Secondary permission-gated access via Việc của tôi and Notifications. | PASS |

---

## Physical Hardware & Native Features Summary

| Flow / Feature | Result | Evidence / Details |
| :--- | :--- | :--- |
| **App launch** | PASS | Launched via Impeller Vulkan backend on Samsung SM-X510 (Android 16). 0 crashes, 0 render errors. |
| **Auth/demo flow** | PASS | Guest mode entry, settings sign out, login screen, demo credentials, re-entry. |
| **Navigation & Back Stack** | PASS | 5-tab persistent shell (Trang chủ, Hỏi HR, Việc của tôi, Học tập, Tài khoản), sub-branch navigation, Android system back pop to previous stack or home branch. |
| **AI Chat UI** | PASS | Agent catalog, conversation history, composer, message bubble, citations, regenerate button. |
| **Live AI** | BLOCKED | Live Open WebUI host URL and API key not yet provisioned. |
| **Voice permission** | PASS | Android RECORD_AUDIO permission requested and handled via native `package:record`. |
| **Voice record** | PASS | Native recording starts, status banner displayed, duration timer counts up smoothly (verified 6s -> 36s). |
| **Voice stop** | PASS | Recording stopped, produces valid local audio file, posts audio attachment bubble. |
| **Voice cancel** | PASS | Recording cancelled via UI; active recording timer stopped and reset to idle. |
| **Voice output file** | PASS | Produced real AAC/M4A file in cache (`/data/user/0/.../cache/voice_recording_1791300328165.m4a`, 717,560 bytes). |
| **File picker open** | PASS | Android system file picker (`com.google.android.documentsui`) opened via `NativeFilePicker`. |
| **File select** | PASS | Picked real on-device image (`20250310_174452.jpg`, 2.7 MB); mapped filename, size, and type correctly into `AttachmentChip`. |
| **File cancel** | PASS | Cancelled picker with Back key; cleanly returned to conversation with 0 crashes and 0 phantom attachments. |
| **Việc của tôi** | PASS | Checklist with progress bar, Case requests with step indicator, and permission-gated Approvals button. |
| **Documents** | PASS | Knowledge documents list, detail view, document type chips, download action. |
| **Học tập Hub** | PASS | Courses catalog and certification assessments integrated into unified hub tab. |
| **Online Test** | PASS | Certification exam list, question view with radio buttons, submission, score calculation (100% Pass). |
| **Bản tin / News** | PASS | Internal company posts list, article detail view, timestamps, formatted metadata; accessible via Trang chủ & Tài khoản. |
| **Quota in Header** | PASS | Quota token progress bar (85% used, 42,500/50,000 tokens), interval chip, threshold warning state. |
| **Approval** | PASS | Accessible from Việc của tôi and Notifications; requests list, request types, requester metadata, status chips (APPROVED / REJECTED). |
| **Responsive Shell** | PASS | Switches to `NavigationBar` on phone (<600dp) and `NavigationRail` on tablet (>=600dp) with GoAI brand logo. |
| **Trang chủ Dashboard** | PASS | Single-column on phone; 2-column dashboard layout on tablet portrait & landscape without stretched cards. |
| **Hỏi HR Master-Detail** | PASS | Single column on phone; master-detail split on wide tablet with conversation panel and active chat composer. |
| **Học tập Hub Grid** | PASS | Adaptive 2-column course and test cards on tablet portrait and landscape. |
| **Việc của tôi 2-Column** | PASS | 2-column layout (Checklist left, Cases + Approvals right) on tablet. |
| **Account, Settings & News** | PASS | Constrained to reading max-width (760dp); news cards render as responsive grid. |

---

## Responsive UI Verification Summary

- **Responsive UI:** VERIFIED
- **Phone:** VERIFIED (Tested at ~360x800 and ~390x844 simulated dp; single-column layout, bottom navigation bar, stacked header)
- **Tablet portrait:** VERIFIED (Tested at ~720x1152 dp on Samsung Galaxy Tab S9 FE; NavigationRail, 2-column cards, adaptive header)
- **Tablet landscape:** VERIFIED (Tested at ~1152x720 dp on Samsung Galaxy Tab S9 FE; wide NavigationRail, master-detail Hỏi HR, 2-column news)

### Verification Screenshots
Screenshots saved under `test/reports/screenshots/`:
1. `1_trang_chu_phone.png`: Trang chủ on mobile phone width (360x800)
2. `2_trang_chu_tablet_portrait.png`: Trang chủ on tablet portrait (720x1152)
3. `3_trang_chu_tablet_landscape.png`: Trang chủ on tablet landscape (1152x720)
4. `4_hoi_hr_phone.png`: Hỏi HR single-column discovery on phone
5. `5_hoi_hr_tablet.png`: Hỏi HR master-detail split on tablet
6. `6_hoc_tap_tablet.png`: Học tập adaptive card grid on tablet

---

## Diagnostics & Layout Monitoring

- Uncaught Exceptions: 0
- Plugin Exceptions: 0
- Permission Errors: 0
- Disposed-Controller Errors: 0
- Riverpod Lifecycle Errors: 0
- GoRouter Errors: 0
- File / Path Exceptions: 0
- RenderFlex / Layout Overflows: 0 (Tested and guarded across phone, tablet portrait, and tablet landscape)

---

## Remaining Blockers

1. **Remote AI Chat & STT:** Open WebUI server credentials (host URL + API key) and STT backend endpoint contract.
2. **Remote Backend & Upload:** Business Backend contracts for Auth, Documents, File Upload, E-learning, Online Test, News, Quota, and Approvals.
3. **Human Chat Backend:** Future human-to-human messaging contracts (WebSocket / presence / typing / group chat) are currently BLOCKED.

