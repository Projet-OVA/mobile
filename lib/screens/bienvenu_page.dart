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
    Timer(const Duration(seconds: 05), () {
      setState(() {
        showFirstText = false;
      });
      _controller.reset();
      _controller.forward();

      // Encore 3s → redirection vers le CustomTabBar
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
          child: Text(
            showFirstText
                ? "Bienvenue sur Sira"
                : "« ...Réveiller le bâtisseur de Nations qui dort en chacun de vous. »",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
