import 'package:flutter/material.dart';
import '../widgets/settings.dart';
import 'package:SIRA/services/api_service.dart';

class BannerProfile extends StatefulWidget {
  const BannerProfile({super.key});

  @override
  State<BannerProfile> createState() => _BannerProfileState();
}

class _BannerProfileState extends State<BannerProfile> {
  Future<Map<String, dynamic>>? userDetail;
  Future<List<dynamic>>? userBadges;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final userId = await ApiService.getCurrentUser();
      if (userId == null) {
        throw Exception("Aucun utilisateur trouvé");
      }

      setState(() {
        userDetail = ApiService.getCurrentUser();
        userBadges = ApiService.getMyBadges();
      });
    } catch (e) {
      print("Erreur lors du chargement: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Container(
      width: double.infinity,
      height: isTablet ? 280 : 250,
      decoration: const BoxDecoration(
        color: Color(0xFFFFC107),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(300),
          bottomRight: Radius.circular(300),
        ),
      ),
      child: Stack(
        children: [
          // Contenu principal du profil
          Center(
            child: FutureBuilder<Map<String, dynamic>>(
              future: userDetail,
              builder: (context, snapshotUser) {
                if (snapshotUser.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(color: Color(0xFF322F35));
                }

                if (snapshotUser.hasError || snapshotUser.data == null) {
                  return const Text(
                    "Erreur de chargement",
                    style: TextStyle(color: Color(0xFF322F35)),
                  );
                }

                final user = snapshotUser.data!;
                final prenom = user['prenom'] ?? "Inconnu";
                final nom = user['nom'] ?? "";

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage("assets/images/cardProfile.png"),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "$prenom $nom",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF322F35),
                      ),
                    ),
                    const SizedBox(height: 4),
                    FutureBuilder<List<dynamic>>(
                      future: userBadges,
                      builder: (context, snapshotBadges) {
                        if (snapshotBadges.connectionState == ConnectionState.waiting) {
                          return const Text("Chargement des badges...");
                        }
                        if (snapshotBadges.hasError) {
                          return const Text("Aucun badge trouvé");
                        }
                        final badges = snapshotBadges.data ?? [];
                        if (badges.isEmpty) {
                          return const Text("Aucun badge attribué");
                        }
                        return Text(
                          "Badge : ${badges.last['name'] ?? 'Inconnu'}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF322F35),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),

          // 🔥 Bouton Settings sorti du FutureBuilder
          Positioned(
            right: 20,
            top: 40,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
              child: const Icon(
                Icons.settings_outlined,
                color: Color(0xFF322F35),
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
