import 'package:SIRA/widgets/card_profiles.dart';
import 'package:SIRA/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:SIRA/services/api_service.dart';
import 'package:SIRA/utils/date_format_utils.dart';
import 'package:provider/provider.dart';
import 'package:SIRA/services/event_provider.dart';

class DetailPopulairePage extends StatefulWidget {
  final String eventId;

  const DetailPopulairePage({
    super.key,
    required this.eventId,
  });

  @override
  State<DetailPopulairePage> createState() => _DetailPopulairePageState();
}

class _DetailPopulairePageState extends State<DetailPopulairePage> {
  late Future<Map<String, dynamic>> futureEventDetail;

  @override
  void initState() {
    super.initState();
    // Charger les détails de l'événement avec l'ID
    futureEventDetail = ApiService.getEventById(id: widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureEventDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFC113)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Retour'),
                  ),
                ],
              ),
            );
          }

          final event = snapshot.data;

          if (event == null || event.isEmpty) {
            return const Center(
              child: Text('Événement non trouvé'),
            );
          }

          final formattedDate = DateFormatUtils.formatDateFull(event['eventDate'] ?? 'JJ/MMMM/AAAA');

          return Consumer<EventProvider>(
            builder: (context, eventProvider, child) {

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Stack pour l'image et les boutons
                    SizedBox(
                      height: 350,
                      child: Stack(
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: SizedBox(
                              height: 350,
                              width: double.infinity,
                              child: event['image'] != null && event['image'].toString().startsWith('http')
                                  ? Image.network(
                                event['image'],
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image_not_supported, size: 50),
                              )
                                  : Image.asset(
                                "assets/images/cardReboisement.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Boutons retour & favoris avec SafeArea
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back, color: Color(0xFF322F35)),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.bookmark_border_outlined, color: Color(0xFF322F35)),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Contenu principal avec superposition
                    Transform.translate(
                      offset: const Offset(0, -15),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(34),
                            topRight: Radius.circular(34),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),

                            // Titre
                            Text(
                              event['eventName'] ?? 'Sans titre',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF322F35),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Participants
                            CardProfiles(
                              profileImages: const [
                                'assets/images/cardProfile.png',
                              ],
                              totalParticipants: event['participantsCount'],
                            ),
                            const SizedBox(height: 16),

                            // Infos - Version responsive
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF9E7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Icon(Icons.calendar_today, color: Color(0xFFFFC113)),
                                        const SizedBox(height: 5),
                                        Text(
                                          formattedDate,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF555257),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 40,
                                    color: const Color(0xFFFFECB6),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Icon(Icons.place, color: Color(0xFFFFC113)),
                                        const SizedBox(height: 5),
                                        Text(
                                          event['location'] ?? 'Non spécifié',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF555257),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 40,
                                    color: const Color(0xFFFFECB6),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: const [
                                        Icon(Icons.access_time, color: Color(0xFFFFC113)),
                                        SizedBox(height: 5),
                                        Text(
                                          "09h00",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF555257),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),
                            Container(
                              height: 1,
                              color: const Color(0xFFF5F5F5),
                            ),
                            const SizedBox(height: 24),

                            // Organisateur
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage("assets/images/cardProfile.png"),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Saliou Diop",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Color(0xFF322F35),
                                        ),
                                      ),
                                      Text(
                                        "Éducateur Citoyen",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF88868A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7F8F7),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.messenger_sharp, color: Color(0xFF322F35)),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7F8F7),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.phone, color: Color(0xFF322F35)),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Description
                            Text(
                              event['description'] ?? 'Aucune description disponible',
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFFABAAAC),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      bottomNavigationBar: Consumer<EventProvider>(
        builder: (context, eventProvider, _) {
          final isParticipating = eventProvider.isParticipating(widget.eventId);
          final isLoading = eventProvider.isLoading(widget.eventId);

          return SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 07),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFF5F5F5), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icône favoris à gauche
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9E7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // action favoris
                      },
                      icon: const Icon(Icons.bookmark_border_outlined,
                          color: Color(0xFF322F35)),
                    ),
                  ),

                  // Bouton "Participer" à droite
                  SizedBox(
                    width: 260, // largeur fixe pour que ça reste propre
                    child: CustomButton(
                      text: isParticipating ? "Se désinscrire" : "Participer",
                      onPressed: isLoading
                          ? null
                          : () => eventProvider.toggleParticipation(
                        context,
                        widget.eventId,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}