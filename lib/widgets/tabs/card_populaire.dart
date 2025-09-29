import 'package:SIRA/screens/tabs/detail_populaire_page.dart';
import 'package:flutter/material.dart';
import 'package:SIRA/services/api_service.dart';

class CardPopulaire extends StatefulWidget {
  final String eventId;
  final String imageAsset;
  final String title;
  final String subtitle;
  final String date;
  final String location;
  final String participants;
  final VoidCallback? onParticiper;
  final bool initialParticipating;

  const CardPopulaire({
    super.key,
    required this.eventId,
    required this.imageAsset,
    required this.title,
    this.subtitle = '',
    required this.date,
    required this.location,
    required this.participants,
    this.onParticiper,
    this.initialParticipating = false,
  });

  @override
  State<CardPopulaire> createState() => _CardPopulaireState();
}

class _CardPopulaireState extends State<CardPopulaire> {
  bool isParticipating = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isParticipating = widget.initialParticipating; // 👈 initialise correctement
  }

  Future<void> participerOuAnnuler(bool participer) async {
    setState(() => isLoading = true);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigation vers la page détail
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DetailPopulairePage(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(16),
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
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[300],
                child: (widget.imageAsset.startsWith('http') ||
                    widget.imageAsset.startsWith('https'))
                    ? Image.network(
                  widget.imageAsset,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.fill,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.image_not_supported,
                          size: 50, color: Colors.grey),
                    );
                  },
                )
                    : Image.asset(
                  widget.imageAsset,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.fill,
                ),
              ),
            ),

            /// Contenu
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Titre
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// Date & Lieu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_month_outlined,
                              size: 12, color: Color(0xFFFFC113)),
                          const SizedBox(width: 4),
                          Text(widget.date,
                              style: const TextStyle(
                                  fontSize: 11, color: Color(0xFF555257))),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 12, color: Color(0xFFFFC113)),
                          const SizedBox(width: 4),
                          Text(widget.location,
                              style: const TextStyle(
                                  fontSize: 11, color: Color(0xFF555257))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  /// Participants + Bouton
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Participants
                  Row( children: [ SizedBox( width: 50, height: 24, child:
                  Stack( children: [ // Cercle vert (à gauche)
                    Positioned( left: 0, child: Container( width: 24, height: 24, decoration: BoxDecoration( color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), ), ), ),
                    // Cercle rouge (au milieu)
                    Positioned( left: 13, child: Container( width: 24, height: 24, decoration: BoxDecoration( color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), ), ), ),
                    // Cercle jaune (à droite)
                    Positioned( left: 26, child: Container( width: 24, height: 24, decoration: BoxDecoration( color: const Color(0xFFFFC113), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), ), ), ), ], ), ),
                    const SizedBox(width: 8),
                   Text( widget.participants,
                     style: const TextStyle( fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500,
                     ),
                   ),
                  ],
                  ),
                      /// Bouton Participer
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                          setState(() => isLoading = true);

                          int statusCode;
                          if (!isParticipating) {
                            statusCode = await ApiService.participate(id: widget.eventId);
                          } else {
                            statusCode = await ApiService.annulerParticipation(id: widget.eventId);
                          }

                          // Affichage des messages selon statusCode
                          if (statusCode == 200) {
                            setState(() => isParticipating = !isParticipating);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isParticipating
                                    ? 'Participation enregistrée'
                                    : 'Participation annulée'),
                              ),
                            );
                          } else if (statusCode == 400) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Impossible de participer à un événement passé')),
                            );
                          } else if (statusCode == 404) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Événement non trouvé')),
                            );
                          } else if (statusCode == 409) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Vous avez déjà participez à cet événement')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Erreur inattendue')),
                            );
                          }

                          setState(() => isLoading = false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC113),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                          isParticipating ? "Se désinscrire" : "Participer",
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
  }
}
