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
| GET | `/api/v1/chats/?page=1&include_pinned=true&include_folders=true` | Bearer | `OpenWebUiChatsApi.listChats` → conversation list | VERIFIED LIVE |
| GET | `/api/v1/chats/stats/usage?items_per_page=60&page=1` | Bearer | `OpenWebUiChatsApi.listChats` (model per chat, best effort) | VERIFIED LIVE |
| GET | `/api/v1/chats/{id}` | Bearer | `OpenWebUiChatsApi.getChat` → messages of the shown branch | VERIFIED LIVE |
| POST | `/api/v1/chats/new` | Bearer | `OpenWebUiChatsApi.createChat` (after the first answer) | VERIFIED LIVE |
| POST | `/api/v1/chats/{id}` | Bearer | `OpenWebUiChatsApi.updateChat` (new messages after each answer) | VERIFIED LIVE |
| GET | `/api/v1/users/groups` | Bearer | `OpenWebUiAuthRemoteDataSource` after sign-in / session check → `AuthUser.groups` | VERIFIED LIVE |
| GET | `/api/v1/users/usage?days=30` | Bearer | `OpenWebUiQuotaRepository` (sum of `heatmap[].tokens`) | VERIFIED LIVE |
| GET | `/api/v1/knowledge/?page=` → `/api/v1/knowledge/{id}/files?page=` | Bearer | `OpenWebUiDocumentRepository.getDocuments` | VERIFIED LIVE (empty for `hr@`) |
| GET | `/api/v1/files/{id}` · `/api/v1/files/{id}/content` | Bearer | `OpenWebUiDocumentRepository` detail / download | unit-tested |
| GET | `/api/v1/notes/?page=1` · `/api/v1/notes/{id}` | Bearer | `OpenWebUiNewsRepository` (only with `features.notes`) | VERIFIED LIVE (empty for `hr@`) |
| GET | `/api/v1/configs/banners` | Bearer | `OpenWebUiNewsRepository` (admin banners in Bản tin) | VERIFIED LIVE (empty) |
| POST | `/api/v1/audio/transcriptions` | Bearer | `OpenWebUiSpeechTranscriber` (voice note → message text) | VERIFIED LIVE |
| POST | `/api/v1/tasks/title/completions` | Bearer | `OpenWebUiChatsApi.generateTitle` (new chat title) | VERIFIED LIVE (disabled by admin → first-question title) |
| GET | `/api/v1/prompts/list` + model `info.meta.suggestion_prompts` | Bearer | `promptSuggestionsProvider` (Hỏi HR chips) | VERIFIED LIVE (none configured) |
| GET | `/api/v1/calendars/events?start=&end=` | Bearer | `OpenWebUiScheduleRepository` (Trang chủ upcoming card + weekly count) | VERIFIED LIVE (empty) |
| POST | `/api/v1/auths/update/password` | Bearer | `OpenWebUiAuthRemoteDataSource.changePassword` (Tài khoản › Bảo mật) | VERIFIED LIVE (wrong password → 400) |
| GET | `/api/config` (public) | — | `ssoProvidersProvider` (SSO entry on sign-in) | VERIFIED LIVE (no providers → hidden) |
| GET | `/api/v1/files/{id}/content` (authorized download) | Bearer | `CachingAttachmentDownloader` (chat images, audio, video, files) | unit-tested |
| POST | `/api/v1/evaluations/feedback` · `/feedback/{id}` · DELETE `/feedback/{id}` | Bearer | `OpenWebUiChatProvider.rate` (👍/👎) | VERIFIED LIVE |
| POST | `/api/v1/audio/speech` | Bearer | `OpenWebUiSpeechSynthesizer` (read aloud) | VERIFIED LIVE |
| GET/POST/DELETE | `/api/v1/chats/pinned`, `/{id}/pinned`, `/{id}/pin`, `/{id}` | Bearer | `OpenWebUiChatsApi` (pin, rename, delete) | VERIFIED LIVE |

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
| **Hỏi HR** `HoiHrTab` (`/home/ask-hr`), HR staff | Pick an agent | `GET /api/models` | `ChatHubPage` as the tab: the agents the server lets the user use, then their chat history. HR = admin role or a group outside `EMPLOYEE_GROUPS` (`workRoleOf`); the Việc tab follows the same role. |
| **Hỏi HR** `AskHrPage` (`/home/ask-hr`), employees | Ask a question | `GET /api/models` (once per user) + `POST /api/chat/completions` | Opens conversation `agent-hr-assistant-<ts>`; `OpenWebUiChatProvider.agentModelIds` maps it to `employee_service` (GO AI Employee Service: grounded FAQ + RBAC + routing). Users who can't see that model (e.g. `sales@`) get their first model. |
| **Danh sách chat** `ChatHubPage` (`/home/account/chats`) | Browse AI agents | `GET /api/models` | The agent list is the user's model list from the server; nothing is hard-coded (handoff §3). `info.meta.description` → card subtitle. Loading and error (with retry) states are shown. |
| **Lịch sử agent** `AgentConversationListPage` (`/home/account/chats/agent/:id`) | Browse past chats / start a new chat | `GET /api/v1/chats/` + `GET /api/v1/chats/stats/usage` | Server chats whose answering model is this agent's model (the list has no model ids, so they come from the usage stats). New conversation id `agent-<modelId>-<ts>` (`AgentItem.newConversationId`); it keeps that id after the server chat is created. |
| **Hội thoại** (server chat) | Open a past chat | `GET /api/v1/chats/{id}` | Messages of the branch ending at `history.currentId`, with files, sources and model. Follow-ups use that chat's model. |
| **Hội thoại** `ConversationPage` (`/home/account/chats/:id`) | Send / regenerate / stop | `POST /api/chat/completions` (`stream: true`) | `model` = agent id parsed from the conversation id; the full turn history goes in `messages`. Stop cancels the HTTP stream. Sources (`{"sources": [...]}`) → citation chips. |
| **Hội thoại** | Attach a document / photo / voice note | `POST /api/v1/files/` → poll `/process/status` until `completed` → next chat request carries `files: [{"type": "file", "id": ...}]` | Hidden when the server's permissions lack `chat.file_upload`. `failed` / timeout → the message is marked failed (retry available). |
| **Hội thoại** | Every finished answer | `POST /api/v1/chats/new` (first) or `POST /api/v1/chats/{id}` | See §3 *Chat history*. A failed save is logged; the answer stays. |
| **Trang chủ** quota card, header quota bar | Open | `GET /api/v1/users/usage?days=30` | Tokens used in 30 days against `TOKEN_QUOTA_LIMIT` (config, 200,000): Open WebUI has no allowance of its own. Counts saved chats only (website and app). The card is not tappable. |
| **Tài liệu** `DocumentListPage` / `DocumentDetailPage` (`/home/documents`) | Browse, download | `GET /api/v1/knowledge/` → `/{id}/files` → `GET /api/v1/files/{id}/content` | Every file of every knowledge base the user may read, newest first; description = knowledge base name. Download goes through the authenticated Dio to the app cache, then opens with `open_filex`. |
| **Bản tin** (`/home/news`, Trang chủ, Tài khoản) | Read | `GET /api/v1/notes/` → `GET /api/v1/notes/{id}` | Notes shared with the user by others (own notes skipped); markdown shown as text. Without `features.notes` the server answers **401**, which would end the session, so the app makes no call and shows an empty feed. |
| Việc, Học tập, Bài kiểm tra, Phê duyệt | — | none | No Open WebUI equivalent → fakes until the website pages are embedded (`BACKEND_INTEGRATION_TODO.md`). |

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

