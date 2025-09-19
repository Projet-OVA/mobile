import 'package:flutter/material.dart';
import '../../widgets/tabs/filter_bar_mesdefis.dart';
import '../../widgets/tabs/environnement_card.dart';
import '../../screens/tabs/recompense.dart';

class MesDefis extends StatefulWidget {
  const MesDefis({super.key});

  @override
  State<MesDefis> createState() => _MesDefisState();
}

class _MesDefisState extends State<MesDefis> {
  int selectedFilter = 0;

  void onFilterSelected(int index) {
    setState(() {
      selectedFilter = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // FilterBar toujours en haut
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 1), // 👈 margin externe
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7), // 👈 padding interne
              child: FilterBarMesdefis(onFilterSelected: onFilterSelected),
            ),
          ),
        ),
        // Contenu en dessous
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (selectedFilter) {
      case 0:
        return _buildPresente();
      case 1:
        return _buildDefiCree();
      default:
        return const Center(child: Text("Aucun contenu"));
    }
  }

  Widget _buildPresente() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 7),
      children: const [
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
      ],
    );
  }

  Widget _buildDefiCree() => const Recompense();
}
