import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../shared/models/spiritual_habit.dart';
import '../../../shared/providers/habit_providers.dart';

/// Manage practices: reorder, switch on or off, edit, and delete custom ones.
class ManagePracticesScreen extends ConsumerWidget {
  const ManagePracticesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final habits = ref.watch(spiritualHabitsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Practices')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                  child: Text(
                    'Drag to reorder. Switch a practice off to rest it — '
                    'its history is kept.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
                Expanded(
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                    itemCount: habits.length,
                    onReorder: (oldIndex, newIndex) => ref
                        .read(spiritualHabitsProvider.notifier)
                        .reorder(oldIndex, newIndex),
                    itemBuilder: (context, index) {
                      final habit = habits[index];
                      return _ManageTile(key: ValueKey(habit.id), habit: habit);
                    },
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

class _ManageTile extends ConsumerWidget {
  const _ManageTile({super.key, required this.habit});

  final SpiritualHabit habit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
        leading: Icon(habit.icon,
            color: habit.isEnabled
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant),
        title: Text(habit.title),
        subtitle: Text(
          habit.isCustom
              ? '${habit.frequency.label} · custom'
              : habit.frequency.label,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: habit.isEnabled,
              onChanged: (v) => ref
                  .read(spiritualHabitsProvider.notifier)
                  .setEnabled(habit.id, v),
            ),
            PopupMenuButton<String>(
              tooltip: 'Practice options',
              onSelected: (value) async {
                switch (value) {
                  case 'edit':
                    context.push(AppRoutes.disciplinesNew, extra: habit.id);
                  case 'delete':
                    await _confirmDelete(context, ref);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                if (habit.isCustom)
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${habit.title}?'),
        content: const Text(
            'This removes the practice and its history. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep it'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(spiritualHabitsProvider.notifier).deleteCustom(habit.id);
    }
  }
}
