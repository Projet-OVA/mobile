import 'package:flutter/material.dart';
import '../../widgets/action.dart';
import '../../widgets/filter_bar.dart';
import '../../widgets/my_carousel.dart';

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
        // Remplace le Column par un ListView pour un contenu défilant.
        // Cela résoudra le problème de débordement.
        child: ListView( 
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
            SizedBox(height: 19),
            MyCarousel(),
          ],
        ),
      ),
    );
  }
}