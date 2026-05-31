/// Spaziature e raggi di curvatura condivisi, per layout coerenti.
abstract final class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// Raggi di curvatura (corner radius) morbidi richiesti dal design.
abstract final class AppRadius {
  const AppRadius._();

  static const double sm = 12;
  static const double md = 14;
  static const double lg = 16;
}
