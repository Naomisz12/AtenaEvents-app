import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const PrimaryButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 24),
          minimumSize: const Size.fromHeight(56), 
          shape: const StadiumBorder(),
          elevation: 0,
          textStyle: const TextStyle(
            letterSpacing: 1.4,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(label.toUpperCase()),
      ),
    );
  }
}
