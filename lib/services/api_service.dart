import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

}