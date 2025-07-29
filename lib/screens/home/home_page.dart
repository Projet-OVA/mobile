import 'package:flutter/material.dart';
import '../../widgets/action.dart';
import '../../widgets/filter_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ActionDart(),
            SizedBox(height: 16),
            FilterBar(),
            SizedBox(height: 16),
            Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Comprendre la citoyenneté',
              style: TextStyle(color: Color(0xFF1C1C1C)),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
