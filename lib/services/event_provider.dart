import 'package:flutter/material.dart';
import 'package:SIRA/services/api_service.dart';

class EventProvider with ChangeNotifier {
  final Map<String, bool> _participating = {};
  final Map<String, bool> _loading = {};
  final Map<String, int> _participantsCount = {};

  bool isParticipating(String eventId) => _participating[eventId] ?? false;
  bool isLoading(String eventId) => _loading[eventId] ?? false;
  int participantsCount(String eventId) => _participantsCount[eventId] ?? 0;

  void setEvent(String eventId, bool participating, int count) {
    _participating[eventId] = participating;
    _participantsCount[eventId] = count;
    notifyListeners();
  }

  Future<void> toggleParticipation(BuildContext context, String eventId) async {
    _loading[eventId] = true;
    notifyListeners();

    try {
      int statusCode;
      final currentlyParticipating = isParticipating(eventId);

      if (!currentlyParticipating) {
        statusCode = await ApiService.participate(id: eventId);
      } else {
        statusCode = await ApiService.annulerParticipation(id: eventId);
      }

      // Accepter 200 (OK) et 201 (Created) comme succès
      if (statusCode == 200 || statusCode == 201) {
        // Inverser l'état de participation
        _participating[eventId] = !currentlyParticipating;

        // Ajuster le compteur de participants
        if (_participating[eventId]!) {
          _participantsCount[eventId] = (_participantsCount[eventId] ?? 0) + 1;
        } else {
          _participantsCount[eventId] = ((_participantsCount[eventId] ?? 1) - 1).clamp(0, 999999);
        }

        // Feedback utilisateur succès
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _participating[eventId]!
                    ? 'Participation enregistrée'
                    : 'Participation annulée',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else if (statusCode == 400) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Impossible de participer à un événement passé",
                style: TextStyle(color: Color(0xFF322F35)),
              ),
              backgroundColor: Color(0xFFFFC113),
              duration: Duration(seconds: 5),
            ),
          );
        }
      } else if (statusCode == 404) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Événement non trouvé",
                style: TextStyle(color: Color(0xFF322F35)),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else if (statusCode == 409) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Vous avez déjà participé à cet événement",
                style: TextStyle(color: Color(0xFF322F35)),
              ),
              backgroundColor: Color(0xFFFFC113),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Erreur inattendue (Code: $statusCode)",
                style: const TextStyle(color: Color(0xFF322F35)),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Gestion des exceptions (erreur réseau, timeout, etc.)
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Erreur de connexion: ${e.toString()}",
              style: const TextStyle(color: Color(0xFF322F35)),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      _loading[eventId] = false;
      notifyListeners();
    }
  }
}