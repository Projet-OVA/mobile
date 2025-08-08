import 'package:flutter/material.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({super.key});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> filters = [
    {'icon': Icons.grid_view_outlined, 'label': 'Tout'},
    {'icon': Icons.keyboard_voice_outlined, 'label': 'Podcast'},
    {'icon': Icons.article, 'label': 'Articles'},
    {'icon': Icons.headset_outlined, 'label': 'Audiobooks'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(filters.length, (index) {
          final item = filters[index];
          return Padding(
            padding: const EdgeInsets.only(right: 2),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
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
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: isActive ? Color(0xFFFFF9E8) : Colors.transparent,
      borderRadius: isActive ? BorderRadius.circular(25) : BorderRadius.circular(0),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}
}
