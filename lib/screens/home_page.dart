import 'package:flutter/material.dart';
import '../widgets/tabs/parcours.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Parcours(),
    );
  }
}
