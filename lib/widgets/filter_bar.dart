import 'package:flutter/material.dart';

class FilterBar extends StatefulWidget {
  final ValueChanged<int> onFilterSelected; // callback vers la page

  const FilterBar({super.key, required this.onFilterSelected});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> filters = [
    {'icon': Icons.grid_view_outlined, 'label': 'Parcours'},
    {'icon': Icons.play_circle_outline_outlined, 'label': 'Vidéo'},
    {'icon': Icons.keyboard_voice_outlined, 'label': 'Podcast'},
    {'icon': Icons.article_outlined, 'label': 'Articles'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
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
                icon: item['icon'],
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
  final IconData icon;
  final String label;
  final bool isActive;

  const FilterItem({
    super.key,
    required this.icon,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // centre icône + texte
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis, // évite débordement
            ),
          ),
        ],
      ),
    );
  }
}
