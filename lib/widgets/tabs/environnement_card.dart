import 'package:SIRA/screens/tabs/detail_populaire_page.dart';
import 'package:flutter/material.dart';

class EnvironnementCard extends StatelessWidget {
  final String eventId;
  final String imageAsset;
  final String title;
  final String date;
  final String location;
  final VoidCallback? onBack;

  const EnvironnementCard({
    super.key,
    required this.eventId,
    required this.imageAsset,
    required this.title,
    required this.date,
    required this.location,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 50,
              height: 50,
              child: imageAsset.startsWith('http')
                  ? Image.network(
                imageAsset,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 20, color: Colors.grey),
                  );
                },
              )
                  : Image.asset(
                imageAsset,
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(width: 08),

          // Infos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF322F35)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_month_rounded, size: 12, color: Color(0xFFFFC113)),
                    const SizedBox(width: 4),
                    Text(date, style: const TextStyle(fontSize: 11, color: Color(0xFF555257))),
                    const SizedBox(width: 12),
                    Icon(Icons.location_on, size: 12, color: Color(0xFFFFC113)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF555257)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Flèche
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFF9E7),
              borderRadius: BorderRadius.circular(2),
            ),
              child: IconButton(
                onPressed: onBack ?? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPopulairePage(eventId: eventId),
                    ),
                  );
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_right,
                  color: Color(0xFFFFC113),
                  size: 28,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
