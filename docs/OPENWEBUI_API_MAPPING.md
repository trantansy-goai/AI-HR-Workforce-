# Open WebUI API Mapping — GOAI Mobile

Date: 2026-10-08
Source: *GO AI WORKFORCE — Open WebUI API Developer Handoff (final)*, plus the
Open WebUI reference it links to (`docs.openwebui.com/reference/api-endpoints`,
`/reference/api-flow`, and `backend/open_webui/routers/{auths,files}.py`).

Host (website = API): `https://workforce.ai-iep.vn` → `OPEN_WEBUI_BASE_URL` in
`config/staging.json` and `config/production.json`. `config/development.json`
keeps `USE_FAKE_BACKEND=true` (offline fakes, no network).

Auth model: email + password → JWT (`Authorization: Bearer <jwt>`). No static
API key and no refresh token. The app never stores credentials, and the JWT
lives only in `SecureStore` (redacted from network logs).

---

## 1. Endpoints

| Method | Endpoint | Auth | Mobile component | Status |
| --- | --- | --- | --- | --- |
| POST | `/api/v1/auths/signin` | none | `OpenWebUiAuthRemoteDataSource.signIn` | VERIFIED LIVE |
| GET | `/api/v1/auths/` | Bearer | `OpenWebUiAuthRemoteDataSource.verify` (on app start) | VERIFIED LIVE |
| POST | `/api/v1/auths/signout` | Bearer | `OpenWebUiAuthRemoteDataSource.signOut` (best effort) | VERIFIED LIVE |
| GET | `/api/models` | Bearer | `OpenWebUiClient.fetchModels` → `agentsProvider` | VERIFIED LIVE |
| POST | `/api/chat/completions` | Bearer | `OpenWebUiClient.generate` (`stream: true`) | VERIFIED LIVE |
| POST | `/api/v1/files/` | Bearer | `OpenWebUiFileUploader.upload` (multipart `file`) | VERIFIED LIVE |
| GET | `/api/v1/files/{id}/process/status` | Bearer | `OpenWebUiFileUploader` (polls every 1 s, 2 min timeout) | VERIFIED LIVE |

"VERIFIED LIVE": on 2026-10-08 the app's own Dart classes ran against
`workforce.ai-iep.vn` with the `hr@` test account: sign-in, session check,
model list, streamed chat, upload → `completed` → chat with the file (answer
quoted the file, citation `probe.txt`), sign-out. Unit tests replay the
recorded response shapes.

---

## 2. Screens → API

| Screen (route) | User action | API calls | Notes |
| --- | --- | --- | --- |
| **Đăng nhập** `SignInPage` (`/sign-in`) | Enter email + password, tap *Đăng nhập* | `POST /api/v1/auths/signin` | In real mode the form shows email + password; the mockup's account + phone + verification-code form stays for the fake/demo backend only (Open WebUI has no OTP). Wrong credentials (HTTP 400) → `UnauthorizedFailure` → snackbar. Guest sign-in is hidden in real mode. |
| **Splash** (`/splash`) | App start with a saved session | `GET /api/v1/auths/` | Refreshes role and permissions. 401 → local sign-out → login. Offline/5xx → keep the saved session. |
| **Tài khoản › Đăng xuất** | Sign out | `POST /api/v1/auths/signout` | Local session is cleared first; the server call is best effort. |
| **Any screen** | Any API call returns 401 | — | `AuthInterceptor` cannot refresh (no refresh token), so it calls `onSessionExpired` → session cleared → router redirects to login. |
| **Hỏi HR** `AskHrPage` (`/home/ask-hr`) | Ask a question | `GET /api/models` (once per user) + `POST /api/chat/completions` | Opens conversation `agent-hr-assistant-<ts>`; `OpenWebUiChatProvider.agentModelIds` maps it to `employee_service` (GO AI Employee Service: grounded FAQ + RBAC + routing). Users who can't see that model (e.g. `sales@`) get their first model. |
| **Danh sách chat** `ChatHubPage` (`/home/account/chats`) | Browse AI agents | `GET /api/models` | The agent list is the user's model list from the server; nothing is hard-coded (handoff §3). `info.meta.description` → card subtitle. Loading and error (with retry) states are shown. |
| **Lịch sử agent** `AgentConversationListPage` (`/home/account/chats/agent/:id`) | Start a new chat | — | New conversation id `agent-<modelId>-<ts>` (`AgentItem.newConversationId`). |
| **Hội thoại** `ConversationPage` (`/home/account/chats/:id`) | Send / regenerate / stop | `POST /api/chat/completions` (`stream: true`) | `model` = agent id parsed from the conversation id; the full turn history goes in `messages`. Stop cancels the HTTP stream. Sources (`{"sources": [...]}`) → citation chips. |
| **Hội thoại** | Attach a document / photo / voice note | `POST /api/v1/files/` → poll `/process/status` until `completed` → next chat request carries `files: [{"type": "file", "id": ...}]` | Hidden when the server's permissions lack `chat.file_upload`. `failed` / timeout → the message is marked failed (retry available). |
| Trang chủ, Việc, Học tập, Bản tin, Tài liệu, Phê duyệt, Token quota | — | none | Not covered by the handoff → stay on fakes (`BACKEND_INTEGRATION_TODO.md`). |

