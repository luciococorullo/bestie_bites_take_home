import 'package:dio/dio.dart';

import 'failure.dart';
import 'request_cancelled_exception.dart';

/// Converte un [DioException] nel corrispondente [Failure] user-facing.
///
/// Eccezione importante: `DioExceptionType.cancel` **non** è un errore reale —
/// significa che abbiamo annullato noi la richiesta tramite `CancelToken`.
/// In quel caso viene lanciata [RequestCancelledException], così il chiamante
/// può scartare in silenzio un risultato ormai superato invece di mostrare
/// un messaggio d'errore.
Failure mapDioException(DioException exception) {
  switch (exception.type) {
    case DioExceptionType.cancel:
      throw const RequestCancelledException();

    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutFailure();

    case DioExceptionType.connectionError:
      return const NetworkFailure();

    case DioExceptionType.badResponse:
      return ServerFailure(statusCode: exception.response?.statusCode);

    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      // Un body JSON malformato emerge come `unknown` con dentro una
      // FormatException/TypeError: in quel caso è un problema di parsing.
      final inner = exception.error;
      if (inner is FormatException || inner is TypeError) {
        return const ParseFailure();
      }
      return const UnknownFailure();
  }
}
