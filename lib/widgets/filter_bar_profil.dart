import 'package:flutter/material.dart';

class FilterBarProfil extends StatefulWidget {
  final ValueChanged<int> onFilterSelected; // callback vers la page

  const FilterBarProfil({super.key, required this.onFilterSelected});

  @override
  State<FilterBarProfil> createState() => _FilterBarProfilState();
}

class _FilterBarProfilState extends State<FilterBarProfil> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> filters = [
    {'label': 'Progression'},
    {'label': 'Récompense'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(filters.length, (index) {
          final item = filters[index];
          return Expanded( // chaque item prend la même largeur
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
          color: isActive ? Colors.white : Colors.transparent, // transparent quand inactif
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF000000)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
  }

}