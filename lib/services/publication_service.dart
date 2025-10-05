
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/publication_model.dart';

class PublicationService {
  static const String baseUrl = "https://sira-backendv1.onrender.com/api";

  /// Récupérer toutes les publications
  static Future<List<Publication>> getPublications() async {
    final url = Uri.parse("$baseUrl/publication");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception("Token d'authentification manquant.");
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final publications = (data['data'] as List)
            .map((pub) => Publication.fromJson(pub))
            .toList();
        return publications;
      } else {
        throw Exception("Erreur: ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur récupération publications: $e");
      throw Exception("Erreur: $e");
    }
  }

  /// Récupérer les publications par type
  static Future<List<Publication>> getPublicationsByType(String type) async {
    try {
      final allPublications = await getPublications();
      return allPublications
          .where((pub) => pub.publicationType == type)
          .toList();
    } catch (e) {
      print("Erreur filtrage publications: $e");
      throw Exception("Erreur: $e");
    }
  }

  /// Récupérer les vidéos (MEDIA avec VIDEO)
  static Future<List<Publication>> getVideos() async {
    try {
      final allPublications = await getPublications();
      return allPublications
          .where((pub) => pub.isVideo())
          .toList();
    } catch (e) {
      print("Erreur récupération vidéos: $e");
      throw Exception("Erreur: $e");
    }
  }

  /// Récupérer les articles (TEXT)
  static Future<List<Publication>> getArticles() async {
    return getPublicationsByType('TEXT');
  }

  /// Récupérer les podcasts
  static Future<List<Publication>> getPodcasts() async {
    return getPublicationsByType('PODCAST');
  }
}