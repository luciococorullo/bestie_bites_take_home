/// Errori di dominio user-facing, disaccoppiati dai dettagli di trasporto
/// (dio / HTTP). I repository convertono le eccezioni di rete in un [Failure],
/// così presentation e UI ragionano solo su questi tipi.
///
/// La gerarchia è `sealed`: la UI può fare uno `switch` esaustivo sulle varianti
/// e ognuna porta con sé un [message] già pronto e localizzato in italiano.
sealed class Failure {
  const Failure();

  /// Messaggio pronto da mostrare all'utente (es. nella vista di retry).
  String get message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Nessuna connessione di rete raggiungibile (`DioExceptionType.connectionError`).
final class NetworkFailure extends Failure {
  const NetworkFailure();

  @override
  String get message =>
      'Nessuna connessione a Internet. Controlla la rete e riprova.';
}

/// La richiesta ha superato il timeout (connection / send / receive).
final class TimeoutFailure extends Failure {
  const TimeoutFailure();

  @override
  String get message => 'La richiesta ha impiegato troppo tempo. Riprova.';
}

/// Il server ha risposto con uno stato non riuscito (`badResponse`).
final class ServerFailure extends Failure {
  const ServerFailure({this.statusCode});

  /// Stato HTTP restituito, se disponibile.
  final int? statusCode;

  @override
  String get message =>
      'Si è verificato un errore sul server. Riprova più tardi.';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServerFailure && other.statusCode == statusCode);

  @override
  int get hashCode => Object.hash(runtimeType, statusCode);
}

/// La risposta non è nel formato atteso (`FormatException` / `TypeError`).
final class ParseFailure extends Failure {
  const ParseFailure();

  @override
  String get message => 'Risposta del server non valida. Riprova.';
}

/// Qualunque altro errore non riconducibile alle varianti sopra.
final class UnknownFailure extends Failure {
  const UnknownFailure();

  @override
  String get message => 'Qualcosa è andato storto. Riprova.';
}
