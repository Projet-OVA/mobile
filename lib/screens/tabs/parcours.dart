import 'package:flutter/material.dart';
import '../../widgets/tabs/main_layout.dart';
import '../../services/course_service.dart';
import '../../data/models/course_model.dart';
import '../../widgets/course_carousel.dart';
import 'video.dart';
import 'podcast.dart';
import 'article.dart';
import 'package:SIRA/services/auth_storage.dart';

class Parcours extends StatefulWidget {
  const Parcours({super.key});

  @override
  State<Parcours> createState() => _ParcoursState();
}

class _ParcoursState extends State<Parcours> with WidgetsBindingObserver{
  static const String pageName = 'parcours';
  int selectedFilter = 0;

  Map<String, List<Course>> coursesByCategory = {};
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _loadLastSelectedTab();
    _loadCourses();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      AuthStorage.savePageTab(pageName, selectedFilter);

      switch (selectedFilter) {
        case 1:
          AuthStorage.saveLastPath('/video');
          break;
        case 2:
          AuthStorage.saveLastPath('/podcast');
          break;
        case 3:
          AuthStorage.saveLastPath('/article');
          break;
        default:
          AuthStorage.saveLastPath('/profile');
      }
    }
  }

  Future<void> _loadLastSelectedTab() async {
    final lastTab = await AuthStorage.getPageTab(pageName);
    if (lastTab != null) {
      setState(() {
        selectedFilter = lastTab;
      });
    }
  }

  /// Charger les parcours depuis l'API
  Future<void> _loadCourses() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final courses = await CourseService.getCoursesByCategory();
      setState(() {
        coursesByCategory = courses;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      print("Erreur lors du chargement des parcours: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: selectedFilter, // ✅ AJOUTÉ : passer l'index actuel
      onFilterSelected: (index) async {
        setState(() {
          selectedFilter = index;
        });
        await AuthStorage.savePageTab(pageName, index);

        //Sauvegarder le lastPath correspondant
        if (index == 1) {
          await AuthStorage.saveLastPath('/video');
        } else if (index == 2){
          await AuthStorage.saveLastPath('/podcast');
        }else if (index == 3){
        await AuthStorage.saveLastPath('/article');
        } else {
        await AuthStorage.saveLastPath('/homePage');
        }
      },
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (selectedFilter) {
      case 0:
        return _buildParcours();
      case 1:
        return _buildVideo();
      case 2:
        return _buildPodcast();
      case 3:
        return _buildArticle();
      default:
        return const Center(child: Text("Aucun contenu"));
    }
  }

  Widget _buildParcours() {
    // Afficher le loader pendant le chargement
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC113)),
        ),
      );
    }

    // Afficher le message d'erreur s'il y en a un
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadCourses,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF322F35),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Afficher un message si aucun parcours n'est disponible
    if (coursesByCategory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school_outlined,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucun parcours disponible',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadCourses,
              icon: const Icon(Icons.refresh),
              label: const Text('Actualiser'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF322F35),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Afficher les parcours par catégorie
    return RefreshIndicator(
      onRefresh: _loadCourses,
      color: const Color(0xFF322F35),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: coursesByCategory.length,
        itemBuilder: (context, index) {
          final categoryName = coursesByCategory.keys.elementAt(index);
          final courses = coursesByCategory[categoryName]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre de la catégorie
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 12),
                child: Row(
                  children: [
                    Text(
                      categoryName,
                      style: const TextStyle(
                        color: Color(0xFF1C1C1C),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF322F35),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${courses.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              
              // Carrousel des parcours de cette catégorie
              CourseCarousel(courses: courses),
              
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVideo() => const Video();
  Widget _buildPodcast() => const Podcast();
  Widget _buildArticle() => const Article();
}