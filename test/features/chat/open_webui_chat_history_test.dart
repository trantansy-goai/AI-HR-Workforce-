import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/features/chat/data/cache/in_memory_chat_cache.dart';
import 'package:goai_mobile/features/chat/data/chat_repository_impl.dart';
import 'package:goai_mobile/features/chat/data/providers/open_webui_chat_provider.dart';
import 'package:goai_mobile/features/chat/data/sources/open_webui_chats_api.dart';
import 'package:goai_mobile/features/chat/data/sources/open_webui_client.dart';
import 'package:goai_mobile/features/chat/domain/entities/agent_item.dart';
import 'package:goai_mobile/features/chat/domain/entities/message.dart';
import 'package:goai_mobile/features/chat/domain/entities/participant.dart';
import 'package:goai_mobile/features/chat/domain/extensions/ai_extensions.dart';
import 'package:goai_mobile/features/file/domain/attachment.dart';
import 'package:goai_mobile/shared/utils/id_generator.dart';

import '../../helpers/fake_http_adapter.dart';

const _base = 'https://webui.test';

const _me = Participant(id: 'u1', displayName: 'Mai', type: SenderType.user);

const _models = {
  'data': [
    {'id': 'employee_service', 'name': 'GO AI Employee Service'},
    {'id': 'payroll', 'name': 'Payroll'},
  ],
};

const _sse =
    'data: {"choices": [{"delta": {"content": "12 days"}, "finish_reason": "stop"}]}\n\n'
    'data: [DONE]\n\n';

/// A stored chat as `GET /api/v1/chats/{id}` returns it: the first answer
/// was regenerated, `a1b` is on the shown branch.
const _storedChat = {
  'id': 'c-1',
  'title': 'Annual leave',
  'updated_at': 1791500000,
  'chat': {
    'models': ['payroll'],
    'history': {
      'currentId': 'a1b',
      'messages': {
        'q1': {
          'id': 'q1',
          'parentId': null,
          'childrenIds': ['a1', 'a1b'],
          'role': 'user',
          'content': 'Leave days?',
          'timestamp': 1791400000,
          'files': [
            {
              'type': 'file',
              'id': 'f-7',
              'name': 'policy.pdf',
              'size': 2048,
              'file': {
                'meta': {'content_type': 'application/pdf'},
              },
            },
          ],
        },
        'a1': {
          'id': 'a1',
          'parentId': 'q1',
          'childrenIds': <String>[],
          'role': 'assistant',
          'content': 'Old answer',
          'model': 'payroll',
          'timestamp': 1791400010,
        },
        'a1b': {
          'id': 'a1b',
          'parentId': 'q1',
          'childrenIds': <String>[],
          'role': 'assistant',
          'content': '12 days',
          'model': 'payroll',
          'modelName': 'Payroll',
          'timestamp': 1791400020,
          'usage': {'prompt_tokens': 30, 'completion_tokens': 3},
          'sources': [
            {
              'source': {'id': 'f-7', 'name': null},
              'document': ['Leave is 12 days.'],
              'metadata': [
                {'name': 'policy.pdf', 'file_id': 'f-7'},
              ],
            },
          ],
        },
      },
    },
  },
};

