
import 'package:flutter/material.dart';

class CardStatistique extends StatelessWidget {
  final String number;
  final String label;
  final Color backgroundColor;
  final Color circleColor;
  final String? imagePath;

  const CardStatistique({
    super.key,
    required this.number,
    required this.label,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.circleColor = const Color(0xFFFFFFFF),
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0x43434305),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: imagePath != null
                ? ClipOval(
              child: Image.asset(
                imagePath!,
                width: 16,
                height: 16,
                fit: BoxFit.cover,
              ),
            )
                : Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                number,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF322F35),
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFABAAAC),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}