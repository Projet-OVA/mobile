import 'package:flutter/material.dart';
import 'tabs/parcours.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // AuthStorage.saveLastPath('/homePage');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Parcours(),
    );
  }
}
