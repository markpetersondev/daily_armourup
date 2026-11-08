import 'package:flutter/material.dart';

/// A quiet pointer to real-world help, shown wherever Rescue meets someone in
/// a hard moment. The app offers prayer and Scripture, not crisis care.
class CrisisSupportNote extends StatelessWidget {
  const CrisisSupportNote({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;
    return Semantics(
      container: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.health_and_safety_outlined, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "If you're in danger or thinking about harming yourself, please "
              'contact your local emergency services or someone you trust '
              'right now.',
              style: theme.textTheme.bodySmall?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
