import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SIRA/screens/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/intro_page.dart';
import 'screens/presentation.dart';
import 'screens/objectif.dart';
import 'screens/engagement.dart';
import 'package:SIRA/services/event_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // obligatoire pour SharedPreferences avant runApp
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => EventProvider()),
          ],
      child: MyApp(initialRoute: isLoggedIn ? "login" : "intro")
      ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIRA',
      theme: ThemeData(
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      home: initialRoute == "login" ? const LoginPage() : const IntroSequence(),
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

  final List<Widget> _pages = [
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
