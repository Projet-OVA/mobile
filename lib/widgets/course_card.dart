import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/models/course_model.dart';
import '../screens/tabs/detail_parcours.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final Color backgroundColor;
  final bool isActive;

  const CourseCard({
    super.key,
    required this.course,
    this.backgroundColor = const Color(0xFFFCF1E1),
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailParcours(courseId: course.id),
            ),
          ),
          child: Container(
            color: backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildTitle(),
                const Spacer(),
                _buildMedia(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.quiz_outlined, size: 8),
                const SizedBox(width: 4),
                Text(
                  '${course.quizzes.length} quiz',
                  style: const TextStyle(fontSize: 8),
                ),
              ],
            ),
          ),
          const Icon(Icons.bookmarks_outlined, size: 14, color: Color(0xFF322F35)),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        course.nom,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1C1C1C),
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildMedia(BuildContext context) {
    final h = MediaQuery.of(context).size.height * 0.15;

    if (course.attachment == null) {
      return _placeholder(h, Icons.image_outlined, Colors.grey);
    }

    final attachment = course.attachment!;

    // Pour les vidéos : afficher miniature au lieu de charger la vidéo
    if (attachment.mediaType == 'VIDEO') {
      return _buildVideoThumbnail(h, attachment.url);
    }

    // Pour les images
    if (attachment.mediaType == 'IMAGE') {
      return _buildImage(h, attachment.url);
    }

    return _placeholder(h, Icons.image_outlined, Colors.grey);
  }

  Widget _buildVideoThumbnail(double height, String videoUrl) {
    // Cloudinary : transformer l'URL vidéo en miniature
    String thumbnailUrl = videoUrl
        .replaceAll('/video/upload/', '/video/upload/so_0,w_400,h_300,c_fill,q_auto/')
        .replaceAll('.mp4', '.jpg')
        .replaceAll('.mov', '.jpg')
        .replaceAll('.avi', '.jpg')
        .replaceAll('.webm', '.jpg');

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: thumbnailUrl,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (_, __) => _videoPlaceholderLoading(height),
            errorWidget: (_, __, ___) => _videoPlaceholderError(height),
          ),
          Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
              ),
            ),
            child: const Center(
              child: Icon(Icons.play_circle_filled, size: 56, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(double height, String imageUrl) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        memCacheWidth: 500,
        maxHeightDiskCache: 500,
        placeholder: (_, __) => _placeholder(height, Icons.image, Colors.grey),
        errorWidget: (_, __, ___) => _placeholder(height, Icons.broken_image, Colors.grey),
      ),
    );
  }

  Widget _videoPlaceholderLoading(double height) {
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

  Widget _videoPlaceholderError(double height) {
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
            Text('Vidéo', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(double height, IconData icon, Color? color) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey[300],
      child: Center(
        child: Icon(icon, size: 40, color: color),
      ),
    );
  }
}
