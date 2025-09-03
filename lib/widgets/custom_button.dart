import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFC113),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            text ?? '', // texte vide si null
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
