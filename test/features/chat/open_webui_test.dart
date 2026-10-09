import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/core/config/app_config.dart';
import 'package:goai_mobile/core/error/app_failure.dart';
import 'package:goai_mobile/features/chat/data/providers/open_webui_chat_provider.dart';
import 'package:goai_mobile/features/chat/data/repositories/model_repository_impl.dart';
import 'package:goai_mobile/features/chat/data/sources/open_webui_client.dart';
import 'package:goai_mobile/features/chat/data/sources/open_webui_sse_parser.dart';
import 'package:goai_mobile/features/chat/domain/ai/text_generation.dart';
import 'package:goai_mobile/features/chat/domain/entities/agent_item.dart';
import 'package:goai_mobile/features/chat/domain/entities/message.dart';
import 'package:goai_mobile/features/chat/domain/entities/participant.dart';
import 'package:goai_mobile/features/chat/domain/extensions/ai_extensions.dart';
import 'package:goai_mobile/features/file/domain/attachment.dart';

import '../../helpers/fake_http_adapter.dart';

const _base = 'https://webui.test';

const _modelsJson = {
  'data': [
    {
      'id': 'hr-policy',
      'name': 'HR Policy Agent',
      'info': {
        'meta': {'description': 'Answers HR policy questions'},
      },
    },
    {'id': 'general', 'name': 'General'},
    {'name': 'no id is skipped'},
  ],
};

const _sse =
    'data: {"sources": [{"source": {"id": "f1", "name": "handbook.pdf"}, '
    '"document": ["Annual leave is 12 days."], '
    '"metadata": [{"source": "handbook.pdf", "file_id": "f1"}]}]}\n\n'
    'data: {"choices": [{"delta": {"content": "12 "}}]}\n\n'
    'data: {"choices": [{"delta": {"content": "days"}, "finish_reason": "stop"}]}\n\n'
    'data: {"choices": [], "usage": {"prompt_tokens": 9, "completion_tokens": 2}}\n\n'
    'data: [DONE]\n\n';

