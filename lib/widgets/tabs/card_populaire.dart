import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SIRA/services/event_provider.dart';
import 'package:SIRA/screens/tabs/detail_populaire_page.dart';

class CardPopulaire extends StatelessWidget {
  final String eventId;
  final String imageAsset;
  final String title;
  final String date;
  final String location;

  const CardPopulaire({
    super.key,
    required this.eventId,
    required this.imageAsset,
    required this.title,
    required this.date,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        final participants = eventProvider.participantsCount(eventId);
        final isParticipating = eventProvider.isParticipating(eventId);
        final isLoading = eventProvider.isLoading(eventId);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailPopulairePage(eventId: eventId),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(16),
            height: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: imageAsset.startsWith('http')
                        ? Image.network(
                      imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported, size: 50),
                    )
                        : Image.asset(
                      imageAsset,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                /// Contenu
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            const Icon(Icons.calendar_month_outlined,
                                size: 12, color: Color(0xFFFFC113)),
                            const SizedBox(width: 4),
                            Text(
                              date,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF555257),
                              ),
                            ),
                          ]),
                          Row(children: [
                            const Icon(Icons.location_on,
                                size: 12, color: Color(0xFFFFC113)),
                            const SizedBox(width: 4),
                            Text(
                              location,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF555257),
                              ),
                            ),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 12),

                      /// Participants + bouton
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            SizedBox(
                              width: 50,
                              height: 24,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(left: 0, child: _circle(Colors.green)),
                                  Positioned(left: 13, child: _circle(Colors.red)),
                                  Positioned(
                                    left: 26,
                                    child: _circle(const Color(0xFFFFC113)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              participants == 0 || participants == 1
                                  ? '$participants participant'
                                  : '+ $participants participants',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ]),
                          ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () => eventProvider.toggleParticipation(
                                context, eventId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFC113),
                              foregroundColor: const Color(0xFF322F35),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                                : Text(
                              isParticipating
                                  ? "Se désinscrire"
                                  : "Participer",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _circle(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}