**Chat history** (`OpenWebUiChatProvider` + `OpenWebUiChatsApi`), in the
website's format so both show the same chats:

```json
{"chat": {"title": "<first question, ≤ 60 chars>", "models": ["employee_service"],
  "history": {"currentId": "<answer id>", "messages": {
    "<q id>": {"id", "parentId", "childrenIds": [], "role": "user", "content",
               "timestamp": <s>, "models": [...], "files": [{"type": "file", "id", "name", ...}]},
    "<a id>": {"id", "parentId": "<q id>", "role": "assistant", "content", "model",
               "modelName", "done": true, "sources": [...], "usage": {...}}}},
  "messages": [...], "timestamp": <ms>}}
```

- Created on the first finished answer (`POST /api/v1/chats/new`); later
  answers send only unsaved messages (`POST /api/v1/chats/{id}` with
  `history`): the server merges `history.messages` by id and recomputes
  `childrenIds`.
- Regenerate stores a sibling answer under the same question (a branch, as
  on the website). Failed answers are not stored.
- Reading follows `parentId` from `history.currentId` to the root.
- The completion request does not pass `chat_id`: with it the server would
  answer over its websocket instead of the HTTP stream.

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

## 7. Coverage: every app feature vs. the Open WebUI API (0.11.4)

All 30 Open WebUI routers (~280 user-level endpoints) were checked against
the app's features (inventory of 2026-10-09). Every feature with a matching
API is wired; the rest have no Open WebUI equivalent.

**Mapped**

