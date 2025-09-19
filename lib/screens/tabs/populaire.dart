import 'package:SIRA/screens/tabs/education.dart';
import 'package:SIRA/screens/tabs/environnement.dart';
import 'package:SIRA/screens/tabs/mes_defis.dart';
import 'package:SIRA/widgets/tabs/environnement_card.dart';
import 'package:SIRA/widgets/tabs/populaire_carousel.dart';
import 'package:flutter/material.dart';
import '../../../widgets/tabs/main_layout_defi.dart';


class Populaire extends StatefulWidget {
  const Populaire({super.key});

  @override
  State<Populaire> createState() => _PopulaireState();
}

class _PopulaireState extends State<Populaire> {
  int selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    return MainLayoutDefi(
      onFilterSelected: (index) {
        setState(() {
          selectedFilter = index;
        });
      },
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (selectedFilter) {
      case 0:
        return _buildPopulaire();
      case 1:
        return _buildMesDefis();
      case 2:
        return _buildEnvironnement();
      case 3:
        return _buildEducation();
      default:
        return const Center(child: Text("Aucun contenu"));
    }
  }

  Widget _buildPopulaire() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: const [
        // section 1
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Défis Populaires',
            style: TextStyle(color: Color(0xFF1C1C1C), fontSize: (18), fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 19),
        PopulaireCarousel(),
        SizedBox(height: 16),
        // section 2
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Environnement',
            style: TextStyle(color: Color(0xFF1C1C1C), fontSize: (18), fontWeight: FontWeight.w500),
          ),
        ),
        EnvironnementCard(
          imageAsset: 'assets/images/reboisement.png',
          title: 'Journée de Reboisement sur la V...',
          date: '30 août 2025',
          location: 'VDN, Échangeur OMVS',
        ),
        SizedBox(height: 19),
        EnvironnementCard(
          imageAsset: 'assets/images/reboisement.png',
          title: 'Journée de Reboisement sur la V...',
          date: '30 août 2025',
          location: 'VDN, Échangeur OMVS',
        ),
        SizedBox(height: 19),
        EnvironnementCard(
          imageAsset: 'assets/images/reboisement.png',
          title: 'Journée de Reboisement sur la V...',
          date: '30 août 2025',
          location: 'VDN, Échangeur OMVS',
        ),
        SizedBox(height: 19),
      ],
    );
  }

  Widget _buildMesDefis() => const MesDefis();
  Widget _buildEnvironnement() => const Environnement();
  Widget _buildEducation() => const Education();
}
