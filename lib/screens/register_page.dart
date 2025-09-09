import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SIRA/widgets/custom_button.dart';
import 'login_page.dart';
import '../widgets/custom_input.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  Future<void> register() async {
    final prefs = await SharedPreferences.getInstance();
    // Sauvegarder toutes les données
    await prefs.setString('email', emailController.text);
    await prefs.setString('password', passwordController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Compte créé avec succès")),
    );

    // Rediriger vers la page de connexion
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                "assets/images/logoSira2.png", // ton logo soleil
                height: 50,
              ),
            ),
            const SizedBox(height: 25),
            // Titre
            const Text(
              "S'inscrire",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Entrez votre email et votre mot de passe pour vous connecter",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 15),
            // Boutons sociaux
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Bouton Google
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFE4E5E7)),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: Image.asset(
                    "assets/images/google.png",
                    width: 20,
                    height: 20,
                  ),
                  label: const Text(
                    "Continuer avec Google",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {
                    // TODO: action Google login
                  },
                ),
                const SizedBox(height: 22),

                // Ligne avec les autres réseaux
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton("assets/images/facebook.png"),
                    const SizedBox(width: 16),
                    _socialButton("assets/images/tiktok.png"),
                    const SizedBox(width: 16),
                    _socialButton("assets/images/instagram.png"),
                  ],
                ),
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
              ],
            ),
            const SizedBox(height: 18),
            CustomButton(
              onPressed: register,
              text: "S'inscrire",
            ),
            const SizedBox(height: 18),
            // Lien vers inscription
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Vous avez un compte ? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    "Se connecter",
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
