import 'package:flutter/material.dart';
import '../screens/home/home_page.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
          HomePage(),
          Center(child: Text('Recherche')),
          Center(child: Text('Statistiques')),
          Center(child: Text('Profil')),
          Center(child: Text('Messages')),
        ],
      ),
      bottomNavigationBar: Material(
        // color: Theme.of(context).primaryColor,
        child: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.grid_view_outlined)),
            Tab(icon: Icon(Icons.show_chart)),
            Tab(icon: Icon(Icons.diversity_3_sharp )),
            Tab(icon: Icon(Icons.sms_rounded )),
          ],
          labelColor: Color(0xFF000000),
          unselectedLabelColor: Color(0xFF4D4D4D),
          indicatorColor: Colors.transparent,
        ),
      ),
    );
  }
}
