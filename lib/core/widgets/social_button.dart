import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? bg;
  final Color? fg;
  final VoidCallback? onPressed;
  const SocialButton({
    super.key,
    required this.icon,
    required this.label,
    this.bg,
    this.fg,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        style: ElevatedButton.styleFrom(
          backgroundColor: bg ?? Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: fg ?? Theme.of(context).colorScheme.onPrimaryContainer,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        label: Text(label),
      ),
    );
  }
}