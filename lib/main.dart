import 'package:flutter/material.dart';
import 'widgets/custom_tab_bar.dart';
import 'screens/intro_page.dart';
import 'screens/presentation.dart';
import 'screens/objectif.dart';
import 'screens/engagement.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIRA',
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
