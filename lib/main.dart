import 'package:flutter/material.dart';
import 'widgets/custom_tab_bar.dart';
import 'screens/intro_page.dart';
import 'screens/presentation.dart';
import 'screens/objectif.dart';
import 'screens/engagement.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      title: 'SIRA',
      //primarySwatch: Colors.orange,
      //home: IntroPage(),
      home: CustomTabBar(),
    );
  }
}

/// Widget pour afficher toutes les pages d’intro avant login
class IntroSequence extends StatefulWidget {
  const IntroSequence({super.key});

  @override
  State<IntroSequence> createState() => _IntroSequenceState();
}

class _IntroSequenceState extends State<IntroSequence> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = const [
    IntroPage(),
    Presentation(),
    ObjectifPage(),
    EngagementPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        children: _pages,
      ),
    );
  }
}
