/// Segnala che una richiesta è stata annullata di proposito tramite
/// `CancelToken` (es. l'autocomplete precedente quando l'utente continua a
/// digitare).
///
/// Non è un [Failure]: un annullamento volontario **non** è un errore da
/// mostrare. I controller la intercettano e scartano in silenzio il risultato
/// ormai superato, evitando flash d'errore durante la digitazione veloce.
final class RequestCancelledException implements Exception {
  const RequestCancelledException();

  @override
  String toString() => 'RequestCancelledException';
}
