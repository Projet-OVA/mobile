import 'package:SIRA/screens/tabs/education.dart';
import 'package:SIRA/screens/tabs/environnement.dart';
import 'package:SIRA/screens/tabs/mes_defis.dart';
import 'package:SIRA/widgets/tabs/environnement_card.dart';
import 'package:SIRA/widgets/tabs/main_layout_community.dart';
import 'package:SIRA/widgets/tabs/populaire_carousel.dart';
import 'package:flutter/material.dart';


class PopulaireCommunity extends StatefulWidget {
  const PopulaireCommunity({super.key});

  @override
  State<PopulaireCommunity> createState() => _PopulaireCommunityState();
}

class _PopulaireCommunityState extends State<PopulaireCommunity> {
  int selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    return MainLayoutCommunity(
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
        return _buildPopulaires();
      case 1:
        return _buildMesPostes();
      case 2:
        return _buildForum();
      case 3:
        return _buildEnregistrer();
      default:
        return const Center(child: Text("Aucun contenu"));
    }
  }

  Widget _buildPopulaires() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      Center: Text(
        'Populaire',
        style: TextStyle(color: Color(0xFF1C1C1C), fontSize: (18), fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildMesPostes() => const MesDefis();
  Widget _buildForum() => const Environnement();
  Widget _buildEnregistrer() => const Education();
}
