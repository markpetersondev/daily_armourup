import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/guided_prayer_view.dart';
import '../../../shared/widgets/premium_card.dart';
import '../data/prayer_library.dart';

/// Full prayer page: verse, body, duration, save, "Pray Now" mode, and an
/// optional reflection prompt.
class PrayerDetailScreen extends ConsumerStatefulWidget {
  const PrayerDetailScreen({super.key, required this.prayerId});

  final String prayerId;

  @override
  ConsumerState<PrayerDetailScreen> createState() =>
      _PrayerDetailScreenState();
}

class _PrayerDetailScreenState extends ConsumerState<PrayerDetailScreen> {
  bool _prayingNow = false;

  @override
  Widget build(BuildContext context) {
    final prayer = prayerById(widget.prayerId);
    if (prayer == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('This prayer could not be found.')),
      );
    }
    final theme = Theme.of(context);
    final isSaved = ref.watch(savedPrayersProvider).contains(prayer.id);
    final minutes = (prayer.estimatedDuration.inSeconds / 60).ceil();

    return Scaffold(
      appBar: AppBar(
        title: Text(prayer.title),
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(savedPrayersProvider.notifier).toggle(prayer.id),
            tooltip: isSaved ? 'Remove from saved' : 'Save prayer',
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_outline,
              color: isSaved ? AppColors.warmGold : null,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule,
                        size: 16, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Text(
                      'About $minutes min at a prayerful pace',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                PremiumCard(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Text(
                        '“${prayer.verse.text}”',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(height: 1.5, fontSize: 17),
                      ),
                      const SizedBox(height: 10),
                      Text('— ${prayer.verse.reference}',
                          style: theme.textTheme.titleSmall
                              ?.copyWith(color: AppColors.warmGold)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 350),
                  crossFadeState: _prayingNow
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final line in prayer.lines)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            line,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(fontSize: 19, height: 1.5),
                          ),
                        ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        label: 'Pray Now',
                        icon: Icons.wb_twilight_outlined,
                        onPressed: () =>
                            setState(() => _prayingNow = true),
                      ),
                    ],
                  ),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GuidedPrayerView(lines: prayer.lines),
                      const SizedBox(height: 12),
                      SecondaryButton(
                        label: 'Read normally',
                        onPressed: () =>
                            setState(() => _prayingNow = false),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                PremiumCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.spa_outlined,
                              size: 18, color: AppColors.warmGold),
                          const SizedBox(width: 8),
                          Text('Reflect',
                              style: theme.textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        prayer.reflectionPrompt,
                        style: theme.textTheme.bodyLarge?.copyWith(
                            fontStyle: FontStyle.italic, height: 1.5),
                      ),
                    ],
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
