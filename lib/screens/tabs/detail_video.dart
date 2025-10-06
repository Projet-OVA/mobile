import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../services/publication_service.dart';
import '../../data/models/publication_model.dart';

class DetailPublicationVideo extends StatefulWidget {
  final String publicationId;

  const DetailPublicationVideo({
    super.key,
    required this.publicationId,
  });

  @override
  State<DetailPublicationVideo> createState() => _DetailPublicationVideoState();
}

class _DetailPublicationVideoState extends State<DetailPublicationVideo> {
  Publication? currentPublication;
  List<Publication> relatedVideos = [];
  bool isLoading = true;
  String? errorMessage;

  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _loadPublicationDetails();
  }

  Future<void> _loadPublicationDetails() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final allPublications = await PublicationService.getPublications();

      final publication = allPublications.firstWhere(
            (pub) => pub.id == widget.publicationId,
        orElse: () => throw Exception('Publication non trouvée'),
      );

      final videos = allPublications
          .where((pub) => pub.isVideo() && pub.id != widget.publicationId)
          .toList();

      setState(() {
        currentPublication = publication;
        relatedVideos = videos;
        isLoading = false;
      });

      if (publication.attachment?.mediaType == 'VIDEO') {
        _initializeVideo(publication.attachment!.url);
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _initializeVideo(String url) {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _chewieController = ChewieController(
              videoPlayerController: _videoController!,
              autoPlay: false,
              looping: false,
              showControls: true,
              materialProgressColors: ChewieProgressColors(
                playedColor: const Color(0xFFFBBC04),
                handleColor: const Color(0xFFFBBC04),
                backgroundColor: Colors.grey,
                bufferedColor: Colors.grey[300]!,
              ),
              placeholder: Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFBBC04),
                  ),
                ),
              ),
              autoInitialize: true,
              errorBuilder: (context, errorMessage) {
                return Container(
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Erreur de lecture vidéo',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          });
        }
      }).catchError((error) {
        print('Erreur initialisation vidéo: $error');
      });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
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

    if (errorMessage != null || currentPublication == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Erreur de chargement'),
              const SizedBox(height: 8),
              Text(errorMessage ?? 'Publication introuvable'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF322F35),
                ),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildVideoHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildCurrentVideoInfo(),
                    if (relatedVideos.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Vidéos similaires',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      ...relatedVideos.take(5).map(
                            (video) => _buildRelatedVideoCard(video),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoHeader(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: size.height * 0.35,
          color: Colors.black,
          child: _buildVideoPlayer(),
        ),
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.5),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: action favoris
                  },
                  icon: const Icon(Icons.bookmark_border, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    if (currentPublication!.attachment == null) {
      return Container(
        color: Colors.grey[800],
        child: const Center(
          child: Icon(Icons.videocam_off, size: 80, color: Colors.grey),
        ),
      );
    }

    if (_chewieController != null) {
      return Chewie(controller: _chewieController!);
    }

    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFFBBC04),
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              'Chargement de la vidéo...',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentVideoInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentPublication!.publicationContent,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildAuthorInfo(),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF322F35),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _formatDate(currentPublication!.publicationDate),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFF322F35),
          child: Text(
            currentPublication!.author.prenom[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentPublication!.author.getFullName(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Text(
              'Éducateur Citoyen',
              style: TextStyle(
                color: Color(0xFF888888),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRelatedVideoCard(Publication video) {
    final thumbnailUrl = _getVideoThumbnail(video.attachment?.url ?? '');

    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPublicationVideo(
              publicationId: video.id,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: thumbnailUrl,
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 120,
                      height: 80,
                      color: Colors.grey[800],
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white70,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 120,
                      height: 80,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.play_circle_outline,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.publicationContent,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video.author.getFullName(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDate(video.publicationDate),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFAAAAAA),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getVideoThumbnail(String videoUrl) {
    if (videoUrl.isEmpty) return '';

    return videoUrl
        .replaceAll('/video/upload/', '/video/upload/so_0,w_400,h_300,c_fill,q_auto/')
        .replaceAll('.mp4', '.jpg')
        .replaceAll('.mov', '.jpg')
        .replaceAll('.avi', '.jpg')
        .replaceAll('.webm', '.jpg');
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Aujourd'hui";
    } else if (difference.inDays == 1) {
      return "Hier";
    } else if (difference.inDays < 7) {
      return "Il y a ${difference.inDays} jours";
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return "Il y a $weeks semaine${weeks > 1 ? 's' : ''}";
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return "Il y a $months mois";
    } else {
      final years = (difference.inDays / 365).floor();
      return "Il y a $years an${years > 1 ? 's' : ''}";
    }
  }
}