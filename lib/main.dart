import 'package:SIRA/widgets/custom_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SIRA/screens/login_page.dart';
import 'package:SIRA/screens/bienvenu_page.dart';
import 'package:SIRA/screens/intro_page.dart';
import 'package:SIRA/screens/presentation.dart';
import 'package:SIRA/screens/objectif.dart';
import 'package:SIRA/screens/engagement.dart';
import 'package:SIRA/services/event_provider.dart';
import 'package:SIRA/services/auth_storage.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bool isLoggedIn = await AuthStorage.isLoggedIn();
  final String? token = await AuthStorage.getToken();
  final String? lastPath = await AuthStorage.getLastPath();
  final int? selectedTab = await AuthStorage.getSelectedTab();

  // ✅ Récupérer tous les états des tabs internes
  final Map<String, int?> pageTabsState = {
    'profile': await AuthStorage.getPageTab('profile'),
    'defi': await AuthStorage.getPageTab('defi'),
    'community': await AuthStorage.getPageTab('community'),
    'parcours': await AuthStorage.getPageTab('parcours'),
    // Ajoutez d'autres pages ici si nécessaire
  };

  Widget startScreen;

  if (isLoggedIn && token != null && token.isNotEmpty) {
    // ✅ L'utilisateur est connecté
    if (lastPath != null && lastPath.isNotEmpty) {
      // 🧭 Il a quitté sur une page spécifique → reprendre là
      startScreen = getScreenFromPath(lastPath, selectedTab, pageTabsState);
    } else {
      // 🚀 Pas de dernière page connue → aller à la page d'accueil avec les états sauvegardés
      startScreen = CustomTabBar(
        pageTabsState: pageTabsState,
      );
    }
  } else if (!isLoggedIn && token == null) {
    // 🟡 L'utilisateur n'est pas connecté → aller à la page de login
    startScreen = const LoginPage();
  } else {
    // 🔵 Nouvel utilisateur (n'a jamais ouvert l'app)
    startScreen = const IntroPage();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: MyApp(startScreen: startScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget startScreen;
  const MyApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIRA',
      theme: ThemeData(
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      navigatorObservers: [routeObserver],
      home: startScreen,
    );
  }
}

Widget getScreenFromPath(String path, int? selectedTab, Map<String, int?> pageTabsState) {
  switch (path) {
  // Pages d'onboarding/authentification (SANS CustomTabBar)
    case '/bienvenu':
      return const BienvenuPage();
    case '/presentation':
      return Presentation();
    case '/objectif':
      return ObjectifPage();
    case '/engagement':
      return EngagementPage();
    case '/intro':
      return const IntroPage();
    case '/login':
      return const LoginPage();

  // Pages principales (AVEC CustomTabBar et menu du bas)
    case '/community':
    case '/defi':
    case '/homePage':
    case '/profile':
    case '/recompense':
      return CustomTabBar(
        pageTabsState: pageTabsState,
      );
    case '/video':
    case '/podcast':
    case '/article':
    case '/mesdefis':
    case '/environnement':
    case '/education':
    case '/populaire_community':
    case '/mesPostes':
    case '/forum':
    case '/enregistrer':
      return CustomTabBar(
        pageTabsState: pageTabsState,
      );

    default:
      return CustomTabBar(
        pageTabsState: pageTabsState,
      );
  }
}