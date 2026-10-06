# GOAI Mobile App - Backend Integration Contract Map

This document outlines the exact Mobile operations, required backend capabilities, data contracts, domain models, and production adapter requirements to replace development fixtures (Fake...Repository) when the client API arrives.

---

## 1. Authentication & Session

- **Feature**: Employee Authentication
- **Mobile Operation**: Sign in with employee credentials & refresh access tokens.
- **Required Endpoint Capability**: Authenticate employee credentials; issue access & refresh tokens.
- **Required Request Fields**: email (or username), password.
- **Required Response Fields**: ccessToken, efreshToken, expiresIn, user (id, displayName, email, oles, permissions).
- **Domain Model**: UserSession, UserProfile.
- **Current Repository Interface**: AuthRepository, AuthRemoteDataSource.
- **Current Fake Implementation**: FakeAuthRemoteDataSource.
- **Production Adapter Needed**: HttpAuthRemoteDataSource.

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
- **Production Adapter Needed**: HttpAuthRemoteDataSource.

---

## 3. Documents

- **Feature**: Knowledge Documents
- **Mobile Operation**: Fetch document catalog, view document metadata, download/open document file.
- **Required Endpoint Capability**: List employee-visible documents & return file download stream/URL.
- **Required Request Fields**: Query params (page, limit, category).
- **Required Response Fields**: id, 	itle, description, ileSizeBytes, mimeType, uploadedAt, downloadUrl.
- **Domain Model**: DocumentItem.
- **Current Repository Interface**: DocumentRepository.
- **Current Fake Implementation**: FakeDocumentRepository.
- **Production Adapter Needed**: HttpDocumentRepository.

---

## 4. File Picker & Upload

- **Feature**: File Attachment & Remote Upload
- **Mobile Operation**: Pick file from device storage, upload to server, attach to AI Chat or request.
- **Required Endpoint Capability**: Multipart file upload endpoint.
- **Required Request Fields**: Multipart binary file (ile), optional ilename, mimeType.
- **Required Response Fields**: ileId, ileName, ileSizeBytes, contentType, ileUrl.
- **Domain Model**: Attachment, AttachmentSource.
- **Current Repository Interface**: FileUploader, AttachmentPicker.
- **Current Fake Implementation**: FakeFileUploader, DefaultFilePicker.
- **Production Adapter Needed**: HttpFileUploader, FilePickerService (using ile_picker package).

---

## 5. E-Learning

- **Feature**: Training & E-Learning Courses
- **Mobile Operation**: View course list, read module content, view course resources.
- **Required Endpoint Capability**: Fetch course list & course module details.
- **Required Request Fields**: None / Course ID parameter.
- **Required Response Fields**: id, 	itle, summary, durationMinutes, isCompleted, coverImageUrl, content, ttachmentUrl.
- **Domain Model**: LearningCourse.
- **Current Repository Interface**: LearningRepository.
- **Current Fake Implementation**: FakeLearningRepository.
- **Production Adapter Needed**: HttpLearningRepository.

---

## 6. Online Test

- **Feature**: Compliance & Knowledge Exams
- **Mobile Operation**: View tests, fetch test questions, submit answer choices, view backend result.
- **Required Endpoint Capability**: Fetch tests, fetch test question payload, evaluate & grade submission.
- **Required Request Fields**: Test ID, nswers map (questionId -> choiceIndex).
- **Required Response Fields**:
  - Questions: id, questionText, options (array of string choices).
  - Result: id, score, maxScore, isPassed, eedback.
- **Domain Model**: OnlineTest, TestQuestion, TestSubmission, TestResult.
- **Current Repository Interface**: OnlineTestRepository.
- **Current Fake Implementation**: FakeTestRepository.
- **Production Adapter Needed**: HttpOnlineTestRepository.

> **Important**: Mobile DOES NOT calculate score, pass/fail, or correct answer choices locally. The backend is authoritative.

---

## 7. Company News

- **Feature**: Internal News & Announcements
- **Mobile Operation**: Fetch news feed, read news article detail.
- **Required Endpoint Capability**: Fetch news feed & article body content.
- **Required Request Fields**: Article ID parameter.
- **Required Response Fields**: id, 	itle, summary, content, publishedAt, imageUrl.
- **Domain Model**: NewsItem.
- **Current Repository Interface**: NewsRepository.
- **Current Fake Implementation**: FakeNewsRepository.
- **Production Adapter Needed**: HttpNewsRepository.

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
- **Production Adapter Needed**: HttpQuotaRepository.

> **Important**: Mobile DOES NOT calculate or enforce authoritative quota limits locally. Backend enforces limits on AI endpoints.

---

## 9. Human Approval

- **Feature**: Generic Request Approvals
- **Mobile Operation**: List pending approvals, view item details, submit action (approve/reject).
- **Required Endpoint Capability**: List pending approval items & post server-driven action.
- **Required Request Fields**: Approval ID, ction ("approve" or "reject"), optional comment.
- **Required Response Fields**: Item id, 	itle, equesterName, status, vailableActions array (["approve", "reject"]), createdAt, detail.
- **Domain Model**: ApprovalItem.
- **Current Repository Interface**: ApprovalRepository.
- **Current Fake Implementation**: FakeApprovalRepository.
- **Production Adapter Needed**: HttpApprovalRepository.

---

## 10. STT (Speech-to-Text) Audio Transcription

- **Feature**: Voice Input Audio Transcription
- **Mobile Operation**: Record voice audio snippet in chat composer & send to server for STT.
- **Required Endpoint Capability**: Multipart audio file transcription endpoint.
- **Required Request Fields**: Multipart audio file (udio file in OGG, WAV, or M4A format).
- **Required Response Fields**: { "text": "Transcribed text content..." }.
- **Domain Model**: Plain text string / OutgoingMessage.
- **Current Repository Interface**: VoiceRecorder.
- **Current Fake Implementation**: FakeVoiceRecorder.
- **Production Adapter Needed**: NativeVoiceRecorder (using ecord plugin) + HttpSttDataSource.