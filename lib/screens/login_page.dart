import 'package:SIRA/screens/bienvenu_page.dart';
import 'package:SIRA/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'register_page.dart';
import '../widgets/custom_input.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'package:SIRA/services/auth_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  Future<void> login() async {
    try {
      final response = await ApiService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("✅ Login response complète: $data");

        // 🔐 1. Sauvegarde du token
        final token = data['data']?['accessToken'] ?? data['token'];
        if (token != null) {
          await AuthStorage.saveToken(token);
          print("🔑 Token sauvegardé via AuthStorage: $token");
        } else {
          print("⚠️ Aucun token trouvé dans la réponse");
        }

        // ✅ 2. Marquer l’utilisateur comme connecté
        await AuthStorage.setLoggedIn(true);
        print("👤 Statut de connexion sauvegardé via AuthStorage");

        // 👤 3. Sauvegarder l’ID utilisateur
        await ApiService.saveUserIdFromLogin(data);

        // 🧭 4. Sauvegarder la page actuelle
        await AuthStorage.saveLastPath('/bienvenu');

        // 🚀 5. Rediriger
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BienvenuPage()),
        );
      } else {
        print("❌ Erreur login: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("L'email ou le mot de passe est incorrect"),
            backgroundColor: Color(0xFFFFC113),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print("🚨 Erreur login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur de connexion: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo en haut
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                "assets/images/logoSira2.png",
                height: 50,
              ),
            ),
            const SizedBox(height: 25),

            // Titre
            const Text(
              "Se connecter",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Connectez vous directement avec",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 15),

            // Boutons sociaux
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialButton("assets/images/google.png"),
                const SizedBox(width: 16),
                _socialButton("assets/images/facebook.png"),
                const SizedBox(width: 16),
                _socialButton("assets/images/tiktok.png"),
                const SizedBox(width: 16),
                _socialButton("assets/images/instagram.png"),
              ],
            ),
            const SizedBox(height: 22),

            const Center(child: Text("Ou", style: TextStyle(color: Colors.grey))),

            const SizedBox(height: 22),

            // Champ Email
            CustomInput(
              controller: emailController,
              label: "Email",
              placeholder: "Loisbecket@gmail.com",
            ),
            const SizedBox(height: 16),
            // Champ Mot de passe
            CustomInput(
              controller: passwordController,
              obscureText: true,
              placeholder: "*******",
              label: "Password",
            ),
            const SizedBox(height: 12),
            // Options mot de passe oublié + se souvenir
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (val) {
                        setState(() {
                          rememberMe = val ?? false;
                        });
                      },
                    ),
                    const Text("Se souvenir de moi"),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Mot de passe oublié ?",
                    style: TextStyle(color: Color(0xEEE6AE11)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Bouton se connecter
            CustomButton(
              onPressed: login,
              text: "Se connecter",
            ),
            const SizedBox(height: 18),
            // Lien vers inscription
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Vous n’avez pas de compte ? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    "S’inscrire",
                    style: TextStyle(
                      color: Color(0xFFFFC113),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // widget bouton social
  Widget _socialButton(String assetPath) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xEEEFF0F6)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Image.asset(assetPath, height: 24),
      ),
    );
  }
}
