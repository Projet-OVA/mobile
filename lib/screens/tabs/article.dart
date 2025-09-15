import 'package:flutter/material.dart';

void main() {
  runApp(const Article());
}

class Article extends StatelessWidget {
  const Article({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CenteredTextPage(),
    );
  }
}

class CenteredTextPage extends StatelessWidget {
  const CenteredTextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Articles',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
