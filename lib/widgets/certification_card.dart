import 'package:flutter/material.dart';

class CertificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageAsset;
  final String? imageUrl;
  final double? width;
  final double? height;

  const CertificationCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.imageAsset,
    this.imageUrl,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 50,
      height: height ?? 140,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(24.77),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image/Icône
            _buildImageWidget(),

            const SizedBox(height: 24),

            // Titre
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.86,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFD0C6AA),
                borderRadius: BorderRadius.circular(9.91),
              ),
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14.86,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFA59E8E),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    final defaultWidget = Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFB8A082).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.verified,
        size: 40,
        color: Color(0xFFB8A082),
      ),
    );

    if (imageUrl != null) {
      // Image depuis une URL
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFB8A082).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image.network(
            imageUrl!,
            width: 60,
            height: 60,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return defaultWidget;
            },
          ),
        ),
      );
    } else if (imageAsset != null) {
      // Image depuis les assets
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFB8A082),
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image.asset(
            imageAsset!,
            width: 60,
            height: 60,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return defaultWidget;
            },
          ),
        ),
      );
    } else {
      // Icône par défaut
      return defaultWidget;
    }
  }
}