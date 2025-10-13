import 'package:SIRA/screens/community_page.dart';
import 'package:SIRA/screens/defi_page.dart';
import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import '../screens/profile_page.dart';
import '../services/auth_storage.dart';

class CustomTabBar extends StatefulWidget {
  final Map<String, int?>? pageTabsState; // onglets internes sauvegardés

  const CustomTabBar({super.key, this.pageTabsState});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> with WidgetsBindingObserver {
  int _currentIndex = 1; // Home par défaut
  Map<String, int?> _pageTabsState = {};

  final List<String> _labels = ['Profil', 'Parcours', 'Défis', 'Communauté'];
  final List<IconData?> _icons = [
    null,
    Icons.window_rounded,
    Icons.flag_outlined,
    Icons.maps_ugc_sharp
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageTabsState = widget.pageTabsState ?? {};
    _loadSavedTab();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Sauvegarde automatique quand l'app passe en arrière-plan
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      AuthStorage.saveSelectedTab(_currentIndex);
    }
  }

  // Chargement du dernier onglet ouvert
  Future<void> _loadSavedTab() async {
    final savedIndex = await AuthStorage.getSelectedTab();
    setState(() {
      _currentIndex = savedIndex ?? 1; // Home par défaut
    });
  }

  // Changement d'onglet
  Future<void> _onTabTapped(int index) async {
    setState(() {
      _currentIndex = index;
    });
    await AuthStorage.saveSelectedTab(index);
  }

  // Pages principales
  List<Widget> get _pages => [
    ProfilePage(initialTabIndex: _pageTabsState['profile']),
    const HomePage(),
    DefiPage(initialTabIndex: _pageTabsState['defi']),
    CommunityPage(initialTabIndex: _pageTabsState['community']),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          child: Row(
            children: List.generate(_labels.length, (index) {
              final bool isActive = _currentIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onTabTapped(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 6),
                      if (index == 0)
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: const AssetImage('assets/images/profile.png'),
                        )
                      else
                        Icon(
                          _icons[index],
                          color: isActive ? Colors.black : const Color(0xFF4D4D4D),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        _labels[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: isActive ? Colors.black : const Color(0xFF4D4D4D),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 4,
                        width: MediaQuery.of(context).size.width / _labels.length * 0.6,
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFFFFC113) : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
