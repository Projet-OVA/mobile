import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SIRA/models/badge_progress.dart';

class ApiService {
  static const String baseUrl = "https://sira-backendv1.onrender.com/api";

  /// Endpoint d'inscription
  static Future<http.Response> register({
    required String nom,
    required String prenom,
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
    String role = "CITIZEN",
  }) async {
    final url = Uri.parse("$baseUrl/auth/register");

    final body = {
      "nom": nom,
      "prenom": prenom,
      "username": username,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
      "role": role,
    };
    print("Envoi register: ${jsonEncode(body)}");

    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
  }

  /// Login
  static Future<http.Response> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/auth/login");

    final body = {
      "email": email,
      "password": password,
    };
    print("Envoi login: ${jsonEncode(body)}");
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
  }
// Méthode 1: Sauvegarder l'ID utilisateur après login
  static Future<void> saveUserIdFromLogin(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    String? userId;

    // Essayer différentes structures de réponse
    if (data['data']?['user']?['id'] != null) {
      userId = data['data']['user']['id'].toString();
    } else if (data['data']?['id'] != null) {
      userId = data['data']['id'].toString();
    } else if (data['user']?['id'] != null) {
      userId = data['user']['id'].toString();
    } else if (data['id'] != null) {
      userId = data['id'].toString();
    }

    if (userId != null) {
      await prefs.setString('user_id', userId);
      print('User ID sauvegardé: $userId');
    } else {
      print('User ID non trouvé dans la réponse');
      print('Structure reçue: ${data.keys}');
    }
  }

// Méthode 2: Récupérer l'ID utilisateur sauvegardé
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

// Méthode 3: Récupérer un utilisateur par ID
  static Future<Map<String, dynamic>> getUserById({required String id}) async {
    final url = Uri.parse("$baseUrl/auth/users/$id");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception("Token d'authentification manquant. Veuillez vous reconnecter.");
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map<String, dynamic>) {
          if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
            return data['data'] as Map<String, dynamic>;
          }
          return data;
        }

        throw Exception("Format de réponse invalide");
      } else {
        throw Exception("Erreur serveur: ${response.statusCode} - ${response.body}");
      }
    } catch (e, stackTrace) {
      print("Erreur lors de la récupération de l'utilisateur: $e");
      print("Stacktrace: $stackTrace");
      throw Exception("Erreur lors de la récupération de l'utilisateur: $e");
    }
  }

// Méthode 4: Récupérer l'utilisateur connecté
  static Future<Map<String, dynamic>> getCurrentUser() async {
    final userId = await getUserId();

    if (userId == null) {
      throw Exception("Aucun utilisateur connecté trouvé");
    }

    print("Utilisateur connecté ID: $userId");
    return getUserById(id: userId);
  }
  // Endpoint logout
  static Future<http.Response> logout(String token) async {
    final url = Uri.parse("$baseUrl/auth/logout");
    return await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
  }

  /// Endpoint évènement
  static Future<http.Response> add_defi({
    required String eventName,
    required String description,
    required String eventDate,
    required String location,
    File? image,
  }) async {
    final url = Uri.parse("$baseUrl/event-proposals");
    final request = http.MultipartRequest('POST', url);
    try {
      // Récupérer le token d'authentification
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception("Token d'authentification manquant. Veuillez vous reconnecter.");
      }
      // Ajouter l'Authorization header
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      // Champs texte
      request.fields['eventName'] = eventName;
      request.fields['description'] = description;
      request.fields['eventDate'] = eventDate;
      request.fields['location'] = location;
      // Fichier image
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );
      }
      // Envoyer la requête
      final streamedResponse = await request.send();

      // Convertir en http.Response (plus pratique pour lire body)
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response; // succès
      } else {
        throw Exception(
            "Erreur serveur: ${response.statusCode} - ${response.body}");
      }
    } catch (e, stackTrace) {
      print(" Erreur lors de l'envoi du défi: $e");
      print(" Stacktrace: $stackTrace");
      throw Exception("Erreur lors de l'envoi du défi: $e");
    }
  }
