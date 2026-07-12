import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/premium_card.dart';
import '../data/prayer_library.dart';

/// Browsable library of guided prayers.
class PrayerLibraryScreen extends ConsumerWidget {
  const PrayerLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final saved = ref.watch(savedPrayersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Library')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                Text(
                  'Guided prayers for every season of the heart. '
                  'Come as you are.',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 20),
                for (final prayer in prayerLibrary)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PrayerCard(
                      prayer: prayer,
                      isSaved: saved.contains(prayer.id),
                      onTap: () =>
                          context.push('/prayers/${prayer.id}'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Summary card for one prayer in the library.
class PrayerCard extends StatelessWidget {
  const PrayerCard({
    super.key,
    required this.prayer,
    required this.isSaved,
    required this.onTap,
  });

  final Prayer prayer;
  final bool isSaved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minutes = (prayer.estimatedDuration.inSeconds / 60).ceil();
    return PremiumCard(
      onTap: onTap,
      semanticLabel: prayer.title,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(prayer.icon,
                size: 22, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(prayer.title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(
                  '${prayer.verse.reference} · about $minutes min',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          if (isSaved)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child:
                  Icon(Icons.bookmark, size: 18, color: AppColors.warmGold),
            ),
          Icon(Icons.arrow_forward_ios_rounded,
              size: 15, color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
