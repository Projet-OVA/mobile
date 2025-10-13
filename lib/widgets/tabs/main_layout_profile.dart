import 'package:SIRA/widgets/banner_profile.dart';
import 'package:flutter/material.dart';
import '../filter_bar_profil.dart';

class MainLayoutProfile extends StatelessWidget {
  final Widget child;
  final ValueChanged<int> onFilterSelected;
  final int initialFilterIndex; // ✅ AJOUTÉ

  const MainLayoutProfile({
    super.key,
    required this.child,
    required this.onFilterSelected,
    this.initialFilterIndex = 0, // ✅ Par défaut 0
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: BannerProfile()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            // FilterBar fixe en haut
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                    child: FilterBarProfil(
                      onFilterSelected: onFilterSelected,
                      initialIndex: initialFilterIndex, // ✅ AJOUTÉ
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            // Contenu filtré scrollable
            SliverFillRemaining(child: child),
          ],
        ),
      ),
    );
  }
}