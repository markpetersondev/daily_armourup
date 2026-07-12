import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

/// Calm progress header for guided flows: close button, animated progress
/// bar, and the current step name.
class RescueProgressHeader extends StatelessWidget {
  const RescueProgressHeader({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.stepLabel,
    required this.onClose,
  });

  final int step;
  final int totalSteps;
  final String stepLabel;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 4),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onClose,
                tooltip: 'Leave rescue',
                constraints:
                    const BoxConstraints(minWidth: 44, minHeight: 44),
                icon: const Icon(Icons.close_rounded),
              ),
              Expanded(
                child: Semantics(
                  label: 'Step ${step + 1} of $totalSteps: $stepLabel',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(end: (step + 1) / totalSteps),
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) =>
                          LinearProgressIndicator(
                        value: value,
                        minHeight: 6,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.warmGold),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 44),
            ],
          ),
          Text(
            stepLabel,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