void main() {
  group('AppConfig GOAI Extensions', () {
    test('provides business and Open WebUI base URLs', () {
      const config = AppConfig(
        environment: AppEnvironment.development,
        appName: 'GOAI Mobile',
        apiBaseUrl: 'https://api.example.com',
        businessApiBaseUrl: 'https://business.example.com',
        openWebUiBaseUrl: 'https://openwebui.example.com',
      );

      expect(config.businessApiBaseUrl, equals('https://business.example.com'));
      expect(config.openWebUiBaseUrl, equals('https://openwebui.example.com'));
    });
  });

  group('OpenWebUiSseParser', () {
    const parser = OpenWebUiSseParser();

    test('parses normal text chunks and completion signal', () async {
      final input = Stream.fromIterable([
        'data: {"choices": [{"delta": {"content": "Hello"}}]}\n',
        'data: {"choices": [{"delta": {"content": " world!"}}]}\n',
        'data: [DONE]\n',
      ]);

      final chunks = await parser.parseStream(input).toList();

      expect(chunks.length, equals(3));
      expect(chunks[0], isA<TextChunk>());
      expect((chunks[0] as TextChunk).text, equals('Hello'));
      expect(chunks[1], isA<TextChunk>());
      expect((chunks[1] as TextChunk).text, equals(' world!'));
      expect(chunks[2], isA<DoneChunk>());
      expect((chunks[2] as DoneChunk).finishReason, equals(FinishReasons.stop));
    });

    test('parses citations and sources when present in SSE', () async {
      final input = Stream.fromIterable([
        'data: {"citations": [{"id": "doc1", "title": "KB Doc 1", "snippet": "Content 1"}]}\n',
        'data: {"choices": [{"delta": {"content": "Answer with sources"}}]}\n',
        'data: [DONE]\n',
      ]);

      final chunks = await parser.parseStream(input).toList();

      expect(chunks.length, equals(3));
      expect(chunks[0], isA<CitationsChunk>());
      final citations = (chunks[0] as CitationsChunk).sources;
      expect(citations.length, equals(1));
      expect(citations.first.title, equals('KB Doc 1'));
      expect(chunks[1], isA<TextChunk>());
    });

    test('handles malformed JSON chunks gracefully without crashing', () async {
      final input = Stream.fromIterable([
        'data: {invalid_json}\n',
        'data: {"choices": [{"delta": {"content": "Valid"}}] }\n',
        'data: [DONE]\n',
      ]);

      final chunks = await parser.parseStream(input).toList();

      expect(chunks.length, equals(2));
      expect((chunks[0] as TextChunk).text, equals('Valid'));
      expect(chunks[1], isA<DoneChunk>());
    });

    test('handles server error event in SSE payload', () async {
      final input = Stream.fromIterable([
        'data: {"error": "Model quota exhausted"}\n',
      ]);

      final chunks = await parser.parseStream(input).toList();

      expect(chunks.length, equals(1));
      expect(chunks.first, isA<DoneChunk>());
      expect(
        (chunks.first as DoneChunk).finishReason,
        equals(FinishReasons.error),
      );
    });
    test('maps Open WebUI sources and usage', () async {
      final chunks = await parser
          .parseStream(Stream.fromIterable(_sse.split('\n')))
          .toList();

      final citations = chunks.whereType<CitationsChunk>().single.sources;
      expect(citations.single.id, 'f1');
      expect(citations.single.title, 'handbook.pdf');
      expect(citations.single.snippet, 'Annual leave is 12 days.');
      expect(
        chunks.whereType<TextChunk>().map((c) => c.text).join(),
        '12 days',
      );
      final done = chunks.last as DoneChunk;
      expect(done.finishReason, FinishReasons.stop);
      expect(done.promptTokens, 9);
      expect(done.completionTokens, 2);
    });

    test('parses a stream captured from workforce.ai-iep.vn', () async {
      // Shapes recorded 2026-10-08 (ids replaced): a RAG `sources` event with
      // `source.name: null`, a role-only first chunk, usage on the last chunk.
      const live = [
        'data: {"sources": [{"source": {"id": "file-1", "name": null, '
            '"type": "file"}, "document": ["Ma kiem tra: ZEBRA-42."], '
            '"metadata": [{"created_by": "u", "file_id": "file-1", '
            '"name": "probe_policy.txt", "source": "probe_policy.txt", '
            '"start_index": 0}], "distances": [0.42]}]}',
        '',
        'data: {"id": "chatcmpl-1", "object": "chat.completion.chunk", '
            '"model": "employee_service", "choices": [{"index": 0, '
            '"delta": {"role": "assistant"}, "finish_reason": null}]}',
        '',
        'data: {"id": "chatcmpl-1", "object": "chat.completion.chunk", '
            '"model": "employee_service", "choices": [{"index": 0, '
            '"delta": {"content": "M\\u00e3 ki\\u1ec3m tra l\\u00e0 '
            'ZEBRA-42 [1]."}, "finish_reason": null}]}',
        '',
        'data: {"id": "chatcmpl-1", "object": "chat.completion.chunk", '
            '"model": "employee_service", "choices": [{"index": 0, '
            '"delta": {}, "finish_reason": "stop"}], "usage": '
            '{"prompt_tokens": 10757, "completion_tokens": 40, '
            '"total_tokens": 10797}}',
        '',
        'data: [DONE]',
      ];

      final chunks = await parser
          .parseStream(Stream.fromIterable(live))
          .toList();

      final source = chunks.whereType<CitationsChunk>().single.sources.single;
      expect(source.id, 'file-1');
      expect(source.title, 'probe_policy.txt');
      expect(source.snippet, 'Ma kiem tra: ZEBRA-42.');
      expect(
        chunks.whereType<TextChunk>().map((c) => c.text).join(),
        'Mã kiểm tra là ZEBRA-42 [1].',
      );
      final done = chunks.last as DoneChunk;
      expect(done.finishReason, FinishReasons.stop);
      expect(done.promptTokens, 10757);
      expect(done.completionTokens, 40);
    });

    test('ends cleanly when the stream closes without [DONE]', () async {
      final chunks = await parser
          .parseStream(
            Stream.fromIterable([
              'data: {"choices": [{"delta": {"content": "Hi"}}]}',
            ]),
          )
          .toList();
      expect((chunks.first as TextChunk).text, 'Hi');
      expect((chunks.last as DoneChunk).finishReason, FinishReasons.stop);
    });

    test('parses a non-streamed completion', () async {
      final chunks = await parser
          .parseCompletion(
            '{"choices": [{"message": {"content": "Full answer"}, '
            '"finish_reason": "stop"}], "usage": {"prompt_tokens": 3}}',
          )
          .toList();
      expect((chunks.first as TextChunk).text, 'Full answer');
      expect((chunks.last as DoneChunk).promptTokens, 3);
    });
  });

  group('OpenWebUiClient', () {
    late FakeHttpAdapter http;
    late OpenWebUiClient client;
    Map<String, dynamic>? sentChat;

    void serve({
      FakeResponse models = const FakeResponse(_modelsJson),
      FakeResponse chat = const FakeResponse(
        _sse,
        contentType: 'text/event-stream',
      ),
    }) {
      http = FakeHttpAdapter({
        'GET /api/models': (_) => models,
        'POST /api/chat/completions': (r) {
          sentChat = r.data as Map<String, dynamic>;
          return chat;
        },
      });
      client = OpenWebUiClient(dio: fakeDio(http), openWebUiBaseUrl: '$_base/');
    }

    GenerationRequest request({
      String? modelId,
      List<String> fileIds = const [],
    }) => GenerationRequest(
      modelId: modelId,
      fileIds: fileIds,
      turns: const [ChatTurn(AiRole.user, 'How many leave days?')],
    );

    test(
      'lists models with descriptions and skips entries without id',
      () async {
        serve();
        final models = await ModelRepositoryImpl(client).getAgents();

        expect(models.map((m) => m.id), ['hr-policy', 'general']);
        expect(models.first.displayName, 'HR Policy Agent');
        expect(models.first.description, 'Answers HR policy questions');
        expect(client.model.id, 'hr-policy');
      },
    );

    test('model list errors surface as AppFailure', () async {
      serve(
        models: const FakeResponse({
          'detail': 'Not authenticated',
        }, status: 401),
      );
      await expectLater(
        client.fetchModels(),
        throwsA(isA<UnauthorizedFailure>()),
      );
    });

    test('streams an answer from the requested model with RAG files', () async {
      serve();
      final chunks = await client
          .generate(request(modelId: 'general', fileIds: ['f1', 'f1']))
          .toList();

      expect(sentChat, {
        'model': 'general',
        'stream': true,
        'messages': [
          {'role': 'user', 'content': 'How many leave days?'},
        ],
        'files': [
          {'type': 'file', 'id': 'f1'},
        ],
      });
      expect(
        chunks.whereType<TextChunk>().map((c) => c.text).join(),
        '12 days',
      );
      expect(chunks.last, isA<DoneChunk>());
      expect(client.model.id, 'general');
    });

    test('gives agents a long chunk timeout', () async {
      serve();
      await client.generate(request(modelId: 'general')).toList();
      final chat = http.requests.last;
      expect(chat.receiveTimeout, const Duration(minutes: 5));
    });

    test('surfaces "Model not found" (400) as an error chunk', () async {
      serve(
        chat: const FakeResponse({'detail': 'Model not found'}, status: 400),
      );
      final chunks = await client
          .generate(request(modelId: 'general'))
          .toList();
      expect((chunks.single as DoneChunk).finishReason, FinishReasons.error);
    });

    test('falls back to the default model for unknown agent ids', () async {
      serve();
      await client.generate(request(modelId: AgentItem.hrAssistantId)).toList();
      expect(sentChat?['model'], 'hr-policy');
    });

    test('handles a JSON reply when the server disables streaming', () async {
      serve(
        chat: const FakeResponse({
          'choices': [
            {
              'message': {'content': 'Twelve days.'},
              'finish_reason': 'stop',
            },
          ],
        }),
      );
      final chunks = await client.generate(request()).toList();
      expect((chunks.first as TextChunk).text, 'Twelve days.');
    });

    test('ends with an error chunk when the server rejects the chat', () async {
      serve(chat: const FakeResponse({'detail': 'Forbidden'}, status: 403));
      final chunks = await client.generate(request()).toList();
      expect((chunks.single as DoneChunk).finishReason, FinishReasons.error);
    });

    test('ends with an error chunk when no model is available', () async {
      serve(models: const FakeResponse({'data': <Object>[]}));
      final chunks = await client.generate(request()).toList();
      expect((chunks.single as DoneChunk).finishReason, FinishReasons.error);
      expect(http.calls, ['GET /api/models']);
    });
  });

  group('Agent conversations', () {
    test('conversation ids round-trip the agent id', () {
      final id = AgentItem.newConversationId(
        'gpt-4o-mini',
        now: DateTime.fromMillisecondsSinceEpoch(42),
      );
      expect(id, 'agent-gpt-4o-mini-42');
      expect(AgentItem.agentIdOf(id), 'gpt-4o-mini');
      expect(AgentItem.agentIdOf('assistant'), isNull);
    });

    test('Open WebUI provider asks for the agent model and uploaded files', () {
      final provider = OpenWebUiChatProvider(
        client: OpenWebUiClient(dio: Dio(), openWebUiBaseUrl: _base),
      );
      const me = Participant(
        id: 'me',
        displayName: 'Me',
        type: SenderType.user,
      );
      final message = Message(
        id: 'm1',
        conversationId: 'agent-general-1',
        sender: me,
        createdAt: DateTime(2026),
        content: 'Summarize',
        attachments: const [
          Attachment(
            id: 'a1',
            name: 'policy.pdf',
            mimeType: 'application/pdf',
            kind: AttachmentKind.document,
            source: RemoteAttachmentSource(url: 'u', storageKey: 'file-9'),
          ),
        ],
      );

      final built = provider.buildRequest('agent-general-1', [message]);

      expect(built.modelId, 'general');
      expect(built.fileIds, ['file-9']);
      expect(built.turns.single.content, 'Summarize');
    });

    test('maps app-named agents to server models', () {
      final provider = OpenWebUiChatProvider(
        client: OpenWebUiClient(dio: Dio(), openWebUiBaseUrl: _base),
        agentModelIds: const {AgentItem.hrAssistantId: 'employee_service'},
      );
      expect(
        provider.modelIdFor(
          AgentItem.newConversationId(AgentItem.hrAssistantId),
        ),
        'employee_service',
      );
      expect(
        provider.modelIdFor(AgentItem.newConversationId('HR Chief Manager')),
        'HR Chief Manager',
      );
    });
  });
}
