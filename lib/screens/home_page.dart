import 'package:flutter/material.dart';
import '../widgets/action.dart';
import '../widgets/filter_bar.dart';
import '../widgets/my_carousel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()),);
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    // Navigue vers la page Login en remplaçant l'écran actuel
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: const [
                  ActionDart(),
                  SizedBox(height: 16),
                  FilterBar(),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Comprendre la citoyenneté citizen',
                      style: TextStyle(color: Color(0xFF1C1C1C)),
                    ),
                  ),
                  SizedBox(height: 19),
                  MyCarousel(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => logout(context),
                child: const Text("Se déconnecter"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}