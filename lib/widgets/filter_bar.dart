import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final ValueChanged<int> onFilterSelected;
  final int selectedIndex; // <-- renommé pour plus de clarté

  const FilterBar({
    super.key,
    required this.onFilterSelected,
    required this.selectedIndex,
  });

  final List<Map<String, dynamic>> filters = const [
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
          final bool isActive = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onFilterSelected(index),
              child: FilterItem(
                icon: item['icon'],
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
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isActive ? Colors.black : Colors.grey[800],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
