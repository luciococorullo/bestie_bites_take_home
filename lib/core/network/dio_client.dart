import 'package:dio/dio.dart';

import 'logging_interceptor.dart';

/// Factory dell'istanza [Dio] condivisa, già configurata per le API pubbliche
/// di BestieBite: base URL, timeout sensati, header JSON e interceptor di log.
abstract final class DioClient {
  const DioClient._();

  /// Base URL delle API pubbliche (no auth, no API key).
  static const String baseUrl = 'https://api.bestiebite.com';

  /// Timeout applicato a connessione, invio e ricezione.
  static const Duration _timeout = Duration(seconds: 10);

  /// Crea un client già configurato. La gestione del ciclo di vita
  /// (`close`) è delegata al provider Riverpod che lo espone.
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: _timeout,
        sendTimeout: _timeout,
        receiveTimeout: _timeout,
        responseType: ResponseType.json,
        headers: const {'Accept': 'application/json'},
      ),
    );
    dio.interceptors.add(const LoggingInterceptor());
    return dio;
  }
}
