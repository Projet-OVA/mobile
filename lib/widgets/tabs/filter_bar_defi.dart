import 'package:flutter/material.dart';

class FilterBar extends StatefulWidget {
  final ValueChanged<int> onFilterSelected; // callback vers la page
  final int selectedIndex; // ✅ ajouté

  const FilterBar({
    super.key,
    required this.onFilterSelected,
    this.selectedIndex = 0, // ✅ valeur par défaut
  });

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  late int selectedIndex;

  final List<Map<String, dynamic>> filters = [
    {'label': 'Populaires'},
    {'label': 'Mes Défis'},
    {'label': 'Environnement'},
    {'label': 'Education'},
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex; // ✅ on initialise à la valeur reçue
  }

  @override
  void didUpdateWidget(covariant FilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ✅ si le parent met à jour l’index, on met à jour l’état interne
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      setState(() {
        selectedIndex = widget.selectedIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(filters.length, (index) {
          final item = filters[index];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onFilterSelected(index);
              },
              child: FilterItem(
                label: item['label'],
                isActive: selectedIndex == index,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class FilterItem extends StatelessWidget {
  final String label;
  final bool isActive;

  const FilterItem({
    super.key,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFFC113) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isActive ? Colors.black : Colors.black87,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
