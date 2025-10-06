import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/publication_model.dart';
import '../../screens/tabs/detail_video.dart';

class VideoCardPublication extends StatelessWidget {
  final Publication publication;

  const VideoCardPublication({
    super.key,
    required this.publication,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPublicationVideo(
                publicationId: publication.id,
              ),
            ),
          );
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: Column(
          children: [
            _buildHeader(),
            _buildThumbnail(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF322F35),
            child: Text(
              publication.author.prenom[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  publication.author.getFullName(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Text(
                  'Éducateur Citoyen',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: action favoris
            },
            icon: const Icon(Icons.bookmark_border),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final thumbnailHeight = screenHeight * 0.25;

    if (publication.attachment == null) {
      return _buildPlaceholder(thumbnailHeight);
    }

    String thumbnailUrl = _getVideoThumbnail(publication.attachment!.url);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: thumbnailUrl,
            height: thumbnailHeight,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildPlaceholderLoading(thumbnailHeight),
            errorWidget: (context, url, error) => _buildPlaceholderError(thumbnailHeight),
          ),
          Container(
            height: thumbnailHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Text(
                publication.publicationContent,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.3),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.play_arrow,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getVideoThumbnail(String videoUrl) {
    return videoUrl
        .replaceAll('/video/upload/', '/video/upload/so_0,w_600,h_400,c_fill,q_auto/')
        .replaceAll('.mp4', '.jpg')
        .replaceAll('.mov', '.jpg')
        .replaceAll('.avi', '.jpg')
        .replaceAll('.webm', '.jpg');
  }

  Widget _buildPlaceholder(double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: const Center(
        child: Icon(Icons.videocam_off, size: 60, color: Colors.grey),
      ),
    );
  }

  Widget _buildPlaceholderLoading(double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[800]!, Colors.grey[900]!],
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white70,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildPlaceholderError(double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[800]!, Colors.grey[900]!],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_circle_outline, size: 64, color: Colors.white70),
            SizedBox(height: 8),
            Text(
              'Vidéo',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
