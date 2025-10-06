import 'package:flutter/material.dart';
import '../../services/publication_service.dart';
import '../../data/models/publication_model.dart';
import '../../widgets/tabs/my_carousel_podcast.dart';

class Podcast extends StatefulWidget {
  const Podcast({super.key});

  @override
  State<Podcast> createState() => _PodcastState();
}

class _PodcastState extends State<Podcast> {
  List<Publication> allPodcasts = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPodcasts();
  }

  Future<void> _loadPodcasts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final podcasts = await PublicationService.getPodcasts();

      setState(() {
        allPodcasts = podcasts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await _loadPodcasts();
  }

  // Grouper les podcasts par catégories (simulation basée sur les données)
  List<Publication> _getPodcastsBySection(int sectionIndex) {
    if (allPodcasts.isEmpty) return [];

    // Distribution des podcasts dans différentes sections
    final podcastsPerSection = (allPodcasts.length / 4).ceil();
    final startIndex = sectionIndex * podcastsPerSection;
    final endIndex = (startIndex + podcastsPerSection).clamp(0, allPodcasts.length);

    if (startIndex >= allPodcasts.length) return [];

    return allPodcasts.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF322F35)),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Erreur de chargement'),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadPodcasts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF322F35),
                ),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    if (allPodcasts.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.podcasts_outlined,
                  size: 80,
                  color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Aucun podcast disponible',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: const Color(0xFF322F35),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            // Section 1 - Pour toi
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Pour toi',
                style: TextStyle(
                  color: Color(0xFF1C1C1C),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            MyCarouselPodcast(podcasts: _getPodcastsBySection(0)),
            const SizedBox(height: 24),

            // Section 2 - Communauté
            if (_getPodcastsBySection(1).isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Communauté',
                  style: TextStyle(
                    color: Color(0xFF1C1C1C),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              MyCarouselPodcast(podcasts: _getPodcastsBySection(1)),
              const SizedBox(height: 24),
            ],

            // Section 3 - Éducation
            if (_getPodcastsBySection(2).isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Éducation',
                  style: TextStyle(
                    color: Color(0xFF1C1C1C),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              MyCarouselPodcast(podcasts: _getPodcastsBySection(2)),
              const SizedBox(height: 24),
            ],

            // Section 4 - Inclusion
            if (_getPodcastsBySection(3).isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Inclusion',
                  style: TextStyle(
                    color: Color(0xFF1C1C1C),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              MyCarouselPodcast(podcasts: _getPodcastsBySection(3)),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}