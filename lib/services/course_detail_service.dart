
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/course_detail_model.dart';
import '../data/models/course_model.dart';

class CourseDetailService {
  static const String baseUrl = "https://sira-backendv1.onrender.com/api";

  /// Récupérer les détails d'un cours par ID
  static Future<CourseDetail> getCourseDetail(String courseId) async {
    final url = Uri.parse("$baseUrl/course/$courseId");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception(
            "Token d'authentification manquant. Veuillez vous reconnecter.");
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
        return CourseDetail.fromJson(data);
      } else {
        throw Exception(
          "Erreur serveur: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e, stackTrace) {
      print("Erreur lors de la récupération du cours: $e");
      print("Stacktrace: $stackTrace");
      throw Exception("Erreur lors de la récupération du cours: $e");
    }
  }

  /// Récupérer les cours de la même catégorie
  static Future<List<Course>> getCoursesByCategory(String category, String excludeId) async {
    final url = Uri.parse("$baseUrl/course");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception(
            "Token d'authentification manquant. Veuillez vous reconnecter.");
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
        final courses = (data['courses'] as List)
            .map((course) => Course.fromJson(course))
            .where((course) => 
                course.category == category && course.id != excludeId)
            .toList();
        
        return courses;
      } else {
        throw Exception(
          "Erreur serveur: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e, stackTrace) {
      print("Erreur lors de la récupération des cours similaires: $e");
      print("Stacktrace: $stackTrace");
      throw Exception("Erreur lors de la récupération des cours similaires: $e");
    }
  }
}