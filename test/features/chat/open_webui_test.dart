import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_project_base/core/config/app_config.dart';
import 'package:flutter_project_base/features/chat/data/repositories/model_repository_impl.dart';
import 'package:flutter_project_base/features/chat/data/sources/open_webui_client.dart';
import 'package:flutter_project_base/features/chat/data/sources/open_webui_sse_parser.dart';
import 'package:flutter_project_base/features/chat/domain/ai/text_generation.dart';
import 'package:flutter_project_base/features/chat/domain/extensions/ai_extensions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

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
  });

  group('OpenWebUiClient & ModelRepository', () {
    late MockDio mockDio;
    late OpenWebUiClient client;
    late ModelRepositoryImpl repository;

    setUp(() {
      mockDio = MockDio();
      client = OpenWebUiClient(
        dio: mockDio,
        openWebUiBaseUrl: 'https://openwebui.example.com',
      );
      repository = ModelRepositoryImpl(client);
    });

    test('fetches available models from Open WebUI endpoint', () async {
      when(
        () => mockDio.get<dynamic>(
          'https://openwebui.example.com/api/models',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {
            'data': [
              {'id': 'gpt-4o', 'name': 'GPT-4o'},
              {'id': 'llama-3', 'name': 'Llama 3 70B'},
            ],
          },
        ),
      );

      final models = await repository.getModels();

      expect(models.length, equals(2));
      expect(models.first.id, equals('gpt-4o'));
      expect(models.first.displayName, equals('GPT-4o'));
      expect(models.last.id, equals('llama-3'));
    });

    test('sets and returns selected model', () {
      const newModel = ModelInfo(id: 'custom-agent', displayName: 'GOAI Agent');
      repository.setSelectedModel(newModel);

      expect(repository.getSelectedModel().id, equals('custom-agent'));
      expect(client.model.id, equals('custom-agent'));
    });
  });
}
