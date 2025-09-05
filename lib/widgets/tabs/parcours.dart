import 'package:flutter/material.dart';
import '../../widgets/action.dart';
import '../../widgets/filter_bar.dart';
import '../../widgets/my_carousel.dart';

class Parcours extends StatefulWidget {
  const Parcours({super.key});

  @override
  State<Parcours> createState() => _ParcoursState();
}

class _ParcoursState extends State<Parcours> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: const [
                  ActionDart(),
                  SizedBox(height: 16),
                  FilterBar(),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Comprendre la citoyenneté citizen',
                      style: TextStyle(color: Color(0xFF1C1C1C)),
                    ),
                  ),
                  SizedBox(height: 19),
                  MyCarousel(),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Comprendre la citoyenneté citizen',
                      style: TextStyle(color: Color(0xFF1C1C1C)),
                    ),
                  ),
                  SizedBox(height: 19),
                  MyCarousel(),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Comprendre la citoyenneté citizen',
                      style: TextStyle(color: Color(0xFF1C1C1C)),
                    ),
                  ),
                  SizedBox(height: 19),
                  MyCarousel(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}