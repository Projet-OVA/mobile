import 'dart:convert';
import 'package:SIRA/screens/tabs/ajout_defi.dart';
import 'package:SIRA/widgets/tabs/card_populaire.dart';
import 'package:SIRA/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'package:http/http.dart' as http;

class MesDefisCrees extends StatefulWidget {
  const MesDefisCrees({Key? key}) : super(key: key);

  @override
  State<MesDefisCrees> createState() => _MesDefisCreesState();
}

class _MesDefisCreesState extends State<MesDefisCrees> {
  late Future<http.Response> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = ApiService.getDefi();
  }

  // Méthode pour recharger les données
  Future<void> _refreshData() async {
    setState(() {
      _futureEvents = ApiService.getDefi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<http.Response>(
                future: _futureEvents, // Utilisation de la variable d'instance
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Erreur: ${snapshot.error}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _refreshData,
                            child: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasData) {
                    try {
                      final Map<String, dynamic> jsonResponse = jsonDecode(snapshot.data!.body);

                      // Vérification que 'data' existe et est une liste
                      if (!jsonResponse.containsKey('data') || jsonResponse['data'] is! List) {
                        return const Center(
                          child: Text(
                            "Format de données invalide",
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      final List<dynamic> events = jsonResponse['data'];

                      if (events.isEmpty) {
                        // Cas sans défi
                        return RefreshIndicator(
                          onRefresh: _refreshData,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/imageGroup.png',
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.image_not_supported,
                                        size: 100,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 40),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                                    child: Text(
                                      'Vous pouvez voir ici tous vos défis créés. '
                                          'Vous n\'en avez pas encore créé ? Créez dès aujourd\'hui ! '
                                          'Lancez-vous et inspirez votre communauté avec des défis engageants.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF88868A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      // Cas avec des défis
                      return RefreshIndicator(
                        onRefresh: _refreshData,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: events.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 0),
                            itemBuilder: (context, index) {
                              final event = events[index];

                              // Validation des données de l'événement
                              if (event is! Map<String, dynamic>) {
                                return const Card(
                                  child: Center(
                                    child: Text('Données invalides'),
                                  ),
                                );
                              }

                              // Formatage de la date
                              String formattedDate = '';
                              if (event['eventDate'] != null) {
                                try {
                                  DateTime dateTime = DateTime.parse(event['eventDate'].toString());
                                  List<String> mois = [
                                    '', 'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
                                    'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
                                  ];
                                  formattedDate = '${dateTime.day} ${mois[dateTime.month]} ${dateTime.year}';
                                } catch (e) {
                                  formattedDate = event['eventDate']?.toString() ?? '';
                                }
                              }

                              return CardPopulaire(
                                imageAsset: event['image']?.toString() ?? 'assets/images/reboisement.png',
                                title: event['eventName']?.toString() ?? 'Sans titre',
                                date: formattedDate,
                                location: event['location']?.toString() ?? '',
                                participants: "+${event['participantsCount']?.toString() ?? '0'} participants",
                              );
                            },
                          ),
                        ),
                      );
                    } catch (e) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Erreur de parsing JSON: ${e.toString()}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _refreshData,
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      );
                    }
                  }

                  return const Center(
                    child: Text(
                      'Aucune donnée disponible',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF88868A),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bouton fixe en bas avec padding approprié
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: CustomButton(
                    text: 'Nouveau Défi',
                    borderRadius: 24,
                    icon: Icons.edit_note_outlined,
                    onPressed: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AjoutDefi(),
                        ),
                      );

                      // Recharger les données si un nouveau défi a été créé
                      if (result == true && mounted) {
                        _refreshData();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}