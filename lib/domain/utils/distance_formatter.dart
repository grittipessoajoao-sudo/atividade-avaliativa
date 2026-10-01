// Utilitário para formatação amigável de distâncias em metros ou quilômetros.
class DistanceFormatter {
  // Converte a distância em metros para string legível.
  static String format(double meters) {
    if (meters.isInfinite || meters.isNaN) {
      return 'Buscando GPS...';
    }
    if (meters < 1000) {
      return '${meters.round()} m';
    }
    final km = meters / 1000;
    return '${km.toStringAsFixed(2)} km';
  }
}
