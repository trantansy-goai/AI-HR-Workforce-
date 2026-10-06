# GOAI Mobile App - Backend Integration TODO

This document summarizes the exact backend API contracts needed by the Mobile App to replace current development fixtures (Fake...Repository).

---

## 1. Auth / RBAC

- **POST /api/v1/auth/login**: Authenticates employee (email/password or SSO); returns ccessToken, efreshToken, expiresIn.
- **POST /api/v1/auth/refresh**: Instantiates new access token using refresh token.
- **GET /api/v1/auth/me**: Returns current user profile (id, name, email) and permissions array (e.g. ["documents.read", "learning.read", "tests.take", "approvals.manage"]).

---

## 2. Agent

- **GET /api/v1/agents** (or Open WebUI /api/models): Lists available enterprise AI agents, descriptions, and backing model IDs to be displayed in AI Chat.

---

## 3. Documents

- **GET /api/v1/documents**: Returns list of documents (id, 	itle, description, ileSizeBytes, mimeType, uploadedAt, downloadUrl).
- **GET /api/v1/documents/:id**: Returns specific document detail metadata.

---

## 4. Upload

- **POST /api/v1/files/upload**: Multipart file upload; returns ileId, ileName, ileSize, contentType, and downloadable ileUrl.

---

## 5. E-learning

- **GET /api/v1/learning/courses**: Returns available learning courses (id, 	itle, summary, durationMinutes, isCompleted, coverImageUrl).
- **GET /api/v1/learning/courses/:id**: Returns full course content, modules, and attachment/resource URL.

---

## 6. Online Test

- **GET /api/v1/tests**: Returns list of online tests (id, 	itle, description, durationMinutes, questionCount).
- **GET /api/v1/tests/:id/questions**: Returns list of questions (id, questionText, options []).
- **POST /api/v1/tests/:id/submit**: Accepts { answers: { questionId: choiceIndex } }; returns test result (id, score, maxScore, isPassed, eedback).

---

## 7. News

- **GET /api/v1/news**: Returns company news articles (id, 	itle, summary, publishedAt, imageUrl).
- **GET /api/v1/news/:id**: Returns full news article content.

---

## 8. Quota / Token Usage

- **GET /api/v1/quota/me**: Returns current user's token quota (usedTokens, limitTokens, periodName).

---

## 9. Approval

- **GET /api/v1/approvals**: Returns pending approval requests (id, 	itle, equesterName, status, vailableActions ["approve", "reject"], createdAt, detail).
- **POST /api/v1/approvals/:id/action**: Accepts { action: "approve" | "reject", comment?: "..." }; returns updated approval status.

---

## 10. STT (Speech-to-Text)

- **POST /api/v1/audio/transcriptions**: Multipart audio file upload (OGG/WAV/M4A); returns { text: "Transcribed speech text..." }.