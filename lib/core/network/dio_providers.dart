import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_client.dart';

part 'dio_providers.g.dart';

/// Espone l'istanza [Dio] condivisa da tutti i remote data source.
///
/// `keepAlive: true` perché il client HTTP è un singleton applicativo: non ha
/// senso ricrearlo (riallocando connessioni) a ogni rebuild. Alla dispose del
/// container il client viene chiuso con `dio.close()`.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final client = DioClient.create();
  ref.onDispose(client.close);
  return client;
}
