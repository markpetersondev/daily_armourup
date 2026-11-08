import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/premium_card.dart';
import '../data/rescue_content.dart';
// import '../widgets/crisis_support_note.dart';

/// Rescue start: a calm landing with category cards that open the guided flow.
class RescueScreen extends StatelessWidget {
  const RescueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.warmGold.withValues(alpha: 0.22),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: const AppLogo(size: 84),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'You are not alone in this moment.',
                  style: theme.textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Pause. Breathe. Pray. Take the next faithful step.',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Text('What are you facing right now?',
                    style: theme.textTheme.titleLarge),
                const SizedBox(height: 14),
                for (final category in RescueCategory.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: RescueCategoryCard(
                      category: category,
                      onTap: () =>
                          context.push('/rescue/flow', extra: category),
                    ),
                  ),
                const SizedBox(height: 18),
                PremiumCard(
                  onTap: () => context.push('/prayers'),
                  semanticLabel: 'Open Prayer Library',
                  padding: const EdgeInsets.all(18),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.forestGreen, AppColors.deepOlive],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.wb_twilight_outlined,
                          color: AppColors.softGold, size: 26),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Prayer Library',
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(color: AppColors.warmWhite)),
                            const SizedBox(height: 2),
                            Text(
                              'Guided prayers for every moment.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.softSage),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_rounded,
                          color: AppColors.softGold),
                    ],
                  ),
                ),
                // Hidden for the MVP release; see docs/IOS_SETUP.md step 4.9.
                // const SizedBox(height: 24),
                // const CrisisSupportNote(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Selectable card for one rescue category.
class RescueCategoryCard extends StatelessWidget {
  const RescueCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    this.selected = false,
  });

  final RescueCategory category;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: category.label,
      child: Material(
        color: selected ? scheme.primaryContainer : scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 60),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? scheme.primary : scheme.outlineVariant,
                width: selected ? 1.6 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(category.icon,
                      size: 21, color: AppColors.warmGold),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    category.label,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 15, color: scheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