void main() {
  late FakeHttpAdapter http;
  late OpenWebUiChatProvider provider;
  late InMemoryChatCache cache;
  late ChatRepositoryImpl repository;
  final created = <Map<String, dynamic>>[];
  final updates = <String, List<Map<String, dynamic>>>{};
  final completions = <Map<String, dynamic>>[];

  /// Each message is a second younger than the previous one.
  var seconds = 0;
  DateTime tick() =>
      DateTime(2026, 10, 9, 10).add(Duration(seconds: seconds++));

  void setUpChat({
    FakeResponse list = const FakeResponse(<Object>[]),
    FakeResponse stats = const FakeResponse({'items': <Object>[], 'total': 0}),
    FakeResponse create = const FakeResponse({'id': 'srv-1'}),
    FakeResponse title = const FakeResponse({
      'detail': 'Title generation is disabled',
    }),
  }) {
    seconds = 0;
    created.clear();
    updates.clear();
    completions.clear();
    http = FakeHttpAdapter({
      'GET /api/models': (_) => const FakeResponse(_models),
      'POST /api/chat/completions': (r) {
        completions.add(r.data as Map<String, dynamic>);
        return const FakeResponse(_sse, contentType: 'text/event-stream');
      },
      'GET /api/v1/chats/': (_) => list,
      'GET /api/v1/chats/stats/usage': (_) => stats,
      'GET /api/v1/chats/c-1': (_) => const FakeResponse(_storedChat),
      'POST /api/v1/tasks/title/completions': (_) => title,
      'POST /api/v1/chats/new': (r) {
        created.add(
          (r.data as Map<String, dynamic>)['chat'] as Map<String, dynamic>,
        );
        return create;
      },
      'POST /api/v1/chats/srv-1': (r) =>
          _recordUpdate(updates, 'srv-1', r.data),
      'POST /api/v1/chats/c-1': (r) => _recordUpdate(updates, 'c-1', r.data),
    });
    final dio = fakeDio(http);
    provider = OpenWebUiChatProvider(
      client: OpenWebUiClient(dio: dio, openWebUiBaseUrl: _base),
      chats: OpenWebUiChatsApi(dio: dio, baseUrl: _base),
      agentModelIds: const {AgentItem.hrAssistantId: 'employee_service'},
      self: _me,
      ids: SequentialIdGenerator('ai'),
      clock: tick,
    );
    cache = InMemoryChatCache();
    repository = ChatRepositoryImpl(
      provider: provider,
      cache: cache,
      self: _me,
      ids: SequentialIdGenerator('local'),
      clock: tick,
    );
  }

  tearDown(() => repository.dispose());

  group('new conversation', () {
    final conversationId = AgentItem.newConversationId(
      AgentItem.hrAssistantId,
      now: DateTime.fromMillisecondsSinceEpoch(1),
    );

    test('creates the server chat with the first answer', () async {
      setUpChat();
      await repository.sendMessage(conversationId, text: 'Leave days?');

      final chat = created.single;
      expect(chat['title'], 'Leave days?');
      expect(chat['models'], ['employee_service']);
      final history = chat['history'] as Map<String, dynamic>;
      expect(history['currentId'], 'ai-1');
      final messages = history['messages'] as Map<String, dynamic>;
      expect(messages['local-1'], {
        'id': 'local-1',
        'parentId': null,
        'childrenIds': <String>[],
        'content': 'Leave days?',
        'timestamp': DateTime(2026, 10, 9, 10).millisecondsSinceEpoch ~/ 1000,
        'role': 'user',
        'models': ['employee_service'],
      });
      expect(messages['ai-1'], containsPair('parentId', 'local-1'));
      expect(messages['ai-1'], containsPair('role', 'assistant'));
      expect(messages['ai-1'], containsPair('content', '12 days'));
      expect(messages['ai-1'], containsPair('model', 'employee_service'));
      expect(chat['messages'], hasLength(2));

      final conversation = cache.conversations.single;
      expect(conversation.id, conversationId);
      expect(conversation.title, 'Leave days?');
      expect(conversation.lastMessage?.content, '12 days');
      expect(
        conversation.participants.map((p) => p.id),
        contains('employee_service'),
      );
    });

    test(
      'later turns only send new messages, linked to the last answer',
      () async {
        setUpChat();
        await repository.sendMessage(conversationId, text: 'Leave days?');
        await repository.sendMessage(conversationId, text: 'And sick days?');

        expect(created, hasLength(1));
        final history = updates['srv-1']!.single['history'] as Map;
        expect(history['currentId'], 'ai-2');
        final messages = history['messages'] as Map;
        expect(messages.keys, ['local-2', 'ai-2']);
        expect((messages['local-2'] as Map)['parentId'], 'ai-1');
        expect((messages['ai-2'] as Map)['parentId'], 'local-2');
        // The model still sees the whole conversation.
        expect(completions.last['messages'], hasLength(3));
      },
    );

    test('the list keeps the app id of a chat created here', () async {
      setUpChat(
        list: const FakeResponse([
          {'id': 'srv-1', 'title': 'Leave days?', 'updated_at': 1791500000},
        ]),
      );
      await repository.sendMessage(conversationId, text: 'Leave days?');
      await repository.refreshConversations();

      expect(cache.conversations.single.id, conversationId);
    });

    test('takes the server title when title generation is on', () async {
      setUpChat(
        title: const FakeResponse({
          'choices': [
            {
              'message': {'content': '{"title": "📅 Annual leave days"}'},
            },
          ],
        }),
      );
      await repository.sendMessage(conversationId, text: 'Leave days?');

      expect(updates['srv-1']!.single, {'title': '📅 Annual leave days'});
      expect(cache.conversations.single.title, '📅 Annual leave days');
      final request = http.requests.firstWhere(
        (r) => r.uri.path == '/api/v1/tasks/title/completions',
      );
      expect(request.data, {
        'model': 'employee_service',
        'chat_id': 'srv-1',
        'messages': [
          {'role': 'user', 'content': 'Leave days?'},
          {'role': 'assistant', 'content': '12 days'},
        ],
      });
    });

    test('a failed save keeps the answer', () async {
      setUpChat(
        create: const FakeResponse({'detail': 'Server error'}, status: 500),
      );
      await repository.sendMessage(conversationId, text: 'Leave days?');

      final messages = cache.messages(conversationId);
      expect(messages.map((m) => m.status), everyElement(MessageStatus.sent));
      expect(messages.last.content, '12 days');
    });
  });

  group('server chats', () {
    test(
      'lists chats with their models, pinned and foldered included',
      () async {
        setUpChat(
          list: const FakeResponse([
            {'id': 'c-1', 'title': 'Annual leave', 'updated_at': 1791500000},
            {'id': 'c-2', 'title': '', 'updated_at': 1791400000},
          ]),
          stats: const FakeResponse({
            'items': [
              {
                'id': 'c-1',
                'models': {'payroll': 2, 'employee_service': 1},
              },
            ],
            'total': 1,
          }),
        );

        final conversations = await provider.fetchConversations();

        expect(conversations.map((c) => c.id), ['c-1', 'c-2']);
        expect(conversations.last.title, 'New Chat');
        expect(conversations.first.participants.map((p) => p.id), [
          'u1',
          'payroll',
        ]);
        expect(conversations.last.participants.map((p) => p.id), ['u1']);
        expect(
          conversations.first.updatedAt,
          DateTime.fromMillisecondsSinceEpoch(1791500000 * 1000),
        );
        final list = http.requests.firstWhere(
          (r) => r.uri.path == '/api/v1/chats/',
        );
        expect(list.queryParameters, {
          'page': 1,
          'include_pinned': true,
          'include_folders': true,
        });
      },
    );

    test('lists chats without models when usage stats fail', () async {
      setUpChat(
        list: const FakeResponse([
          {'id': 'c-1', 'title': 'Annual leave', 'updated_at': 1791500000},
        ]),
        stats: const FakeResponse({'detail': 'Forbidden'}, status: 403),
      );

      final conversations = await provider.fetchConversations();

      expect(conversations.single.participants.map((p) => p.id), ['u1']);
    });

    test('loads the shown branch with files, sources and model', () async {
      setUpChat();
      await repository.loadInitial('c-1');

      final messages = cache.messages('c-1');
      expect(messages.map((m) => m.id), ['q1', 'a1b']);

      final question = messages.first;
      expect(question.sender, _me);
      final file = question.attachments.single;
      expect(file.name, 'policy.pdf');
      expect(file.kind, AttachmentKind.document);
      expect(file.sizeBytes, 2048);
      expect(
        file.source,
        const RemoteAttachmentSource(
          url: '$_base/api/v1/files/f-7/content',
          storageKey: 'f-7',
        ),
      );

      final answer = messages.last;
      expect(answer.sender.id, provider.assistant.id);
      final info = answer.metadata.get<AiGenerationInfo>()!;
      expect(info.model.id, 'payroll');
      expect(info.model.displayName, 'Payroll');
      expect(info.promptTokens, 30);
      final source = answer.metadata.get<Citations>()!.sources.single;
      expect(source.title, 'policy.pdf');
      expect(source.snippet, 'Leave is 12 days.');
      expect(repository.hasMore('c-1'), isFalse);
    });

    test('continues a server chat with its model and files', () async {
      setUpChat();
      await repository.loadInitial('c-1');
      await repository.sendMessage('c-1', text: 'Sick days?');

      expect(completions.single['model'], 'payroll');
      expect(completions.single['files'], [
        {'type': 'file', 'id': 'f-7'},
      ]);
      expect(created, isEmpty);
      final messages =
          (updates['c-1']!.single['history'] as Map)['messages'] as Map;
      expect(messages.keys, ['local-1', 'ai-1']);
      expect((messages['local-1'] as Map)['parentId'], 'a1b');
    });

    test('regenerating saves a sibling answer to the same question', () async {
      setUpChat();
      await repository.loadInitial('c-1');
      await repository.regenerate('c-1');

      final history = updates['c-1']!.single['history'] as Map;
      expect(history['currentId'], 'ai-1');
      final messages = history['messages'] as Map;
      expect(messages.keys, ['ai-1']);
      expect((messages['ai-1'] as Map)['parentId'], 'q1');
    });
  });

  group('OpenWebUiChatsApi.currentBranch', () {
    test('falls back to the flat message list', () {
      expect(
        OpenWebUiChatsApi.currentBranch({
          'messages': [
            {'id': 'm1', 'role': 'user', 'content': 'Hi'},
          ],
        }).single['id'],
        'm1',
      );
    });

    test('stops at a parent cycle', () {
      final branch = OpenWebUiChatsApi.currentBranch({
        'history': {
          'currentId': 'b',
          'messages': {
            'a': {'id': 'a', 'parentId': 'b'},
            'b': {'id': 'b', 'parentId': 'a'},
          },
        },
      });
      expect(branch.map((m) => m['id']), ['a', 'b']);
    });
  });
}

FakeResponse _recordUpdate(
  Map<String, List<Map<String, dynamic>>> updates,
  String id,
  Object? data,
) {
  final chat = (data as Map<String, dynamic>)['chat'] as Map<String, dynamic>;
  updates.putIfAbsent(id, () => []).add(chat);
  return FakeResponse({'id': id, 'chat': chat});
}
