import 'package:SIRA/screens/login_page.dart';
import 'package:SIRA/widgets/custom_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Tes imports pour les pages
import 'screens/intro_page.dart';
import 'screens/presentation.dart';
import 'screens/objectif.dart';
import 'screens/engagement.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIRA',
      theme: ThemeData(
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      home: const CustomTabBar(), // toujours démarrer par l’intro
    );
  }
}

/// Widget pour afficher toutes les pages d’intro sans restriction
class IntroSequence extends StatefulWidget {
  const IntroSequence({super.key});

  @override
  State<IntroSequence> createState() => _IntroSequenceState();
}

class _IntroSequenceState extends State<IntroSequence> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    const IntroPage(),
     Presentation(),
    const ObjectifPage(),
    const EngagementPage(),
    // 👉 tu peux même rajouter LoginPage si tu veux qu’elle fasse partie du flow
    // const LoginPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const BouncingScrollPhysics(), // permet de scroller librement
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        children: _pages,
      ),
    );
  }
}