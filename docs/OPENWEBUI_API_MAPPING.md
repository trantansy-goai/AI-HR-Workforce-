# Open WebUI API Mapping — GOAI Mobile

Date: 2026-10-06
Target Integration: Open WebUI REST & SSE API

---

## Endpoint Verification & Implementation Matrix

| Target Endpoint | HTTP Method | Authentication | Stream | Implementation Status | Mobile Client Component |
| --- | --- | --- | --- | --- | --- |
| `/api/models` | `GET` | Bearer Token (Optional) | No | **VERIFIED & IMPLEMENTED** | `OpenWebUiClient.fetchModels()` & `ModelRepositoryImpl` |
| `/api/chat/completions` | `POST` | Bearer Token (Optional) | Yes (SSE) | **VERIFIED & IMPLEMENTED** | `OpenWebUiClient.generate()` & `OpenWebUiSseParser` |
| `/api/v1/files/` | `POST` | Bearer Token | No | **MAPPED (PARTIAL)** | `OpenWebUiFileUploader` (Contract ready) |
| `/api/v1/auths/signin` | `POST` | None | No | **MAPPED (BLOCKED)** | Waiting for Open WebUI instance URL & auth policy |

---

## SSE Payload Contract (`/api/chat/completions`)

- `data: {"choices": [{"delta": {"content": "..."}, "finish_reason": null}]}` -> parsed into `TextChunk`
- `data: {"citations": [{"id": "...", "title": "...", "snippet": "..."}]}` -> parsed into `CitationsChunk`
- `data: [DONE]` -> parsed into `DoneChunk(finishReason: 'stop')`
- `data: {"error": "..."}` -> parsed into `DoneChunk(finishReason: 'error')`

---

## Architectural Responsibility Boundary

- **Mobile App (`goai_mobile`)**: Manages UI state, Riverpod providers, SSE stream parsing, model selection, local audio recording, session token storage, and error recovery.
- **Backend / Open WebUI**: Model execution, vector RAG retrieval, token quota enforcement, and approval business workflows.
