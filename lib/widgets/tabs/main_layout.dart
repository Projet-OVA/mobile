import 'package:flutter/material.dart';
import '../action.dart';
import '../filter_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final ValueChanged<int> onFilterSelected;

  const MainLayout({
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
            // ActionDart fixe en haut
            const SliverToBoxAdapter(child: ActionDart()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // FilterBar fixe en haut
            SliverToBoxAdapter(child: FilterBar(onFilterSelected: onFilterSelected)),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Contenu filtré scrollable
            SliverFillRemaining(child: child),
          ],
        ),
      ),
    );
  }
}
