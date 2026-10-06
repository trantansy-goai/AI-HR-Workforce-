# Open WebUI API Mapping — GOAI Mobile

Date: 2026-10-06
Target Integration: Open WebUI REST & SSE API

---

## Endpoint Mapping Overview

| Target Endpoint | HTTP Method | Data Payload / Format | Mobile Base Interface |
| --- | --- | --- | --- |
| `/api/v1/auths/signin` | `POST` | `{ "email": "...", "password": "..." }` | `HttpAuthRemoteDataSource.signInWithEmail` |
| `/api/v1/auths/verify` | `GET` | Bearer Token in Header | `AuthRepository.restoreSession` & `ProfileRepository` |
| `/api/models` | `GET` | List of available models/agents | `ModelRepository.fetchModels` |
| `/api/chat/completions` | `POST` | `{ "model": "...", "messages": [...], "stream": true }` | `RemoteAiClient.generate` (SSE Stream) |
| `/api/v1/files/` | `POST` | `multipart/form-data` | `FileUploader.upload` |

---

## Architectural Responsibility

- **Mobile App**: Captures user requests, maintains JWT Bearer state, streams SSE tokens into Riverpod `MessageDelta` events, and renders UI components.
- **Backend / Open WebUI**: Handles LLM inference, RAG embeddings, vector search, model routing, token usage calculations, and approval workflows.
