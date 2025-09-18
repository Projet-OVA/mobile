import 'package:SIRA/widgets/banner_profile.dart';
import 'package:flutter/material.dart';
import '../filter_bar_profil.dart';

class MainLayoutProfile extends StatelessWidget {
  final Widget child;
  final ValueChanged<int> onFilterSelected;

  const MainLayoutProfile({
    super.key,
    required this.child,
    required this.onFilterSelected,
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
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 1), // 👈 margin externe
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7), // 👈 padding interne
                    child: FilterBarProfil(onFilterSelected: onFilterSelected),
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
