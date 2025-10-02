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
      final userId = await ApiService.getUserId();
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
    return FutureBuilder<Map<String, dynamic>>(
      future: userDetail,
      builder: (context, snapshotUser) {
        final size = MediaQuery.of(context).size;
        final isTablet = size.width > 600;

        if (snapshotUser.connectionState == ConnectionState.waiting) {
          return _buildLoadingContainer(isTablet);
        }

        if (snapshotUser.hasError || snapshotUser.data == null) {
          return _buildErrorContainer(isTablet, snapshotUser.error.toString());
        }

        final user = snapshotUser.data!;
        final prenom = user['prenom'] ?? "Inconnu";
        final nom = user['nom'] ?? "";

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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage("assets/images/cardProfile.png"),
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

                    // 🔥 FutureBuilder pour afficher les badges
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
                          "Badges : ${badges.map((b) => b['name'] ?? b.toString()).join(", ")}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF322F35),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Settings()),
                    );
                  },
                  child: const Icon(
                    Icons.settings_outlined,
                    color: Color(0xFF322F35),
                    size: 22,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingContainer(bool isTablet) => Container(
    width: double.infinity,
    height: isTablet ? 280 : 250,
    decoration: const BoxDecoration(
      color: Color(0xFFFFC107),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(300),
        bottomRight: Radius.circular(300),
      ),
    ),
    child: const Center(child: CircularProgressIndicator(color: Color(0xFF322F35))),
  );

  Widget _buildErrorContainer(bool isTablet, String error) => Container(
    width: double.infinity,
    height: isTablet ? 280 : 250,
    decoration: const BoxDecoration(
      color: Color(0xFFFFC107),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(300),
        bottomRight: Radius.circular(300),
      ),
    ),
    child: Center(
      child: Text("Erreur: $error", style: const TextStyle(color: Color(0xFF322F35))),
    ),
  );
}
