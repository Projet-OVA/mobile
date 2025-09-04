import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/custom_tab_bar.dart';
import 'screens/login_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool("isLoggedIn") ?? false;
    await Future.delayed(const Duration(seconds: 2)); // petit délai Splash
    setState(() {
      _isLoggedIn = loggedIn;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CustomTabBar(),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIRA',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _isLoggedIn ? const CustomTabBar() : const LoginPage(),
    );
  }
}