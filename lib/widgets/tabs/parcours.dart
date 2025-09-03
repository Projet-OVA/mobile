import 'package:flutter/material.dart';
import '../../widgets/action.dart';
import '../../widgets/filter_bar.dart';
import '../../widgets/my_carousel.dart';
import '../../widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/login_page.dart';

class Parcours extends StatefulWidget {
  const Parcours({super.key});

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()),);
  }

  @override
  State<Parcours> createState() => _ParcoursState();
}

class _ParcoursState extends State<Parcours> {

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    // Navigue vers la page Login
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
            CustomButton(
              text: "Se déconnecter",
              onPressed: () => logout(context),
            )
          ],
        ),
      ),
    );
  }
}