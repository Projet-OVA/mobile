import 'package:flutter/material.dart';
import 'intro_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const IntroPage()),
            );
          },
          child: const Image(
            image: AssetImage('assets/images/logoSira.png'),
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
