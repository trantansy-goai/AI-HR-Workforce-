import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Canned HTTP response for [FakeHttpAdapter].
class FakeResponse {
  const FakeResponse(
    this.body, {
    this.status = 200,
    this.contentType = Headers.jsonContentType,
    this.headers = const {},
  });

  /// JSON-encoded unless it is already a [String].
  final Object? body;
  final int status;
  final String contentType;
  final Map<String, List<String>> headers;
}

/// Routes requests by `'METHOD /path'` to canned responses and records what
/// was sent. Unknown routes answer 404.
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter(this.routes);

  final Map<String, FakeResponse Function(RequestOptions request)> routes;
  final List<RequestOptions> requests = [];

  List<String> get calls => [
    for (final r in requests) '${r.method} ${r.uri.path}',
  ];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final route = routes['${options.method} ${options.uri.path}'];
    final response =
        route?.call(options) ??
        const FakeResponse({'detail': 'Not Found'}, status: 404);
    final body = response.body;
    return ResponseBody.fromString(
      body is String ? body : jsonEncode(body),
      response.status,
      headers: {
        Headers.contentTypeHeader: [response.contentType],
        ...response.headers,
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// A Dio wired to [adapter].
Dio fakeDio(FakeHttpAdapter adapter) => Dio()..httpClientAdapter = adapter;
