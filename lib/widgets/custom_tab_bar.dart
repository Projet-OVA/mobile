import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import '../screens/profile_page.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _labels = ['Profil', 'Accueil', 'Défis', 'Communauté'];
  final List<IconData?> _icons = [null, Icons.window_rounded, Icons.flag, Icons.maps_ugc_sharp];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {}); // pour mettre à jour le border bottom
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: const [
          ProfilePage(),
          HomePage(),
          Center(child: Text('Défis')),
          Center(child: Text('Communauté')),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_labels.length, (index) {
            final bool isActive = _tabController.index == index;
            return GestureDetector(
              onTap: () {
                _tabController.animateTo(index);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icône ou photo profil
                  if (index == 0)
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    )
                  else
                    Icon(
                      _icons[index],
                      color: isActive ? Colors.black : Color(0xFF4D4D4D),
                    ),
                  const SizedBox(height: 4),
                  // Nom de l'onglet
                  Text(
                    _labels[index],
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive ? Colors.black : Color(0xFF4D4D4D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Border bottom actif
                  Container(
                    height: 4,
                    width: 100,
                    decoration: BoxDecoration(
                      color: isActive ? Color(0xFFFFC113) : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
