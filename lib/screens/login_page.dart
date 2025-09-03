import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'register_page.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString("email");
    final savedPassword = prefs.getString("password");

    if (emailController.text == savedEmail &&
        passwordController.text == savedPassword) {
      await prefs.setBool("isLoggedIn", true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email ou mot de passe incorrect")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomInput(
              controller: emailController,
              label: "Email",
              placeholder: "",
            ),
            const SizedBox(height: 12),
            CustomInput(
              controller: passwordController,
              label: "Mot de passe",
              placeholder: "Entrez votre mot de passe",
              obscureText: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Se connecter",
              onPressed: login, // ✅ appel direct
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: "S'inscrire",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