/// Récupèré les évènements
  static Future<http.Response> getDefi() async {
    final url = Uri.parse("$baseUrl/events/organized/me");

    try {
      // Récupérer le token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception("Token d'authentification manquant. Veuillez vous reconnecter.");
      }

      // Faire la requête GET
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return response; // succès => tu récupères response.body
      } else {
        throw Exception(
          "Erreur serveur: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e, stackTrace) {
      print("Erreur lors de la récupération des événements: $e");
      print("Stacktrace: $stackTrace");
      throw Exception("Erreur lors de la récupération des événements: $e");
    }
  }
  static Future<int> getMyEventsCount() async {
    final response = await getDefi();
    final decoded = jsonDecode(response.body);
    if (decoded['data'] != null && decoded['data'] is List) {
      final events = decoded['data'] as List<dynamic>;
      return events.length; // nombre total d'événements
    }
    return 0;
  }

  static Future<List<dynamic>> getEvents() async {
    final url = Uri.parse("$baseUrl/events");

    try {
      // Récupérer le token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception("Token d'authentification manquant. Veuillez vous reconnecter.");
      }
      // Faire la requête GET
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Si ton API renvoie {"data": [...]}
        return data['data'] as List<dynamic>;
      } else {
        throw Exception(
          "Erreur serveur: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e, stackTrace) {
      print("Erreur lors de la récupération des événements: $e");
      print("Stacktrace: $stackTrace");
      throw Exception("Erreur lors de la récupération des événements: $e");
    }
  }
  static Future<Map<String, dynamic>> getEventById({required String id}) async {
    final url = Uri.parse("$baseUrl/events/$id");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception("Token d'authentification manquant. Veuillez vous reconnecter.");
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Vérifier si les données sont dans une clé 'data' ou directement à la racine
        if (data is Map<String, dynamic>) {
          // Si l'API retourne { "data": { ... } }
          if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
            return data['data'] as Map<String, dynamic>;
          }
          // Si l'API retourne directement { "id": ..., "eventName": ... }
          return data;
        }

        throw Exception("Format de réponse invalide");
      } else {
        throw Exception("Erreur serveur: ${response.statusCode} - ${response.body}");
      }
    } catch (e, stackTrace) {
      print("Erreur lors de la récupération de l'événement: $e");
      print("Stacktrace: $stackTrace");
      throw Exception("Erreur lors de la récupération de l'événement: $e");
    }
  }

  static Future<List<dynamic>> getEventsParticipateMe() async {
    final url = Uri.parse("$baseUrl/events/participated/me");

    try {
      // Récupérer le token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception("Token d'authentification manquant. Veuillez vous reconnecter.");
      }

      // Faire la requête GET
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Si ton API renvoie {"data": [...]}
        return data['data'] as List<dynamic>;
      } else {
        throw Exception(
          "Erreur serveur: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e, stackTrace) {
      print("Erreur lors de la récupération des événements: $e");
      print("Stacktrace: $stackTrace");
      throw Exception("Erreur lors de la récupération des événements: $e");
    }
  }
  static Future<int> participate({required String id}) async {
    final url = Uri.parse("$baseUrl/events/$id/participate");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("Participation enregistrée avec succès");
      } else if (response.statusCode == 400) {
        print("Impossible de participer: ${response.body}");
      } else if (response.statusCode == 404) {
        print("Événement non trouvé: ${response.body}");
      } else if (response.statusCode == 409) {
        print("Vous participez déjà à cet événement: ${response.body}");
      } else {
        print("Erreur inattendue: ${response.statusCode} - ${response.body}");
      }

      return response.statusCode; // retourne le code pour le widget
    } catch (e) {
      print("Erreur lors de la participation: $e");
      return 0; // code spécial pour erreur réseau
    }
  }
  static Future<int> annulerParticipation({required String id}) async {
    final url = Uri.parse("$baseUrl/events/$id/participate");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("Participation annulée avec succès");
      } else if (response.statusCode == 400) {
        print("Impossible d'annuler: ${response.body}");
      } else if (response.statusCode == 404) {
        print("Événement non trouvé: ${response.body}");
      } else {
        print("Erreur inattendue: ${response.statusCode} - ${response.body}");
      }

      return response.statusCode;
    } catch (e) {
      print("Erreur lors de l'annulation: $e");
      return 0;
    }
  }
  static Future<List<dynamic>> getMyBadges() async {
    final url = Uri.parse("$baseUrl/badges/my-badges");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception("Token d'authentification manquant. Veuillez vous reconnecter.");
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Ici on décode et on retourne directement la liste
        final decoded = jsonDecode(response.body);
        // selon ton API, ça peut être decoded["data"] ou directement decoded
        return decoded is List ? decoded : (decoded["data"] ?? []);
      } else {
        throw Exception(
          "Erreur serveur: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e, stackTrace) {
      print("Erreur lors de la récupération des badges: $e");
      print("Stacktrace: $stackTrace");
      throw Exception("Erreur lors de la récupération des badges: $e");
    }
  }

  /// Récupère l'historique des quiz du user
  static Future<List<Map<String, dynamic>>> getUserQuizHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("accessToken");

  if (token == null) {
  throw Exception("Token manquant. Connectez-vous à nouveau.");
  }

  final url = Uri.parse("$baseUrl/quiz/history");

  final response = await http.get(
  url,
  headers: {
  'Authorization': 'Bearer $token',
  'Accept': 'application/json',
  },
  );

  if (response.statusCode == 200) {
  final decoded = jsonDecode(response.body);
  final List data = decoded["data"] ?? [];
  return List<Map<String, dynamic>>.from(data);
  } else {
  throw Exception(
  "Erreur serveur: ${response.statusCode} - ${response.body}",
  );
  }
  }

  /// Statistiques du user : total quiz participés et réussis
  static Future<Map<String, int>> getUserQuizStats({int successThreshold = 50}) async {
    final history = await getUserQuizHistory();

    final int totalParticipated = history.length;
    final int totalSuccess = history.where((quiz) {
      return (quiz["scorePercentage"] ?? 0) >= successThreshold;
    }).length;

    return {
      "participated": totalParticipated,
      "success": totalSuccess,
    };
  }
  Future<List<BadgeProgress>> fetchBadgeProgress() async {
    final progressResponse = await http.get(Uri.parse('$baseUrl/progression'));
    final progressData = json.decode(progressResponse.body);

    final badgeResponse = await http.get(Uri.parse('$baseUrl/badges/my-badges'));
    final badgeData = json.decode(badgeResponse.body);

    List<BadgeProgress> result = [];

    for (var badge in badgeData) {
      String name = badge['name'];
      String image = badge['image'];
      int progress = progressData[name] ?? 0;

      result.add(BadgeProgress(
        title: name,
        progress: progress,
        imagePath: image,
      ));
    }

    return result;
  }

}