import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final TextEditingController? controller; // optionnel
  final String? label;                      // optionnel
  final String? placeholder;                // optionnel
  final bool obscureText;
  final Color backgroundColor;
  final OutlineInputBorder border;

  const CustomInput({
    Key? key,
    this.controller,
    this.label,
    this.placeholder,
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
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late bool _obscure; // état interne pour show/hide password

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText; // initialisation
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        const SizedBox(height: 6),
        TextField(
          controller: widget.controller,
          obscureText: _obscure,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
            filled: true,
            fillColor: widget.backgroundColor,
            border: widget.border,
            enabledBorder: widget.border,
            focusedBorder: widget.border.copyWith(
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscure = !_obscure;
                });
              },
            )
                : null,
          ),
        ),
      ],
    );
  }
}