| Feature | API |
| --- | --- |
| Sign-in, session check, sign-out | `/api/v1/auths/signin`, `/api/v1/auths/`, `/api/v1/auths/signout` |
| HR vs employee layouts | `/api/v1/users/groups` + `EMPLOYEE_GROUPS` |
| SSO entry | `/api/config` → `oauth.providers` (shown only when configured) |
| Change password (Tài khoản › Bảo mật) | `/api/v1/auths/update/password` |
| Agent list | `/api/models` |
| Chat: send, stream, stop (client cancel), regenerate | `/api/chat/completions` |
| Chat history: list, open, save, per-agent filter | `/api/v1/chats/*`, `/api/v1/chats/stats/usage` |
| Chat title | `/api/v1/tasks/title/completions` (fallback: first question) |
| Attachments upload / RAG | `/api/v1/files/`, `/process/status` |
| Attachments display / open (images, audio, video, files) | `/api/v1/files/{id}/content` with the session |
| Voice note → text | `/api/v1/audio/transcriptions` |
| Citation chips → document | `/api/v1/files/{id}` (DocumentDetailPage) |
| Hỏi HR suggestion chips | model `suggestion_prompts` + `/api/v1/prompts/list` (shown only when configured) |
| Token quota | `/api/v1/users/usage` (limit = `TOKEN_QUOTA_LIMIT`) |
| Tài liệu (list, detail, download) | `/api/v1/knowledge/*`, `/api/v1/files/*` |
| Bản tin | `/api/v1/configs/banners` + shared `/api/v1/notes/` |
| Trang chủ "Việc sắp đến hạn", "Bạn có N việc" | `/api/v1/calendars/events` |
| Rate an answer 👍/👎 (tap again to clear) | `/api/v1/evaluations/feedback[/{id}]` + `annotation.rating`/`feedbackId` on the stored message (as the website) |
| Read an answer aloud | `/api/v1/audio/speech` (server TTS voice; cached mp3) — needs `chat.tts` |
| Rename / pin / delete a chat (agent history menu) | `POST /api/v1/chats/{id}` (title), `GET /{id}/pinned` + `POST /{id}/pin`, `GET /pinned`, `DELETE /{id}` (shown only with `chat.delete`: 401 otherwise) |

**No Open WebUI API (stay on demo data or need another backend / WebView)**

| Feature | Why |
| --- | --- |
| Việc của tôi: cases, onboarding checklist, new HR request, "bổ sung giấy tờ" | No case/workflow API |
| Approvals (Phê duyệt), HR inbox, probation review, coordination queue | No approval API |
| Học tập (courses, progress) and Bài kiểm tra | No learning/test API |
| Thông báo của tôi, bell unread dot, push | `/api/v1/notifications/*` are outbound webhook targets (404 on this server), not an inbox |
| "Mã nhân viên" on the account card | `/api/v1/users/user/info` is empty; the card shows the masked user id |
| Human chat (KHÁC · BLOCKED) | Channels exist but the admin disabled them ("Channels is disabled") |
| Agent avatars | `/api/v1/models/model/profile/image` returns the default logo for every agent; icons kept |
| Reply-to quote in chat | Open WebUI messages have no reply reference |
| Language setting | Stored on the device (the website keeps it in the browser too) |

APIs available but with no matching app feature yet (candidates, not
gaps): chat share, archive and folders, memories.

## 8. Open items

1. **Server bug: `HR Chief Manager` is listed by `/api/models` but chat
   returns `400 {"detail": "Model not found"}`.** The app shows the reply as
   failed. Needs a fix in the Open WebUI model config (its base model is
   probably missing or disabled). Its id also contains spaces; the app
   handles that.
2. Confirm `employee_service` is the intended Hỏi HR agent.
3. Images and voice notes use the same file pipeline; not tested live (only a text file was).
4. Chat history is on the server (newest 60 chats; no paging yet). Titles
   are the first question; the website names chats with a model call.
5. Uploaded-file URLs and avatars need the bearer header to display.
6. `hr@` reads no knowledge base and no shared note (2026-10-09): Tài liệu and
   Bản tin are empty until an admin grants a group read access (knowledge
   *Access* / note *Share*). The agents' own knowledge stays attached to the
   models and is not listed.
7. Open WebUI reports usage only; the 200,000-token limit is app config
   (`TOKEN_QUOTA_LIMIT`), for display, not enforced by the server.
8. `EMPLOYEE_GROUPS` = `Knowledge-IT` (the only employee test account).
   Probe of the test accounts (2026-10-09):

   | Account | Role | Group | Models | Layout |
   | --- | --- | --- | --- | --- |
   | `test@` | admin | — | 18 (incl. `go_ai_orchestrator.*` pipes) | HR |
   | `manager@` | user | Management | 12 | HR |
   | `hr@` | user | HR | 9 | HR |
   | `sales@` | user | Sales-Marketing | `sales_growth` | HR |
   | `finance@` | user | Finance | `payroll`, `employee_service` | HR |
   | `operations@` | user | Operations | `employee_service`, `compliance_offboarding` | HR |
   | `knowledge@` | user | Knowledge-IT | `ip_agent` | Employee |

   No account (admin included) sees a knowledge base or a note, so Tài liệu
   and Bản tin are empty for everyone. `knowledge@` cannot use
   `employee_service`, so its Hỏi HR questions go to `ip_agent`.
