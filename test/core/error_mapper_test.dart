import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/core/error/app_failure.dart';
import 'package:goai_mobile/core/error/error_mapper.dart';
import 'package:goai_mobile/core/error/result.dart';

DioException _response(int status, [Object? data]) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<Object?>(
      requestOptions: options,
      statusCode: status,
      data: data,
    ),
  );
}

void main() {
  group('ErrorMapper.fromDio', () {
    test('maps timeouts to NetworkFailure(timeout)', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        final failure = ErrorMapper.fromDio(
          DioException(requestOptions: RequestOptions(), type: type),
        );
        expect(
          failure,
          isA<NetworkFailure>().having(
            (f) => f.reason,
            'reason',
            NetworkFailureReason.timeout,
          ),
        );
      }
    });

    test('maps connection errors and cancellation', () {
      expect(
        ErrorMapper.fromDio(
          DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.connectionError,
          ),
        ),
        isA<NetworkFailure>(),
      );
      expect(
        ErrorMapper.fromDio(
          DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.cancel,
          ),
        ),
        isA<CancelledFailure>(),
      );
    });

    test('maps HTTP status codes', () {
      expect(ErrorMapper.fromDio(_response(401)), isA<UnauthorizedFailure>());
      expect(ErrorMapper.fromDio(_response(403)), isA<ForbiddenFailure>());
      expect(ErrorMapper.fromDio(_response(404)), isA<NotFoundFailure>());
      expect(
        ErrorMapper.fromDio(_response(503)),
        isA<ServerFailure>().having((f) => f.statusCode, 'status', 503),
      );
    });

    test('parses validation message and field errors', () {
      final failure = ErrorMapper.fromDio(
        _response(422, {
          'message': 'Invalid input',
          'errors': {
            'email': ['is taken'],
            'name': 'required',
          },
        }),
      );
      expect(failure, isA<ValidationFailure>());
      final validation = failure as ValidationFailure;
      expect(validation.message, 'Invalid input');
      expect(validation.fieldErrors, {
        'email': ['is taken'],
        'name': ['required'],
      });
    });

    test('keeps an AppFailure already attached by an interceptor', () {
      const inner = ForbiddenFailure('custom');
      final failure = ErrorMapper.fromDio(
        DioException(requestOptions: RequestOptions(), error: inner),
      );
      expect(failure, same(inner));
    });
  });

  group('ErrorMapper.map', () {
    test('passes AppFailure through and maps common errors', () {
      const failure = NotFoundFailure();
      expect(ErrorMapper.map(failure), same(failure));
      expect(ErrorMapper.map(TimeoutException('t')), isA<NetworkFailure>());
      expect(
        ErrorMapper.map(const FormatException('x')),
        isA<UnknownFailure>(),
      );
      expect(ErrorMapper.map(StateError('boom')), isA<UnknownFailure>());
    });
  });

  group('guard', () {
    test('returns Ok on success and Err on failure', () async {
      final ok = await guard(() async => 42);
      expect(ok.valueOrNull, 42);

      final err = await guard<int>(() async => throw const ServerFailure());
      expect(err.failureOrNull, isA<ServerFailure>());
      expect(err.isOk, isFalse);
    });
  });

  group('Open WebUI responses', () {
    test('reads the FastAPI "detail" message', () {
      final failure = ErrorMapper.fromDio(
        _response(403, {'detail': 'Access prohibited'}),
      );
      expect(failure, isA<ForbiddenFailure>());
      expect(failure.message, 'Access prohibited');
    });

    test('maps 429 to RateLimitFailure with Retry-After', () {
      final options = RequestOptions(path: '/x');
      final failure = ErrorMapper.fromDio(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response<Object?>(
            requestOptions: options,
            statusCode: 429,
            headers: Headers.fromMap({
              'retry-after': ['30'],
            }),
          ),
        ),
      );
      expect(
        failure,
        isA<RateLimitFailure>().having(
          (f) => f.retryAfter,
          'retryAfter',
          const Duration(seconds: 30),
        ),
      );
    });
  });
}
