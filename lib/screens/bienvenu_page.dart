import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/custom_tab_bar.dart'; // ton tab bar

class BienvenuPage extends StatefulWidget {
  const BienvenuPage({super.key});

  @override
  State<BienvenuPage> createState() => _BienvenuPageState();
}

class _BienvenuPageState extends State<BienvenuPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool showFirstText = true;

  @override
  void initState() {
    super.initState();

    // Animation fade in/out
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    // Après 5s → change le texte et rejoue l’animation
    Timer(const Duration(seconds: 5), () {
      setState(() {
        showFirstText = false;
      });
      _controller.reset();
      _controller.forward();

      // Encore 10s → redirection vers le CustomTabBar
      Timer(const Duration(seconds: 10), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CustomTabBar()),
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC113), // jaune
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0), // 👈 padding ajouté
            child: showFirstText
                ? const Text(
              "Bienvenue sur Sira",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )
                : Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "« ...Réveiller le bâtisseur de Nations qui dort en chacun de vous. »",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Cheikh Anta Diop",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
