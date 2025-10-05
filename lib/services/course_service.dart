import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/course_model.dart';

class CourseService {
  static const String baseUrl = "https://sira-backendv1.onrender.com/api";

  /// Récupérer tous les parcours
  static Future<CourseResponse> getCourses() async {
    final url = Uri.parse("$baseUrl/course");

    try {
      // Récupérer le token d'authentification
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception(
            "Token d'authentification manquant. Veuillez vous reconnecter.");
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
        return CourseResponse.fromJson(data);
      } else {
        throw Exception(
          "Erreur serveur: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e, stackTrace) {
      print("Erreur lors de la récupération des parcours: $e");
      print("Stacktrace: $stackTrace");
      throw Exception("Erreur lors de la récupération des parcours: $e");
    }
  }

  /// Récupérer les parcours par catégorie
  static Future<Map<String, List<Course>>> getCoursesByCategory() async {
    try {
      final courseResponse = await getCourses();
      final courses = courseResponse.courses;

      // Grouper les parcours par catégorie
      final Map<String, List<Course>> coursesByCategory = {};

      for (var course in courses) {
        final categoryName = course.getCategoryName();
        if (!coursesByCategory.containsKey(categoryName)) {
          coursesByCategory[categoryName] = [];
        }
        coursesByCategory[categoryName]!.add(course);
      }

      return coursesByCategory;
    } catch (e) {
      print("Erreur lors du groupement des parcours: $e");
      rethrow;
    }
  }

  /// Récupérer un parcours par ID
  static Future<Course> getCourseById(String courseId) async {
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
        return Course.fromJson(data);
      } else {
        throw Exception(
          "Erreur serveur: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e, stackTrace) {
      print("Erreur lors de la récupération du parcours: $e");
      print("Stacktrace: $stackTrace");
      throw Exception("Erreur lors de la récupération du parcours: $e");
    }
  }
}