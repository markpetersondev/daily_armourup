import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Rounded, softly shadowed surface used across the app.
class PremiumCard extends StatelessWidget {
  const PremiumCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.gradient,
    this.color,
    this.onTap,
    this.borderRadius = AppTheme.radiusCard,
    this.semanticLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;
  final Color? color;
  final VoidCallback? onTap;
  final double borderRadius;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(borderRadius);

    Widget card = DecoratedBox(
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? scheme.surfaceContainer) : null,
        gradient: gradient,
        borderRadius: radius,
        border: Border.all(color: scheme.outlineVariant, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: card,
        ),
      );
    }
    if (semanticLabel != null) {
      card = Semantics(label: semanticLabel, button: onTap != null, child: card);
    }
    return card;
  }
}
