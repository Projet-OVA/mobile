// services/quiz_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/quiz_model.dart';

class QuizService {
  static const String baseUrl = "https://sira-backendv1.onrender.com/api";

  /// Récupérer un quiz avec ses questions
  static Future<QuizDetail> getQuiz(String quizId) async {
    final url = Uri.parse("$baseUrl/quiz/$quizId");

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
        return QuizDetail.fromJson(data['data']);
      } else {
        throw Exception("Erreur: ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur récupération quiz: $e");
      throw Exception("Erreur: $e");
    }
  }

  /// Soumettre les réponses d'un quiz
  static Future<QuizResult> submitQuiz(QuizSubmission submission) async {
    final url = Uri.parse("$baseUrl/Quiz/submit");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception("Token d'authentification manquant.");
      }

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(submission.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return QuizResult.fromJson(data['data']);
      } else {
        throw Exception("Erreur: ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur soumission quiz: $e");
      throw Exception("Erreur: $e");
    }
  }
}