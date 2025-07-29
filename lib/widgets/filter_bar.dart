import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          FilterItem(icon: Icons.grid_view_outlined, label: 'Tout'),
          SizedBox(width: 90),
          FilterItem(icon: Icons.keyboard_voice_outlined, label: 'Podcast'),
          SizedBox(width: 90),
          FilterItem(icon: Icons.article, label: 'Articles'),
          SizedBox(width: 90),
          FilterItem(icon: Icons.headset_outlined, label: 'Audiobooks'),
        ],
      ),
    );
  }
}


class FilterItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const FilterItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: Colors.black),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
