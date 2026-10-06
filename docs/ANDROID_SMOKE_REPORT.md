# Android Physical Device Smoke Test Report

Date: 2026-10-06
Device Model: Samsung SM-X510 (Galaxy Tab S9 FE)
Android Version: Android 16 (API 36)
Build Commit: 6b79fef
Environment: Development (compile-time defines from config/development.json)
Quality Gate: flutter analyze (0 issues), flutter test (116/116 PASS), APK debug build (PASS)

---

## Test Execution Summary

| Flow / Feature | Result | Evidence / Details |
| :--- | :--- | :--- |
| **App launch** | PASS | Launched via Impeller Vulkan backend (PID 7480). 0 crashes, 0 render errors. |
| **Auth/demo flow** | PASS | Guest mode entry, settings sign out, login screen, demo credentials, re-entry. |
| **Navigation** | PASS | Deep navigation across 8 top-level modules, back stack, app bar back button. |
| **AI Chat UI** | PASS | Model/agent list, conversation history, composer, message bubble, citations, regenerate button. |
| **Live AI** | BLOCKED | Live Open WebUI host URL and API key not yet provisioned. |
| **Voice permission** | PASS | Android RECORD_AUDIO permission requested and handled via native package:record. |
| **Voice record** | PASS | Native recording starts, status banner displayed, duration timer counts up smoothly (verified 6s -> 36s). |
| **Voice stop** | PASS | Recording stopped, produces valid local audio file, posts audio attachment bubble. |
| **Voice cancel** | PASS | Recording cancelled via UI; active recording timer stopped and reset to idle. |
| **Voice output file** | PASS | Produced real AAC/M4A file in cache (/data/user/0/.../cache/voice_recording_1791300328165.m4a, 717,560 bytes). |
| **File picker open** | PASS | Android system file picker (com.google.android.documentsui) opened via NativeFilePicker. |
| **File select** | PASS | Picked real on-device image (20250310_174452.jpg, 2.7 MB); mapped filename, size, and type correctly into AttachmentChip. |
| **File cancel** | PASS | Cancelled picker with Back key; cleanly returned to conversation with 0 crashes and 0 phantom attachments. |
| **Documents** | PASS | Knowledge documents list, detail view, document type chips, download action. |
| **E-learning** | PASS | Course catalog, progress indicators, course detail view, 5 structured lessons. |
| **Online Test** | PASS | Certification exam list, question view with radio buttons, submission, score calculation (100% Pass). |
| **News** | PASS | Company news list, article detail view, timestamps, formatted metadata. |
| **Quota** | PASS | Quota token progress bar (85% used, 42,500/50,000 tokens), interval chip, threshold warning state. |
| **Approval** | PASS | Requests list, request types, requester metadata, status chips (APPROVED / REJECTED). |

---

## Diagnostics & Log Monitoring

- Uncaught Exceptions: 0
- Plugin Exceptions: 0
- Permission Errors: 0
- Disposed-Controller Errors: 0
- Riverpod Lifecycle Errors: 0
- GoRouter Errors: 0
- File / Path Exceptions: 0
- RenderFlex / Layout Overflows: 0

---

## Defect Resolution (P0/P1)

1. **Bug Found:** ChatComposer used fallback FakeVoiceRecorder by default because ConversationPage did not pass oiceRecorder: ref.watch(voiceRecorderProvider).
   - **Root Cause:** Provider was not wired to ChatComposer constructor argument.
   - **Fix:** Wired oiceRecorder: ref.watch(voiceRecorderProvider) in ConversationPage.
2. **Bug Found:** oiceRecorderProvider and ttachmentPickerProvider were checking config.useFakeBackend, forcing in-memory fakes whenever development mode ran with fixture repositories.
   - **Root Cause:** Coupling mobile-owned native hardware adapters to backend mock flags.
   - **Fix:** Introduced useFakeNativeAdapters into AppConfig (defaulting to alse). Real devices now default to NativeVoiceRecorder and NativeFilePicker while business repositories safely consume development fixtures until backend APIs arrive.

---

## Remaining Blockers

1. **Remote AI Chat & STT:** Open WebUI server credentials (host URL + API key) and STT backend endpoint contract.
2. **Remote Backend & Upload:** Business Backend contracts for Auth, Documents, File Upload, E-learning, Online Test, News, Quota, and Approvals.
