import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor di logging leggero: traccia richieste, risposte ed errori HTTP
/// solo in debug (`kDebugMode`), così le build di release restano silenziose.
class LoggingInterceptor extends Interceptor {
  const LoggingInterceptor();

  static const String _logName = 'dio';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log('→ ${options.method} ${options.uri}', name: _logName);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log(
        '← ${response.statusCode} ${response.requestOptions.uri}',
        name: _logName,
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log(
        '✗ ${err.type.name} ${err.requestOptions.uri} '
        '(${err.response?.statusCode ?? '-'})',
        name: _logName,
        error: err.message,
      );
    }
    handler.next(err);
  }
}
