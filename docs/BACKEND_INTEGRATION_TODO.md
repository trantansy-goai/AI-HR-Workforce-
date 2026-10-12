# GOAI Mobile App - Backend Integration Contract Map

This document outlines the exact Mobile operations, required backend capabilities, data contracts, domain models, and production adapter requirements to replace development fixtures (Fake...Repository) when the client API arrives.

> **Note on Native Adapters**:
> - **Voice Recording**: NativeVoiceRecorder is implemented using package:record. Device microphone recording is NOT a backend blocker.
> - **File Picking**: NativeFilePicker is implemented using package:file_picker. Device document selection is NOT a backend blocker.
> - Only **Remote Upload** and **STT (Speech-to-Text)** require backend API contracts.

## Backend decision (2026-10-09)

The backend will not add APIs for the app. The remaining tabs either use
Open WebUI's own APIs (0.11.4, user-level endpoints only — the server keeps
its rules in between, so the app never calls a model directly) or embed the
website in a WebView.

| Tab | Plan | Open WebUI API |
| --- | --- | --- |
| Tài liệu | DONE — `OpenWebUiDocumentRepository` (needs knowledge shared with the user's group) | `GET /api/v1/knowledge/` → `/{id}/files` → `/api/v1/files/{id}/content` |
| Token quota | DONE — `OpenWebUiQuotaRepository` (usage from the server; limit `TOKEN_QUOTA_LIMIT` in config) | `GET /api/v1/users/usage` |
| Bản tin | DONE — `OpenWebUiNewsRepository`: notes HR shares with the user's group | `/api/v1/notes/` |
| Lịch (Trang chủ: Việc sắp đến hạn, số việc tuần này) | DONE — `OpenWebUiScheduleRepository` | `GET /api/v1/calendars/events` |
| Việc của tôi (cases, onboarding checklist) | WebView | none |
| Phê duyệt | WebView | none |
| Học tập progress, Bài kiểm tra | WebView | none |

The website (`workforce.ai-iep.vn`) **is** Open WebUI, so embedding it adds
no page for the WebView tabs above; they need pages from another web app.
Full feature-by-feature coverage: `OPENWEBUI_API_MAPPING.md` §8.

Open questions for the backend: which website pages back the WebView tabs,
and whether they accept the Open WebUI JWT (otherwise users sign in again in
the WebView). For Tài liệu and Bản tin, an admin must share knowledge bases
and notes with the employees' group; `hr@` sees none today.

## Live test: speech-to-text and LLM (2026-10-09)

Details, method and raw numbers: `OPENWEBUI_API_MAPPING.md` §7.

| Area | Finding | Who | Action |
| --- | --- | --- | --- |
| STT accuracy | Server uses local Whisper **`base`**: "bao nhiêu ngày" → "bài nhau này"; near-silence → Chinese text | Admin | Switch to Whisper `large-v3-turbo` or OpenAI / Azure (vi-VN) in Admin › Settings › Audio |
| STT in the app | Fixed: bubble at once, transcript filled in, `language=vi` sent, audio no longer used as a RAG source | App | Done (`f4d3f07`) |
| LLM latency | ~10 s to the first word (Open WebUI itself answers in 0.5 s) | Backend | Stream tokens; faster model for FAQs |
| Prompt size | 63–84 k prompt tokens for a one-line question | Backend | Top-k retrieval instead of whole policies |
| Answer quality | "Tools temporarily disconnected" answers; leading blank lines | Backend | Re-enable data tools; trim output |
| Token quota | 200 k / 30 days = 2–3 questions at today's prompt size | Business + Backend | Agree on the allowance after reducing prompts |
| Chat titles | Title generation disabled (no task model) | Admin | Set a task model, enable title generation |

---

## 1. Authentication & Session

- **Feature**: Employee Authentication
- **Mobile Operation**: Sign in with employee credentials & refresh access tokens.
- **Required Endpoint Capability**: Authenticate employee credentials; issue access & refresh tokens.
- **Required Request Fields**: email (or username), password.
- **Required Response Fields**: `accessToken`, `refreshToken`, expiresIn, user (id, displayName, email, `roles`, permissions).
- **Domain Model**: UserSession, UserProfile.
- **Current Repository Interface**: AuthRepository, AuthRemoteDataSource.
- **Current Fake Implementation**: FakeAuthRemoteDataSource.
- **Production Adapter**: DONE — `OpenWebUiAuthRemoteDataSource` (see `OPENWEBUI_API_MAPPING.md`).

---

## 2. RBAC & User Permissions

- **Feature**: Role-Based Access Control (RBAC)
- **Mobile Operation**: Gate UI tiles & feature routes based on server-driven permissions.
- **Required Endpoint Capability**: Fetch authenticated employee profile & granted permissions list.
- **Required Request Fields**: Bearer token (via Authorization header).
- **Required Response Fields**: permissions array (e.g. ["documents.read", "learning.read", "tests.take", "news.read", "approvals.manage"]).
- **Domain Model**: UserProfile.
- **Current Repository Interface**: AuthRepository.getCurrentUser().
- **Current Fake Implementation**: FakeAuthRemoteDataSource.
- **Production Adapter**: DONE — Open WebUI `role` + `permissions` from `/api/v1/auths/` → `AuthUser`.

---

## 3. Documents

- **Feature**: Knowledge Documents
- **Mobile Operation**: Fetch document catalog, view document metadata, download/open document file.
- **Required Endpoint Capability**: List employee-visible documents & return file download stream/URL.
- **Required Request Fields**: Query params (page, limit, category).
- **Required Response Fields**: id, `title`, description, `fileSizeBytes`, mimeType, uploadedAt, downloadUrl.
- **Domain Model**: DocumentItem.
- **Current Repository Interface**: DocumentRepository.
- **Current Fake Implementation**: FakeDocumentRepository.
- **Production Adapter**: DONE — `OpenWebUiDocumentRepository` (Open WebUI knowledge bases; download with the session).

---

## 4. File Attachment & Remote Upload

- **Feature**: File Attachment & Remote Upload
- **Mobile Operation**: Upload picked local file to backend storage. (Native file picking is already IMPLEMENTED via NativeFilePicker).
- **Required Endpoint Capability**: Multipart file upload endpoint.
- **Required Request Fields**: Multipart binary file (`file`), optional `filename`, mimeType.
- **Required Response Fields**: `fileId`, `fileName`, `fileSizeBytes`, contentType, `fileUrl`.
- **Domain Model**: Attachment, AttachmentSource.
- **Current Repository Interface**: FileUploader.
- **Current Fake Implementation**: FakeFileUploader.
- **Production Adapter**: DONE — `OpenWebUiFileUploader` (Open WebUI files API, for chat RAG).

---

## 5. E-Learning

- **Feature**: Training & E-Learning Courses
- **Mobile Operation**: View course list, read module content, view course resources.
- **Required Endpoint Capability**: Fetch course list & course module details.
- **Required Request Fields**: None / Course ID parameter.
- **Required Response Fields**: id, `title`, summary, durationMinutes, isCompleted, coverImageUrl, content, `attachmentUrl`.
- **Domain Model**: LearningCourse.
- **Current Repository Interface**: LearningRepository.
- **Current Fake Implementation**: FakeLearningRepository.
- **Production Adapter Needed**: HttpLearningRepository — no Open WebUI equivalent (needs another backend or a WebView page).

---

## 6. Online Test

- **Feature**: Compliance & Knowledge Exams
- **Mobile Operation**: View tests, fetch test questions, submit answer choices, view backend result.
- **Required Endpoint Capability**: Fetch tests, fetch test question payload, evaluate & grade submission.
- **Required Request Fields**: Test ID, `answers` map (questionId -> choiceIndex).
- **Required Response Fields**:
  - Questions: id, questionText, options (array of string choices).
  - Result: id, score, maxScore, isPassed, `feedback`.
- **Domain Model**: OnlineTest, TestQuestion, TestSubmission, TestResult.
- **Current Repository Interface**: OnlineTestRepository.
- **Current Fake Implementation**: FakeTestRepository.
- **Production Adapter Needed**: HttpOnlineTestRepository — no Open WebUI equivalent (needs another backend or a WebView page).

> **Important**: Mobile DOES NOT calculate score, pass/fail, or correct answer choices locally. The backend is authoritative.

---

## 7. Company News

- **Feature**: Internal News & Announcements
- **Mobile Operation**: Fetch news feed, read news article detail.
- **Required Endpoint Capability**: Fetch news feed & article body content.
- **Required Request Fields**: Article ID parameter.
- **Required Response Fields**: id, `title`, summary, content, publishedAt, imageUrl.
- **Domain Model**: NewsItem.
- **Current Repository Interface**: NewsRepository.
- **Current Fake Implementation**: FakeNewsRepository.
- **Production Adapter**: DONE — `OpenWebUiNewsRepository` (admin banners + notes shared with the user).

---

## 8. Quota & Token Usage

- **Feature**: AI Token Quota Display
- **Mobile Operation**: Fetch user token usage stats for current billing/usage period.
- **Required Endpoint Capability**: Fetch current user token usage & limit allowance.
- **Required Request Fields**: None (Bearer token in header).
- **Required Response Fields**: usedTokens, limitTokens, periodName.
- **Domain Model**: UserQuota.
- **Current Repository Interface**: QuotaRepository.
- **Current Fake Implementation**: FakeQuotaRepository.
- **Production Adapter**: DONE — `OpenWebUiQuotaRepository` (usage from `/api/v1/users/usage`; limit `TOKEN_QUOTA_LIMIT`).

> **Important**: Mobile DOES NOT calculate or enforce authoritative quota limits locally. Backend enforces limits on AI endpoints.

---

## 9. Human Approval

- **Feature**: Generic Request Approvals
- **Mobile Operation**: List pending approvals, view item details, submit action (approve/reject).
- **Required Endpoint Capability**: List pending approval items & post server-driven action.
- **Required Request Fields**: Approval ID, `action` ("approve" or "reject"), optional comment.
- **Required Response Fields**: Item id, `title`, `requesterName`, status, `availableActions` array (["approve", "reject"]), createdAt, detail.
- **Domain Model**: ApprovalItem.
- **Current Repository Interface**: ApprovalRepository.
- **Current Fake Implementation**: FakeApprovalRepository.
- **Production Adapter Needed**: HttpApprovalRepository — no Open WebUI equivalent (needs another backend or a WebView page).

---

## 10. STT (Speech-to-Text) Audio Transcription

- **Feature**: Voice Input Audio Transcription
- **Mobile Operation**: Transcribe local voice recording produced by NativeVoiceRecorder. (Audio recording is already IMPLEMENTED via NativeVoiceRecorder).
- **Required Endpoint Capability**: Multipart audio file transcription endpoint.
- **Required Request Fields**: Multipart audio file (`audio` file in M4A/AAC format).
- **Required Response Fields**: { "text": "Transcribed text content..." }.
- **Domain Model**: Plain text string / OutgoingMessage.
- **Current Repository Interface**: SttDataSource (to be injected into voice controller).
- **Current Fake Implementation**: None (Audio file remains on device).
- **Production Adapter**: DONE — `OpenWebUiSpeechTranscriber` (`POST /api/v1/audio/transcriptions`); the transcript becomes the message text.
- **Live result (2026-10-09)**: works end to end; accuracy limited by the server's Whisper `base` model (see the live test above).