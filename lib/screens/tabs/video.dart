import 'package:flutter/material.dart';
import '../../services/publication_service.dart';
import '../../data/models/publication_model.dart';
import '../../widgets/tabs/video_card.dart';

class Video extends StatefulWidget {
  const Video({super.key});

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  List<Publication> videos = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  String? errorMessage;

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadVideos();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore && _hasMore) {
        _loadMoreVideos();
      }
    }
  }

  Future<void> _loadVideos() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final allVideos = await PublicationService.getVideos();

      setState(() {
        videos = allVideos.take(_itemsPerPage).toList();
        _currentPage = 1;
        _hasMore = allVideos.length > _itemsPerPage;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _loadMoreVideos() async {
    if (isLoadingMore || !_hasMore) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      final allVideos = await PublicationService.getVideos();
      final startIndex = _currentPage * _itemsPerPage;
      final endIndex = startIndex + _itemsPerPage;

      if (startIndex >= allVideos.length) {
        setState(() {
          _hasMore = false;
          isLoadingMore = false;
        });
        return;
      }

      final newVideos = allVideos.skip(startIndex).take(_itemsPerPage).toList();

      setState(() {
        videos.addAll(newVideos);
        _currentPage++;
        _hasMore = endIndex < allVideos.length;
        isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        isLoadingMore = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  Future<void> _onRefresh() async {
    await _loadVideos();
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
                onPressed: _loadVideos,
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

    if (videos.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.video_library_outlined,
                  size: 80,
                  color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Aucune vidéo disponible',
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
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: videos.length + (isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == videos.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF322F35)),
                  ),
                ),
              );
            }

            final video = videos[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: VideoCardPublication(publication: video),
            );
          },
        ),
      ),
    );
  }
}
