import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/providers/habit_providers.dart';
import '../../../shared/providers/journal_providers.dart';
import '../../../shared/providers/progress_providers.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/progress_ring.dart';
import '../../../shared/widgets/section_header.dart';

/// “Your Spiritual Rhythm” — a gentle, non-judgmental progress dashboard.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final prayerStreak = ref.watch(prayerStreakProvider);
    final scriptureStreak = ref.watch(scriptureStreakProvider);
    final consistency = ref.watch(weeklyConsistencyProvider);
    final rescues = ref.watch(rescueSessionsCompletedProvider);
    final resisted = ref.watch(disciplineStatsProvider).temptationsResisted;
    final journalThisMonth = ref.watch(journalEntriesThisMonthProvider);
    final focusThisWeek = ref.watch(focusSessionsThisWeekProvider);
    final favouriteCategory = ref.watch(favouriteScriptureCategoryProvider);
    final commonMood = ref.watch(mostCommonMoodThisWeekProvider);
    final week = ref.watch(weekCompletionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Spiritual Rhythm')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                Text(
                  'A rhythm, not a scoreboard. Grace covers every day.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 20),
                PremiumCard(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      ProgressRing(
                        progress: consistency,
                        size: 74,
                        strokeWidth: 7,
                        semanticLabel:
                            'Weekly consistency ${(consistency * 100).round()} percent',
                        child: Text(
                          '${(consistency * 100).round()}%',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Weekly consistency',
                                style: theme.textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text(
                              'How much of this week\'s practices you have '
                              'walked in so far.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const SectionHeader(title: 'Your faithful steps'),
                _StatGrid(items: [
                  _StatItem(Icons.wb_twilight_outlined, '$prayerStreak',
                      prayerStreak == 1 ? 'day' : 'days', 'Prayer streak'),
                  _StatItem(Icons.menu_book_outlined, '$scriptureStreak',
                      scriptureStreak == 1 ? 'day' : 'days',
                      'Scripture streak'),
                  _StatItem(Icons.shield_outlined, '$rescues',
                      'completed', 'Rescue sessions'),
                  _StatItem(Icons.verified_user_outlined, '$resisted',
                      'stood firm', 'Temptations resisted'),
                  _StatItem(Icons.edit_note_outlined, '$journalThisMonth',
                      'this month', 'Journal entries'),
                  _StatItem(Icons.self_improvement_outlined, '$focusThisWeek',
                      'this week', 'Focus sessions'),
                ]),
                const SizedBox(height: 28),
                const SectionHeader(title: 'Your week in reflection'),
                PremiumCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Daily practice completion',
                          style: theme.textTheme.titleMedium),
                      const SizedBox(height: 18),
                      _WeekBars(week: week),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _InsightCard(
                        icon: commonMood?.icon ?? Icons.favorite_outline,
                        title: 'Most common mood',
                        value: commonMood?.label ?? 'No check-ins yet',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InsightCard(
                        icon: Icons.menu_book_outlined,
                        title: 'Favourite Scripture',
                        value: favouriteCategory ?? 'Save a verse to see',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Consistency grows through grace, not pressure.',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
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

class _StatItem {
  const _StatItem(this.icon, this.value, this.unit, this.label);

  final IconData icon;
  final String value;
  final String unit;
  final String label;
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.items});

  final List<_StatItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        for (var row = 0; row < items.length; row += 2) ...[
          if (row > 0) const SizedBox(height: 12),
          Row(
            children: [
              for (var i = row; i < row + 2 && i < items.length; i++) ...[
                if (i > row) const SizedBox(width: 12),
                Expanded(
                  child: PremiumCard(
                    padding: const EdgeInsets.all(16),
                    semanticLabel:
                        '${items[i].label}: ${items[i].value} ${items[i].unit}',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(items[i].icon,
                            size: 20, color: AppColors.warmGold),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(items[i].value,
                                style: theme.textTheme.headlineMedium),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                items[i].unit,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color:
                                        theme.colorScheme.onSurfaceVariant),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(items[i].label,
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

/// Simple seven-day completion bars — custom-drawn, no chart package.
class _WeekBars extends StatelessWidget {
  const _WeekBars({required this.week});

  final List<DayCompletion> week;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SizedBox(
      height: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final day in week)
            Expanded(
              child: Semantics(
                label:
                    '${DateFormat.EEEE().format(day.date)}: ${(day.ratio * 100).round()} percent complete',
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FractionallySizedBox(
                            heightFactor:
                                day.ratio == 0 ? 0.04 : day.ratio.clamp(0.08, 1),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: day.ratio == 0
                                    ? scheme.surfaceContainerHigh
                                    : day.isToday
                                        ? AppColors.warmGold
                                        : AppColors.softGreen
                                            .withValues(alpha: 0.75),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat.E().format(day.date).substring(0, 2),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: day.isToday
                              ? scheme.primary
                              : scheme.onSurfaceVariant,
                          fontWeight: day.isToday ? FontWeight.w700 : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      semanticLabel: '$title: $value',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(height: 12),
          Text(title,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 3),
          Text(value,
              style: theme.textTheme.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
