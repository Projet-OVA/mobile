import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String? text;
  final Future<void> Function()? onPressed;
  final double borderRadius;
  final IconData? icon;
  final double? width;

  // ✨ Nouveaux paramètres pour padding et boxShadow
  final EdgeInsetsGeometry padding;
  final List<BoxShadow>? boxShadow;

  const CustomButton({
    super.key,
    this.text,
    this.onPressed,
    this.borderRadius = 12,
    this.icon,
    this.width,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.boxShadow,
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
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: widget.width ?? double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: widget.boxShadow ??
              const [
                BoxShadow(
                  color: Color(0xFFE6AE11),
                  offset: Offset(0, 6),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
        ),
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
            elevation: MaterialStateProperty.all<double>(0), // 0 car ombre gérée par Container
            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            padding: MaterialStateProperty.all<EdgeInsets>(
              widget.padding as EdgeInsets, // utilise le padding passé ou défaut
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
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 23, color: const Color(0xFF322F35)),
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
