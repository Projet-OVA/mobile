class DateFormatUtils {
  /// Mois en français
  static const List<String> _moisFrancais = [
    '', // index 0 vide
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'août',
    'septembre',
    'octobre',
    'novembre',
    'décembre'
  ];

  /// Formate une date au format "15 janvier 2025"
  static String formatDateFull(dynamic date) {
    if (date == null) return '';

    try {
      DateTime dt;
      if (date is String) {
        dt = DateTime.parse(date);
      } else if (date is DateTime) {
        dt = date;
      } else {
        return date.toString();
      }

      return '${dt.day} ${_moisFrancais[dt.month]} ${dt.year}';
    } catch (e) {
      return date.toString();
    }
  }

}