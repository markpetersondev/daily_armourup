import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/providers/habit_providers.dart';
import '../../../shared/providers/journal_providers.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_header.dart';

/// Profile: identity, journey summaries, settings, My Armour, and reset.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final theme = Theme.of(context);
    final savedVerses = ref.watch(savedVersesProvider);
    final journalCount = ref.watch(journalEntriesProvider).length;
    final enabledHabits = ref.watch(enabledHabitsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                // Identity
                PremiumCard(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.warmGold, AppColors.softGold],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          profile.displayName
                              .substring(0, 1)
                              .toUpperCase(),
                          style: theme.textTheme.headlineMedium
                              ?.copyWith(color: AppColors.deepCharcoal),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(profile.displayName,
                                style: theme.textTheme.headlineSmall),
                            const SizedBox(height: 4),
                            Text(
                              'One faithful step at a time.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Edit profile',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => context.push(AppRoutes.profileEdit),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Journey
                const SectionHeader(title: 'Your journey'),
                PremiumCard(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  child: Column(
                    children: [
                      _navTile(
                        context,
                        icon: Icons.shield_outlined,
                        color: AppColors.warmGold,
                        title: 'My Armour',
                        subtitle: 'The armour of God, piece by piece',
                        onTap: () => context.push(AppRoutes.armour),
                      ),
                      _navTile(
                        context,
                        icon: Icons.insights_outlined,
                        color: AppColors.softGreen,
                        title: 'Your Spiritual Rhythm',
                        subtitle: 'Streaks, consistency, and reflection',
                        onTap: () => context.push(AppRoutes.progress),
                      ),
                      _navTile(
                        context,
                        icon: Icons.spa_outlined,
                        color: theme.colorScheme.primary,
                        title: 'Spiritual Practices',
                        subtitle:
                            '${enabledHabits.length} active ${enabledHabits.length == 1 ? 'practice' : 'practices'}',
                        onTap: () => context.push(AppRoutes.disciplines),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Summaries
                if (profile.focusAreas.isNotEmpty) ...[
                  const SectionHeader(title: 'Focus areas'),
                  PremiumCard(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final area in profile.focusAreas)
                          Chip(
                            label: Text(area),
                            avatar: const Icon(Icons.shield_outlined,
                                size: 16, color: AppColors.warmGold),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
                if (profile.spiritualGoals.isNotEmpty) ...[
                  const SectionHeader(title: 'Spiritual goals'),
                  PremiumCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    child: Column(
                      children: [
                        for (final goal in profile.spiritualGoals)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.check_circle_outline,
                                color: AppColors.softGreen),
                            title: Text(goalLabel(goal.id)),
                            subtitle: Text(goal.frequency.label),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                ],

                // Appearance
                const SectionHeader(title: 'Appearance'),
                PremiumCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Column(
                    children: [
                      for (final mode in ThemeMode.values)
                        RadioListTile<ThemeMode>(
                          value: mode,
                          groupValue: profile.selectedThemeMode,
                          onChanged: (m) {
                            if (m != null) {
                              ref
                                  .read(userProfileProvider.notifier)
                                  .setThemeMode(m);
                            }
                          },
                          title: Text(switch (mode) {
                            ThemeMode.system => 'Match device',
                            ThemeMode.light => 'Light — warm cream',
                            ThemeMode.dark => 'Dark — deep charcoal',
                          }),
                          activeColor: theme.colorScheme.primary,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Privacy
                const SectionHeader(title: 'Privacy'),
                PremiumCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: profile.journalLockEnabled,
                        onChanged: (v) => ref
                            .read(userProfileProvider.notifier)
                            .update(profile.copyWith(journalLockEnabled: v)),
                        secondary: const Icon(Icons.lock_outline,
                            color: AppColors.warmGold),
                        title: const Text('Journal Privacy Lock'),
                        subtitle: const Text(
                            'Add an extra layer of privacy before opening '
                            'your journal. This is an app setting, not device '
                            'security.'),
                      ),
                      const Divider(height: 1),
                      const ListTile(
                        leading: Icon(Icons.phonelink_lock_outlined),
                        title: Text('Stored on this device'),
                        subtitle: Text(
                            'Your journal, habits, and reflections are stored '
                            'on this device. Nothing is uploaded.'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // About + summaries + reset
                const SectionHeader(title: 'About'),
                PremiumCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.menu_book_outlined),
                        title: const Text('Saved verses'),
                        trailing: Text('${savedVerses.length}',
                            style: theme.textTheme.titleMedium),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.edit_note_outlined),
                        title: const Text('Journal entries'),
                        trailing: Text('$journalCount',
                            style: theme.textTheme.titleMedium),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text(AppStrings.appName),
                        subtitle: const Text('Version 1.0.0 · Stand firm. Pray first.'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.privacy_tip_outlined),
                        title: const Text('Privacy Policy'),
                        trailing: const Icon(Icons.open_in_new, size: 18),
                        onTap: () => launchUrl(
                          Uri.parse(AppStrings.privacyPolicyUrl),
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                PremiumCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: Icon(Icons.delete_forever_outlined,
                        color: theme.colorScheme.error),
                    title: Text('Reset all app data',
                        style:
                            TextStyle(color: theme.colorScheme.error)),
                    subtitle: const Text(
                        'Deletes your profile, habits, journal, saved verses, '
                        'and progress from this device.'),
                    onTap: () => _confirmReset(context, ref),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Your journey is private and saved on this device.',
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

  Widget _navTile(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon, size: 21, color: color),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(Icons.warning_amber_rounded,
            color: Theme.of(dialogContext).colorScheme.error, size: 32),
        title: const Text('Reset all app data?'),
        content: const Text(
            'This permanently deletes your profile, spiritual practices, '
            'journal entries, saved verses, and all progress from this '
            'device, and returns you to the beginning.\n\n'
            'This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep my data'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor:
                    Theme.of(dialogContext).colorScheme.error),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete everything'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    await ref.read(localStorageProvider).clearAll();
    // Rebuild every stateful provider from the now-empty storage.
    ref.invalidate(userProfileProvider);
    ref.invalidate(moodCheckInsProvider);
    ref.invalidate(disciplineStatsProvider);
    ref.invalidate(savedVersesProvider);
    ref.invalidate(rescueSessionsProvider);
    ref.invalidate(focusSessionsProvider);
    ref.invalidate(savedPrayersProvider);
    ref.invalidate(journalEntriesProvider);
    ref.invalidate(spiritualHabitsProvider);
    if (context.mounted) context.go(AppRoutes.onboarding);
  }
}

/// Human-readable labels for goal ids selected during onboarding.
String goalLabel(String id) => switch (id) {
      'pray_daily' => 'Pray daily',
      'read_scripture' => 'Read Scripture daily',
      'journal_weekly' => 'Journal weekly',
      'gratitude' => 'Practice gratitude',
      'memorise_verses' => 'Memorise Bible verses',
      'reduce_distraction' => 'Reduce distraction time',
      'fasting' => 'Join a fasting routine',
      _ => id,
    };
