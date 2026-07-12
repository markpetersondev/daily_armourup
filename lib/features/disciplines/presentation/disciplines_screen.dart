import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/models/spiritual_habit.dart';
import '../../../shared/providers/habit_providers.dart';
import '../../../shared/providers/progress_providers.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_header.dart';
import 'manage_practices_screen.dart';

const _encouragements = [
  'One faithful step at a time.',
  'Small acts of faith build a steady life.',
  'Consistency grows through grace, not pressure.',
  'Begin again today.',
  'Faithfulness is built in quiet moments.',
];

/// Spiritual discipline tracker: weekly rhythm and daily practices.
class DisciplinesScreen extends ConsumerWidget {
  const DisciplinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final habits = ref.watch(enabledHabitsProvider);
    final week = ref.watch(weekCompletionProvider);
    final encouragement =
        _encouragements[DateTime.now().day % _encouragements.length];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spiritual Practices'),
        actions: [
          IconButton(
            tooltip: 'Manage practices',
            icon: const Icon(Icons.tune),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const ManagePracticesScreen())),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.disciplinesNew),
        icon: const Icon(Icons.add),
        label: const Text('Add Practice'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: habits.isEmpty
                ? EmptyState(
                    icon: Icons.spa_outlined,
                    title: 'No practices yet',
                    message: 'Your next faithful step can begin now. '
                        'Add a practice or turn one on in Manage.',
                    actionLabel: 'Add a practice',
                    onAction: () => context.push(AppRoutes.disciplinesNew),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                    children: [
                      Text(
                        encouragement,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 18),
                      WeekOverview(week: week),
                      const SizedBox(height: 26),
                      const SectionHeader(
                        title: 'Today\'s practices',
                        subtitle: 'Mark what you have walked in today.',
                      ),
                      for (final habit in habits) ...[
                        _HabitCard(habit: habit),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Seven-day rhythm row with today highlighted.
class WeekOverview extends StatelessWidget {
  const WeekOverview({super.key, required this.week});

  final List<DayCompletion> week;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 14),
            child: Text('Your week', style: theme.textTheme.titleMedium),
          ),
          Row(
            children: [
              for (final day in week)
                Expanded(child: _DayCircle(day: day)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayCircle extends StatelessWidget {
  const _DayCircle({required this.day});

  final DayCompletion day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final complete = day.target > 0 && day.completed >= day.target;
    final partial = day.completed > 0 && !complete;

    return Semantics(
      button: true,
      label:
          '${DateFormat.EEEE().format(day.date)}: ${day.completed} of ${day.target} practices',
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(day.completed == 0
                ? '${DateFormat.MMMEd().format(day.date)} — nothing marked. Grace covers every day.'
                : '${DateFormat.MMMEd().format(day.date)} — ${day.completed} of ${day.target} practices complete.'),
          )),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Text(
                DateFormat.E().format(day.date).substring(0, 2),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: day.isToday ? scheme.primary : scheme.onSurfaceVariant,
                  fontWeight: day.isToday ? FontWeight.w700 : null,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: complete
                      ? AppColors.softGreen
                      : partial
                          ? AppColors.softGreen.withValues(alpha: 0.25)
                          : scheme.surfaceContainerHigh,
                  border: Border.all(
                    color: day.isToday
                        ? scheme.primary
                        : complete
                            ? AppColors.softGreen
                            : scheme.outlineVariant,
                    width: day.isToday ? 2 : 1,
                  ),
                ),
                child: complete
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : partial
                        ? Center(
                            child: Text(
                              '${day.completed}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: scheme.onSurface),
                            ),
                          )
                        : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HabitCard extends ConsumerWidget {
  const _HabitCard({required this.habit});

  final SpiritualHabit habit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final done = habit.isCompletedToday;
    final streak = habit.currentStreak;

    return PremiumCard(
      padding: const EdgeInsets.all(16),
      onTap: () => _showDetail(context, ref),
      semanticLabel:
          '${habit.title}. ${done ? 'Completed today' : 'Not yet today'}. '
          'Streak $streak.',
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: done
                  ? AppColors.softGreen.withValues(alpha: 0.18)
                  : scheme.primaryContainer.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(habit.icon,
                size: 22, color: done ? AppColors.softGreen : scheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(habit.title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (streak > 0) ...[
                      const Icon(Icons.local_fire_department,
                          size: 14, color: AppColors.warmGold),
                      const SizedBox(width: 3),
                      Text(
                        habit.frequency.name == 'daily'
                            ? '$streak-day streak'
                            : '$streak-week streak',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: AppColors.warmGold),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Flexible(
                      child: Text(
                        '${habit.completionsThisWeek}/${habit.weeklyTarget} this week · ${habit.frequency.label}',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: scheme.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Semantics(
            button: true,
            label: done
                ? 'Unmark ${habit.title} for today'
                : 'Mark ${habit.title} complete for today',
            child: Material(
              color: done ? AppColors.softGreen : scheme.surfaceContainerHigh,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => ref
                    .read(spiritualHabitsProvider.notifier)
                    .toggleCompleted(habit.id),
                child: Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  child: Icon(
                    done ? Icons.check : Icons.circle_outlined,
                    color: done ? Colors.white : scheme.onSurfaceVariant,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => _HabitDetailSheet(habitId: habit.id),
    );
  }
}

class _HabitDetailSheet extends ConsumerWidget {
  const _HabitDetailSheet({required this.habitId});

  final String habitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final habit = ref
        .watch(spiritualHabitsProvider)
        .cast<SpiritualHabit?>()
        .firstWhere((h) => h?.id == habitId, orElse: () => null);
    if (habit == null) return const SizedBox.shrink();

    final recent = habit.recentCompletions.take(7).toList();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(habit.icon, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(habit.title,
                      style: theme.textTheme.headlineSmall),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${habit.frequency.label} · '
              '${habit.completionsThisWeek} of ${habit.weeklyTarget} this week · '
              '${habit.currentStreak > 0 ? 'streak of ${habit.currentStreak}' : 'ready to begin again'}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            if (recent.isEmpty)
              Text(
                'No completions yet. Begin again today — '
                'consistency grows through grace, not pressure.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              )
            else ...[
              Text('Recent completions', style: theme.textTheme.titleSmall),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final d in recent)
                    Chip(
                      avatar: const Icon(Icons.check_circle_outline,
                          size: 16, color: AppColors.softGreen),
                      label: Text(DateFormat.MMMEd().format(d)),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.push(AppRoutes.disciplinesNew, extra: habit.id);
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmReset(context, ref, habit),
                    icon: const Icon(Icons.restart_alt, size: 18),
                    label: const Text('Reset history'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmReset(
      BuildContext context, WidgetRef ref, SpiritualHabit habit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset ${habit.title}?'),
        content: const Text(
            'This clears the completion history and streak for this practice '
            'only. Other practices are untouched.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep history'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(spiritualHabitsProvider.notifier).resetHistory(habit.id);
      if (context.mounted) Navigator.of(context).pop();
    }
  }
}
