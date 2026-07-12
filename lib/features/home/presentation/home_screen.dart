import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/models/mood_check_in.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/providers/habit_providers.dart';
import '../../../shared/providers/journal_providers.dart';
import '../../../shared/providers/progress_providers.dart';
import '../../../shared/widgets/mood_selector.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/progress_ring.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/verse_card.dart';

/// Home dashboard: greeting, daily verse, heart check-in, discipline
/// snapshot, quick actions, and the next upcoming reminder.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final verse = ref.watch(dailyVerseProvider);
    final savedVerses = ref.watch(savedVersesProvider);
    final weeklyProgress = ref.watch(weeklyConsistencyProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                _Header(profile: profile, weeklyProgress: weeklyProgress),
                const SizedBox(height: 24),
                VerseCard(
                  verse: verse,
                  isSaved:
                      savedVerses.any((v) => v.reference == verse.reference),
                  onSave: () => ref.read(savedVersesProvider.notifier).toggle(
                      text: verse.text,
                      reference: verse.reference,
                      category: 'Daily Verse'),
                  onShare: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Sharing is on its way in a coming update.')),
                  ),
                  onReflect: () => context.go(AppRoutes.journal),
                ),
                const SizedBox(height: 28),
                const _CheckInCard(),
                const SizedBox(height: 28),
                const _ContinueJourneyCard(),
                const SizedBox(height: 28),
                SectionHeader(
                  title: 'Your walk this week',
                  subtitle: 'Small steps, faithfully taken.',
                  trailing: TextButton(
                    onPressed: () => context.push(AppRoutes.progress),
                    child: const Text('See rhythm'),
                  ),
                ),
                const _DisciplineSnapshot(),
                const SizedBox(height: 28),
                const SectionHeader(title: 'Quick actions'),
                const _QuickActions(),
                const SizedBox(height: 28),
                _UpcomingReminder(prefs: profile.reminderPreferences),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.profile, required this.weeklyProgress});

  final UserProfile profile;
  final double weeklyProgress;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$_greeting, ${profile.displayName}',
                  style: theme.textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(
                'Take a moment to stand firm today.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        ProgressRing(
          progress: weeklyProgress,
          size: 46,
          semanticLabel:
              'Weekly discipline ${(weeklyProgress * 100).round()} percent',
          child: const Icon(Icons.local_fire_department,
              size: 18, color: AppColors.warmGold),
        ),
        const SizedBox(width: 10),
        Semantics(
          button: true,
          label: 'Open profile',
          child: Material(
            color: theme.colorScheme.surfaceContainerHigh,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.go(AppRoutes.profile),
              child: Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                child: Icon(Icons.person_outline,
                    color: theme.colorScheme.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Daily check-in
// ---------------------------------------------------------------------------

class _CheckInCard extends ConsumerWidget {
  const _CheckInCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final todayCheckIn = ref.watch(todayCheckInProvider);

    return PremiumCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite_outline,
                  color: AppColors.gentleRed, size: 20),
              const SizedBox(width: 10),
              Text('How is your heart today?',
                  style: theme.textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 16),
          MoodSelector(
            selected: todayCheckIn?.mood,
            onSelected: (mood) =>
                ref.read(moodCheckInsProvider.notifier).checkIn(mood),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: todayCheckIn == null
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: _MoodResponse(mood: todayCheckIn.mood),
                  ),
          ),
        ],
      ),
    );
  }
}

class _MoodResponse extends StatelessWidget {
  const _MoodResponse({required this.mood});

