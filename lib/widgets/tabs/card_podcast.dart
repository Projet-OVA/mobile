import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/publication_model.dart';
import '../../screens/tabs/detail_podcast.dart';

class CardPodcast extends StatelessWidget {
  final Publication publication;

  const CardPodcast({
    super.key,
    required this.publication,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPodcastPublication(
              publicationId: publication.id,
            ),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 48, // Largeur écran - marges
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 6),
                  _buildMetadata(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (publication.attachment?.url != null) {
      String thumbnailUrl = publication.attachment!.url;

      // Si c'est une vidéo, convertir en thumbnail
      if (publication.attachment!.mediaType == 'VIDEO') {
        thumbnailUrl = thumbnailUrl
            .replaceAll('/video/upload/', '/video/upload/so_0,w_200,h_200,c_fill,q_auto/')
            .replaceAll('.mp4', '.jpg')
            .replaceAll('.mov', '.jpg')
            .replaceAll('.avi', '.jpg')
            .replaceAll('.webm', '.jpg');
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: thumbnailUrl,
          width: 64,
          height: 64,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 64,
            height: 64,
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF322F35)),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF322F35),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.podcasts,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      );
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF322F35),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.podcasts,
        color: Colors.white,
        size: 32,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      publication.publicationContent,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF242327),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMetadata() {
    return Row(
      children: [
        Text(
          _formatDate(publication.publicationDate),
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFA7A6A5),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${_calculateDuration()} mn',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFA7A6A5),
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.headphones,
          color: Color(0xFFA7A6A5),
          size: 16,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Aujourd'hui";
    } else if (difference.inDays == 1) {
      return "Hier";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}j";
    } else if (difference.inDays < 30) {
      return "${(difference.inDays / 7).floor()}sem";
    } else {
      return "${date.day}/${date.month}";
    }
  }

  int _calculateDuration() {
    // Durée simulée basée sur la longueur du contenu
    final wordCount = publication.publicationContent.split(' ').length;
    return (wordCount / 3).ceil().clamp(5, 60); // Entre 5 et 60 minutes
  }
}