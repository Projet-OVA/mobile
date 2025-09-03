import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController? controller; // maintenant optionnel
  final String? label;                      // maintenant optionnel
  final String? placeholder;                // maintenant optionnel
  final bool obscureText;
  final Color backgroundColor;
  final OutlineInputBorder border;

  const CustomInput({
    Key? key,
    this.controller,       // plus required
    this.label,            // plus required
    this.placeholder,      // plus required
    this.obscureText = false,
    this.backgroundColor = Colors.white,
    this.border = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(
        color: Color(0xFFE4E5E7),
        width: 1,
      ),
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
            filled: true,
            fillColor: backgroundColor,
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
