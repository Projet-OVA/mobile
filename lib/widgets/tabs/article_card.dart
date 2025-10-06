import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/publication_model.dart';
import '../../screens/tabs/article_detail_page.dart';

class ArticleCardPublication extends StatelessWidget {
  final Publication publication;

  const ArticleCardPublication({
    super.key,
    required this.publication,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailPublication(
              publicationId: publication.id,
            ),
          ),
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Partie gauche : infos texte
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAuthorInfo(),
                    const SizedBox(height: 12),
                    _buildTitle(),
                    const SizedBox(height: 6),
                    _buildDescription(),
                    const SizedBox(height: 10),
                    _buildDateInfo(),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Partie droite : Image
              _buildThumbnail(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: const Color(0xFF322F35),
          child: Text(
            publication.author.prenom[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
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
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const Text(
                'Éducateur Citoyen',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF979797),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      publication.publicationContent,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFF242327),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    // Extraire un aperçu du contenu (si disponible)
    String description = publication.publicationContent;
    if (description.length > 80) {
      description = '${description.substring(0, 80)}...';
    }

    return Text(
      description,
      style: const TextStyle(
        fontSize: 13,
        color: Color(0xFF979797),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDateInfo() {
    final formattedDate = _formatDate(publication.publicationDate);
    final readTime = _calculateReadTime(publication.publicationContent);

    return Row(
      children: [
        Text(
          formattedDate,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF979797),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '• $readTime min',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF979797),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail() {
    if (publication.attachment?.mediaType == 'IMAGE' &&
        publication.attachment?.url != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: publication.attachment!.url,
          width: 100,
          height: 90,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 100,
            height: 90,
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF322F35)),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: 100,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.article_outlined,
              size: 40,
              color: Colors.grey[400],
            ),
          ),
        ),
      );
    }

    // Placeholder si pas d'image
    return Container(
      width: 100,
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Icon(
        Icons.article_outlined,
        size: 40,
        color: Colors.grey[400],
      ),
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
      return "${difference.inDays} jours";
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return "$weeks sem";
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return "$months mois";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }

  int _calculateReadTime(String content) {
    // Calcul approximatif : 200 mots par minute
    final wordCount = content.split(' ').length;
    final minutes = (wordCount / 200).ceil();
    return minutes < 1 ? 1 : minutes;
  }
}