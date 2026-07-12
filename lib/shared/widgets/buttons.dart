import 'package:flutter/material.dart';

/// Filled brand button — the strongest action on a screen.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final button = icon != null
        ? FilledButton.icon(
            onPressed: onPressed, icon: Icon(icon), label: Text(label))
        : FilledButton(onPressed: onPressed, child: Text(label));
    return Semantics(
      button: true,
      label: label,
      child: expanded ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}

/// Outlined companion action.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final button = icon != null
        ? OutlinedButton.icon(
            onPressed: onPressed, icon: Icon(icon), label: Text(label))
        : OutlinedButton(onPressed: onPressed, child: Text(label));
    return Semantics(
      button: true,
      label: label,
      child: expanded ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}
