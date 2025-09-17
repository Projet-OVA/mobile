import 'package:flutter/material.dart';
import 'package:SIRA/widgets/custom_button.dart';
import 'login_page.dart';
import '../widgets/custom_input.dart';
import '../services/api_service.dart';
import '../services/register_storage.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final String role = "CITIZEN";
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    // Récupère le username stocké
    final storedUsername = await RegisterStorage.getUsername();
    if (storedUsername != null && storedUsername.isNotEmpty) {
      usernameController.text = storedUsername;
    }
  }

  Future<void> register() async {
    try {
      final response = await ApiService.register(
        nom: nomController.text.trim(),
        prenom: prenomController.text.trim(),
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
        role: role,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Compte créé avec succès ✅")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de connexion: $e")),
      );
    }
  }

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
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

            // Champ nom
            CustomInput(
              controller: nomController,
              label: "Nom",
              placeholder: "Lois",
            ),
            const SizedBox(height: 12),
            // Champ prenom
            CustomInput(
              controller: prenomController,
              label: "Prénom",
              placeholder: "Becket",
            ),
            const SizedBox(height: 12),
            //champ username
            CustomInput(
              controller: usernameController,
              label: "Surnom",
              placeholder: "Dev",
            ),
            const SizedBox(height: 12),
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
            // Champ phone
            CustomInput(
              controller: phoneNumberController,
              label: "Téléphone",
              placeholder: "77*******",
            ),
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