---

## 3. Contracts used

**Sign-in / session** (`SessionUserResponse`):

```json
{"token": "eyJ...", "token_type": "Bearer", "expires_at": 1767225600,
 "id": "...", "email": "...", "name": "...", "role": "user",
 "profile_image_url": "/user.png",
 "permissions": {"chat": {"file_upload": true}, "workspace": {"models": false}}}
```

- `expires_at` is epoch seconds or `null` (no expiry) → `AuthSession.expiresAt`.
- `permissions` is flattened to granted dotted keys (`chat.file_upload`) →
  `AuthUser.permissions`. `role` → `AuthUser.role`.
- `profile_image_url` is kept only if absolute or root-relative (`data:` URIs
  are dropped).

**Models**: `{"data": [{"id", "name", "info": {"meta": {"description"}}}]}`.
`id` is what the chat request sends as `model`.

**Chat request** (built by `OpenWebUiClient.buildPayload`):

```json
{"model": "<id from /api/models>", "stream": true,
 "messages": [{"role": "user", "content": "..."}],
 "files": [{"type": "file", "id": "<uploaded file id>"}]}
```

No system prompt is sent: each Open WebUI agent has its own.

**Chat response**: SSE `data:` lines. The parser handles
`choices[0].delta.content`, `finish_reason`, `{"sources": [...]}` (Open WebUI
shape: `source.{id,name,url}`, `document[0]`, `metadata[0].{name,source,file_id,url}`),
`{"citations": [...]}`, `usage`, `{"error": ...}` and `[DONE]`. If the server
setting forces a non-streamed reply (`application/json`), the full
`choices[0].message.content` is read instead.

**Upload**: multipart field `file` → `{"id": "...", ...}`; status endpoint
returns `{"status": "pending" | "completed" | "failed", "error"?}`.

---

## 4. Error handling (handoff §7)

| HTTP | Mapped to | App behavior |
| --- | --- | --- |
| 400 | `ValidationFailure` (sign-in: `UnauthorizedFailure`) | Inline message, no retry loop |
| 401 | `UnauthorizedFailure` | Session cleared, redirect to login |
| 403 | `ForbiddenFailure` | "You don't have permission" |
| 429 | `RateLimitFailure(retryAfter)` | "Too many requests, wait" (no automatic retry) |
| 5xx | `ServerFailure` | Temporary error; user can retry |

Error text comes from Open WebUI's `{"detail": "..."}` (and the generic
`{"message": "..."}`).

---

## 5. Security checklist (handoff §8)

- HTTPS host only; no credentials in source, config or tests.
- JWT in `SecureStore` only; `Authorization` is redacted by the logging interceptor.
- One JWT per signed-in user; the Open WebUI client and model cache are
  rebuilt when the user changes.
- Agent list and upload button follow server data/permissions; the server
  still enforces them.
- 401 → local session ends.

---

## 6. Live findings (2026-10-08)

| Account | Models from `/api/models` |
| --- | --- |
| `hr@` (role `user`) | payroll, workforce_planning, recruitment, onboarding, learning_culture, performance_talent, employee_service, compliance_offboarding, `HR Chief Manager` |

- JWT lifetime ≈ 4 weeks (`expires_at` set). `GET /api/v1/auths/` returns the same token.
- `permissions.chat.file_upload = true` for `hr@`.
- Streams are standard OpenAI chunks: role-only first chunk, `usage` on the
  `finish_reason` chunk, then `[DONE]`. With files, the first event is
  `{"sources": [...]}`, where `source.name` is `null` and the file name is in
  `metadata[0].name`.
- Agents pause **11–19 s between chunks** even for short answers →
  `OpenWebUiClient.generationTimeout` = 5 min (the app-wide receive timeout is 30 s).
- Upload of a small text file reached `completed` after about 3 polls.
- `profile_image_url` (`/api/v1/users/{id}/profile/image`) needs the bearer
  token (401 without it). No screen shows it yet; an avatar widget must send
  the header.

## 7. Open items

1. **Server bug: `HR Chief Manager` is listed by `/api/models` but chat
   returns `400 {"detail": "Model not found"}`.** The app shows the reply as
   failed. Needs a fix in the Open WebUI model config (its base model is
   probably missing or disabled). Its id also contains spaces; the app
   handles that.
2. Confirm `employee_service` is the intended Hỏi HR agent.
3. Images and voice notes use the same file pipeline; not tested live (only a text file was).
4. Chat history is local to the device (`InMemoryChatCache`); server-side
   chats (`/api/v1/chats/*`) are not used.
5. Uploaded-file URLs and avatars need the bearer header to display.
