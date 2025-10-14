import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SIRA/widgets/custom_tab_bar.dart';
import 'package:SIRA/screens/login_page.dart';
import 'package:SIRA/screens/bienvenu_page.dart';
import 'package:SIRA/screens/intro_page.dart';
import 'package:SIRA/screens/presentation.dart';
import 'package:SIRA/screens/objectif.dart';
import 'package:SIRA/screens/engagement.dart';
import 'package:SIRA/services/event_provider.dart';
import 'package:SIRA/services/auth_storage.dart';
import 'package:SIRA/services/api_service.dart';
import 'package:SIRA/widgets/tabs/quiz/question.dart';
import 'package:SIRA/widgets/tabs/quiz/quiz_result_screen.dart';
import 'package:SIRA/services/http_interceptor.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bool isLoggedIn = await AuthStorage.isLoggedIn();
  final String? token = await AuthStorage.getToken();
  final String? lastPath = await AuthStorage.getLastPath();
  final int? selectedTab = await AuthStorage.getSelectedTab();

  // ✅ Récupération des onglets internes
  final Map<String, int?> pageTabsState = {
    'profile': await AuthStorage.getPageTab('profile'),
    'defi': await AuthStorage.getPageTab('defi'),
    'community': await AuthStorage.getPageTab('community'),
    'parcours': await AuthStorage.getPageTab('parcours'),
  };

  // ✅ Récupération de la progression du quiz
  final Map<String, dynamic>? quizProgress = await AuthStorage.getQuizProgress();

  // Debug logs
  print('🔍 isLoggedIn: $isLoggedIn');
  print('🔍 token: ${token != null ? "exists" : "null"}');
  print('🔍 lastPath: $lastPath');
  print('🔍 quizProgress: $quizProgress');

  Widget startScreen;

  // ✅ Vérification proactive de la validité du token
  if (isLoggedIn && token != null && token.isNotEmpty) {
    print('🔐 Vérification de la validité du token...');

    bool tokenIsValid = await _validateToken();

    if (tokenIsValid) {
      print('✅ Token valide, navigation vers lastPath ou home');
      if (lastPath != null && lastPath.isNotEmpty) {
        print('🔍 Navigating to: $lastPath');
        startScreen = getScreenFromPath(lastPath, selectedTab, pageTabsState, quizProgress);
      } else {
        startScreen = CustomTabBar(pageTabsState: pageTabsState);
      }
    } else {
      print('❌ Token invalide ou expiré, redirection vers login');
      // Nettoyer les données si le token est invalide
      await AuthStorage.clearAll();
      startScreen = const LoginPage();
    }
  } else if (!isLoggedIn && token == null) {
    startScreen = const LoginPage();
  } else {
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

/// ✅ Valide le token en faisant un appel API simple
Future<bool> _validateToken() async {
  try {
    // Tenter de récupérer l'utilisateur courant
    await ApiService.getCurrentUser();
    return true; // Token valide
  } catch (e) {
    print('⚠️ Erreur de validation du token: $e');
    return false; // Token invalide
  }
}

class MyApp extends StatelessWidget {
  final Widget startScreen;
  const MyApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIRA',
      debugShowCheckedModeBanner: false,

      // ⚠️ IMPORTANT : navigatorKey pour la gestion automatique du 401
      navigatorKey: HttpInterceptor.navigatorKey,

      theme: ThemeData(
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      navigatorObservers: [routeObserver],
      home: startScreen,

      // ✅ Routes nommées (ajout de /login pour la redirection 401)
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => CustomTabBar(pageTabsState: const {}),
        '/quiz': (context) => const QuizQuestionScreen(
          quizId: 'default-id',
          quizTitle: 'Quiz par défaut',
        ),
        '/quizResult': (context) => QuizResultScreen(
          result: null,
        ),
      },
    );
  }
}

/// ✅ Gestion de la reprise selon la dernière page (avec quiz progress)
Widget getScreenFromPath(
    String path,
    int? selectedTab,
    Map<String, int?> pageTabsState,
    Map<String, dynamic>? quizProgress,
    ) {
  switch (path) {
  // Pages d'onboarding/authentification
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

  // ✅ Page du quiz avec reprise de la progression
    case '/quiz':
      print('🔍 Quiz case - quizProgress: $quizProgress');
      if (quizProgress != null &&
          quizProgress.containsKey('quizId') &&
          quizProgress.containsKey('currentQuestionIndex')) {
        final quizId = quizProgress['quizId'] as String;
        final quizTitle = quizProgress['quizTitle'] as String? ?? 'Quiz';
        final questionIndex = quizProgress['currentQuestionIndex'] as int;

        print('✅ Restoring quiz:');
        print('   - Quiz ID: $quizId');
        print('   - Title: $quizTitle');
        print('   - Question index: $questionIndex');

        return QuizQuestionScreen(
          quizId: quizId,
          quizTitle: quizTitle,
          resumeFromIndex: questionIndex,
        );
      }
      print('⚠️ No valid quiz progress found, starting default quiz');
      return const QuizQuestionScreen(
        quizId: 'default-id',
        quizTitle: 'Quiz Environnement',
      );

  // Pages principales avec barre de navigation
    case '/community':
    case '/defi':
    case '/homePage':
    case '/profile':
    case '/recompense':
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
      return CustomTabBar(pageTabsState: pageTabsState);

    default:
      return CustomTabBar(pageTabsState: pageTabsState);
  }
}