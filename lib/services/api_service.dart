import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://sira-backendv1.onrender.com/api/auth";

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
    final url = Uri.parse("$baseUrl/register");

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
    final url = Uri.parse("$baseUrl/login");

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
    final url = Uri.parse("$baseUrl/logout");
    return await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
  }
/// d'autres endpoints ici

}
