import 'package:flutter/material.dart';

import '../models/mood_check_in.dart';

/// Wrapping grid of selectable mood chips for the daily check-in.
class MoodSelector extends StatelessWidget {
  const MoodSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final Mood? selected;
  final ValueChanged<Mood> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final mood in Mood.values)
          Semantics(
            button: true,
            selected: mood == selected,
            label: 'Mood ${mood.label}',
            child: Material(
              color: mood == selected
                  ? scheme.primaryContainer
                  : scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => onSelected(mood),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 44),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: mood == selected
                          ? scheme.primary
                          : scheme.outlineVariant,
                      width: mood == selected ? 1.4 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(mood.icon,
                          size: 18,
                          color: mood == selected
                              ? scheme.onPrimaryContainer
                              : scheme.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Text(
                        mood.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              mood == selected ? FontWeight.w600 : null,
                          color: mood == selected
                              ? scheme.onPrimaryContainer
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
