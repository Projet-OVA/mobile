import 'package:flutter/material.dart';

class FilterBarCommunity extends StatefulWidget {
  final ValueChanged<int> onFilterSelected; // callback vers la page
  final int selectedIndex;

  const FilterBarCommunity({
    super.key,
    required this.onFilterSelected,
    required this.selectedIndex,
  });

  @override
  State<FilterBarCommunity> createState() => _FilterBarCommunityState();
}

class _FilterBarCommunityState extends State<FilterBarCommunity> {
  late int selectedIndex;

  final List<Map<String, dynamic>> filters = [
    {'label': 'Populaire'},
    {'label': 'Mes Postes'},
    {'label': 'Forum'},
    {'label': 'Enregistrer'},
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant FilterBarCommunity oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ✅ Si le parent change l'index (restauration), on le synchronise
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
          final bool isActive = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onFilterSelected(index); // ✅ appelle le callback parent
              },
              child: FilterItem(
                label: item['label'],
                isActive: isActive,
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
