class EventSortUtils {
  /// Trie les événements par date décroissante (les plus récents en premier)
  static List<dynamic> sortByMostRecent(List<dynamic> events, {String dateField = 'eventDate'}) {
    final sortedEvents = List<dynamic>.from(events);

    sortedEvents.sort((a, b) {
      try {
        final dateA = a[dateField];
        final dateB = b[dateField];

        if (dateA == null) return 1;
        if (dateB == null) return -1;

        final dtA = DateTime.parse(dateA);
        final dtB = DateTime.parse(dateB);

        return dtB.compareTo(dtA); // Plus récent en premier
      } catch (e) {
        return 0;
      }
    });

    return sortedEvents;
  }

  /// Trie les événements par date croissante (les plus anciens en premier)
  static List<dynamic> sortByOldest(List<dynamic> events, {String dateField = 'eventDate'}) {
    final sortedEvents = List<dynamic>.from(events);

    sortedEvents.sort((a, b) {
      try {
        final dateA = a[dateField];
        final dateB = b[dateField];

        if (dateA == null) return 1;
        if (dateB == null) return -1;

        final dtA = DateTime.parse(dateA);
        final dtB = DateTime.parse(dateB);

        return dtA.compareTo(dtB); // Plus ancien en premier
      } catch (e) {
        return 0;
      }
    });

    return sortedEvents;
  }

  /// Trie les événements à venir en premier, puis les événements passés
  static List<dynamic> sortByUpcoming(List<dynamic> events, {String dateField = 'eventDate'}) {
    final now = DateTime.now();
    final sortedEvents = List<dynamic>.from(events);

    sortedEvents.sort((a, b) {
      try {
        final dateA = a[dateField];
        final dateB = b[dateField];

        if (dateA == null) return 1;
        if (dateB == null) return -1;

        final dtA = DateTime.parse(dateA);
        final dtB = DateTime.parse(dateB);

        final isAPast = dtA.isBefore(now);
        final isBPast = dtB.isBefore(now);

        // Événements futurs avant événements passés
        if (isAPast && !isBPast) return 1;
        if (!isAPast && isBPast) return -1;

        // Même catégorie : futurs triés par date croissante, passés par date décroissante
        return isAPast ? dtB.compareTo(dtA) : dtA.compareTo(dtB);
      } catch (e) {
        return 0;
      }
    });

    return sortedEvents;
  }

}