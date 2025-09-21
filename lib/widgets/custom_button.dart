import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String? text;
  final Future<void> Function()? onPressed;
  final double borderRadius;
  final IconData? icon;
  final double? width;

  const CustomButton({
    super.key,
    this.text,
    this.onPressed,
    this.borderRadius = 12,
    this.icon,
    this.width,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (widget.onPressed != null && !_isLoading) {
      setState(() => _isLoading = true);
      try {
        await widget.onPressed!();
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: widget.width ?? double.infinity,
        child: ElevatedButton(
          onPressed: _handlePress,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled) || _isLoading) {
                  return const Color(0xFFFFD971); // couleur bouton inactif
                }
                return const Color(0xFFFFC113); // couleur bouton actif
              },
            ),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 16),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 2,
            ),
          )
              : Row(
            mainAxisSize: MainAxisSize.min, // 👈 prend juste la place nécessaire
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 30, color: Color(0xFF322F35)),
                const SizedBox(width: 7),
              ],
              Text(
                widget.text ?? '',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