  final Mood mood;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mood.support,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurface,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonalIcon(
              onPressed: () => mood.actionRoute.startsWith('/prayers') ||
                      mood.actionRoute == '/focus'
                  ? context.push(mood.actionRoute)
                  : context.go(mood.actionRoute),
              style: FilledButton.styleFrom(
                minimumSize: const Size(44, 44),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(mood.actionLabel),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Discipline snapshot
// ---------------------------------------------------------------------------

class _ContinueJourneyCard extends ConsumerWidget {
  const _ContinueJourneyCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final suggestion = ref.watch(journeySuggestionProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Continue your journey'),
        PremiumCard(
          padding: const EdgeInsets.all(20),
          semanticLabel: 'Suggested next step: ${suggestion.message}',
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primaryContainer.withValues(alpha: 0.55),
              theme.colorScheme.surfaceContainer,
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                suggestion.message,
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonalIcon(
                  // Tab destinations switch branches; standalone flows push.
                  onPressed: () => const {
                    AppRoutes.rescue,
                    AppRoutes.scripture,
                    AppRoutes.journal,
                  }.contains(suggestion.route)
                      ? context.go(suggestion.route)
                      : context.push(suggestion.route),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(44, 44),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: Text(suggestion.actionLabel),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DisciplineSnapshot extends ConsumerWidget {
  const _DisciplineSnapshot();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerStreak = ref.watch(prayerStreakProvider);
    final scriptureStreak = ref.watch(scriptureStreakProvider);
    final journalThisWeek = ref.watch(journalEntriesThisWeekProvider);
    final resisted =
        ref.watch(disciplineStatsProvider).temptationsResisted;
    final weeklyProgress = ref.watch(weeklyConsistencyProvider);
    final focusThisWeek = ref.watch(focusSessionsThisWeekProvider);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.wb_twilight_outlined,
                value: '$prayerStreak',
                unit: prayerStreak == 1 ? 'day' : 'days',
                label: 'Prayer streak',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.menu_book_outlined,
                value: '$scriptureStreak',
                unit: scriptureStreak == 1 ? 'day' : 'days',
                label: 'Scripture streak',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.edit_note_outlined,
                value: '$journalThisWeek',
                unit: 'this week',
                label: 'Journal entries',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.shield_outlined,
                value: '$resisted',
                unit: 'resisted',
                label: 'Stood firm',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        PremiumCard(
          padding: const EdgeInsets.all(18),
          onTap: () => context.push(AppRoutes.disciplines),
          semanticLabel: 'Weekly progress. Open spiritual practices.',
          child: Row(
            children: [
              ProgressRing(
                progress: weeklyProgress,
                size: 52,
                strokeWidth: 5,
                child: Text(
                  '${(weeklyProgress * 100).round()}%',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weekly progress',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 3),
                    Text(
                      focusThisWeek > 0
                          ? '$focusThisWeek focus ${focusThisWeek == 1 ? 'session' : 'sessions'} this week. One faithful step at a time.'
                          : 'One faithful step at a time.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.unit,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String unit;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      semanticLabel: '$label: $value $unit',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.warmGold),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: theme.textTheme.headlineMedium),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  unit,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(label,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Quick actions
// ---------------------------------------------------------------------------

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    const actions = [
      (Icons.wb_twilight_outlined, 'Pray Now', 'Come as you are', AppRoutes.prayers),
      (Icons.menu_book_outlined, 'Read Scripture', 'Light for the path', AppRoutes.scripture),
      (Icons.self_improvement_outlined, 'Start Focus Session', 'Be still with God', AppRoutes.focus),
      (Icons.edit_note_outlined, 'Write in Journal', 'Pour out your heart', AppRoutes.journal),
      (Icons.spa_outlined, 'Track Practices', 'One step at a time', AppRoutes.disciplines),
      (Icons.insights_outlined, 'Your Rhythm', 'See your faithful steps', AppRoutes.progress),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: [
        for (final (icon, label, subtitle, route) in actions)
          PremiumCard(
            padding: const EdgeInsets.all(16),
            // Tab destinations switch branches; standalone flows push so
            // the user can come back to Home.
            onTap: () => route == AppRoutes.scripture ||
                    route == AppRoutes.journal
                ? context.go(route)
                : context.push(route),
            semanticLabel: label,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon,
                      size: 21, color: Theme.of(context).colorScheme.primary),
                ),
                const Spacer(),
                Text(label,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Upcoming reminder
// ---------------------------------------------------------------------------

class _UpcomingReminder extends StatelessWidget {
  const _UpcomingReminder({required this.prefs});

  final ReminderPreferences prefs;

  /// Finds the next enabled reminder after the current time, wrapping to
  /// tomorrow if today's are all past.
  (String, String, int)? _next() {
    final entries = <(String, String, int, bool)>[
      ('Morning Start', 'Begin the day anchored in prayer.',
          prefs.morningMinutes, prefs.morningEnabled),
      ('Midday Prayer', 'Pause and reset in the middle of the day.',
          prefs.middayMinutes, prefs.middayEnabled),
      ('Evening Reflection', 'Pause, pray, and release today to God.',
          prefs.eveningMinutes, prefs.eveningEnabled),
      ('Strength Check-In', 'Extra strength at the hour you need it most.',
          prefs.highRiskMinutes, prefs.highRiskEnabled),
    ];
    final enabled = entries.where((e) => e.$4).toList()
      ..sort((a, b) => a.$3.compareTo(b.$3));
    if (enabled.isEmpty) return null;
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final upcoming = enabled.firstWhere(
      (e) => e.$3 > nowMinutes,
      orElse: () => enabled.first, // wraps to tomorrow's earliest
    );
    return (upcoming.$1, upcoming.$2, upcoming.$3);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final next = _next();
    if (next == null) return const SizedBox.shrink();

    final (title, message, minutes) = next;
    final time = DateTime(2000, 1, 1, minutes ~/ 60, minutes % 60);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Coming up'),
        PremiumCard(
          padding: const EdgeInsets.all(20),
          semanticLabel: 'Upcoming reminder: $title',
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.warmGold, AppColors.softGold],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.notifications_active_outlined,
                    color: AppColors.deepCharcoal, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 3),
                    Text(
                      message,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                DateFormat.jm().format(time),
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: AppColors.warmGold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
