import 'package:flutter/material.dart';
import '../../screens/tabs/detail_video.dart';

class VideoCard extends StatelessWidget {
  final String thumbnailUrl;
  final String title;
  final String subtitle;
  final String profession;
  final String avatarUrl;
  final double width;
  final double height;

  const VideoCard({
    super.key,
    required this.thumbnailUrl,
    required this.title,
    required this.subtitle,
    required this.profession,
    required this.avatarUrl,
    this.width = 300,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
        child: InkWell(
          onTap: () {
            // Navigation vers une page de détails
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DetailVideo(),
              ),
            );
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
      child: Column(
        children: [
          // En-tête : profil + nom + profession + favoris
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[400],
                  child: avatarUrl.isNotEmpty
                      ? ClipOval(
                    child: Image.asset(
                      avatarUrl,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        profession,
                        style: const TextStyle(
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
          ),

          // Thumbnail avec titre en overlay
          ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            child: Stack(
              children: [
                Image.asset(
                  thumbnailUrl,
                  width: double.infinity,
                  height: height,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.black.withOpacity(0.5),
                    child: Text(
                      title,
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
              ],
            ),
          ),
        ],
      ),
        ),);
  }
}
