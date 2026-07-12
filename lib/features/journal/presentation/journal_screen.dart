import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/models/journal_entry.dart';
import '../../../shared/providers/journal_providers.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/premium_card.dart';
import '../widgets/journal_entry_card.dart';

/// Private journal: entries, search, filters, and answered prayers.
class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final _searchController = TextEditingController();
  bool _searching = false;
  bool _showingAnswered = false;
  JournalEntryType? _filter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<JournalEntry> _visibleEntries(List<JournalEntry> all) {
    var entries = all;
    if (_filter != null) {
      entries = entries.where((e) => e.type == _filter).toList();
    }
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      entries = entries
          .where((e) =>
              e.title.toLowerCase().contains(query) ||
              e.content.toLowerCase().contains(query) ||
              e.verseReference.toLowerCase().contains(query))
          .toList();
    }
    return entries;
  }

  Future<void> _confirmDelete(JournalEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this entry?'),
        content: const Text(
            'This entry will be removed from your journal. This cannot be undone.'),
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
      await ref.read(journalEntriesProvider.notifier).delete(entry.id);
    }
  }

  Future<void> _markAnswered(JournalEntry entry) async {
    await ref.read(journalEntriesProvider.notifier).markAnswered(entry.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Moved to Answered Prayers. What a faithful God.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allEntries = ref.watch(journalEntriesProvider);
    final answered = ref.watch(answeredPrayersProvider);

    return Scaffold(
      appBar: AppBar(
        title: _searching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search your journal…',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                ),
                onChanged: (_) => setState(() {}),
              )
            : const Text('Journal'),
        actions: [
          IconButton(
            tooltip: _searching ? 'Close search' : 'Search entries',
            icon: Icon(_searching ? Icons.close : Icons.search),
            onPressed: () => setState(() {
              _searching = !_searching;
              if (!_searching) _searchController.clear();
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.journalNew),
        icon: const Icon(Icons.add),
        label: const Text('Add Entry'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Write what is on your heart.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 14),
                      SegmentedButton<bool>(
                        segments: [
                          const ButtonSegment(
                            value: false,
                            icon: Icon(Icons.edit_note_outlined),
                            label: Text('Entries'),
                          ),
                          ButtonSegment(
                            value: true,
                            icon: const Icon(Icons.auto_awesome_outlined),
                            label: Text('Answered (${answered.length})'),
                          ),
                        ],
                        selected: {_showingAnswered},
                        onSelectionChanged: (selection) =>
                            setState(() => _showingAnswered = selection.first),
                        style: SegmentedButton.styleFrom(
                          minimumSize: const Size(44, 44),
                          selectedBackgroundColor:
                              theme.colorScheme.primaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _showingAnswered
                      ? _AnsweredPrayersView(
                          answered: answered,
                          onTap: (e) =>
                              context.push('${AppRoutes.journal}/edit/${e.id}'),
                          onDelete: _confirmDelete,
                        )
                      : _EntriesView(
                          entries: _visibleEntries(allEntries),
                          hasAnyEntries: allEntries.isNotEmpty,
                          filter: _filter,
                          onFilterChanged: (f) => setState(() => _filter = f),
                          onTap: (e) =>
                              context.push('${AppRoutes.journal}/edit/${e.id}'),
                          onMarkAnswered: _markAnswered,
                          onDelete: _confirmDelete,
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

class _EntriesView extends StatelessWidget {
  const _EntriesView({
    required this.entries,
    required this.hasAnyEntries,
    required this.filter,
    required this.onFilterChanged,
    required this.onTap,
    required this.onMarkAnswered,
    required this.onDelete,
  });

  final List<JournalEntry> entries;
  final bool hasAnyEntries;
  final JournalEntryType? filter;
  final ValueChanged<JournalEntryType?> onFilterChanged;
  final ValueChanged<JournalEntry> onTap;
  final ValueChanged<JournalEntry> onMarkAnswered;
  final ValueChanged<JournalEntry> onDelete;

  @override
  Widget build(BuildContext context) {
    if (!hasAnyEntries) {
      return EmptyState(
        icon: Icons.edit_note_outlined,
        title: 'No entries yet',
        message: 'Begin by writing what is on your heart. '
            'Every faithful word counts.',
        actionLabel: 'Write your first entry',
        onAction: () => context.push(AppRoutes.journalNew),
      );
    }
    return Column(
      children: [
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: filter == null,
                  label: const Text('All'),
                  onSelected: (_) => onFilterChanged(null),
                ),
              ),
              for (final type in JournalEntryType.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: filter == type,
                    avatar: filter == type ? null : Icon(type.icon, size: 16),
                    label: Text(type.label),
                    onSelected: (_) =>
                        onFilterChanged(filter == type ? null : type),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: entries.isEmpty
              ? const EmptyState(
                  icon: Icons.search_off_outlined,
                  title: 'Nothing here yet',
                  message:
                      'No entries match this view. Try a different filter or search.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return JournalEntryCard(
                      entry: entry,
                      onTap: () => onTap(entry),
                      onMarkAnswered: entry.type == JournalEntryType.prayer &&
                              !entry.countsAsAnswered
                          ? () => onMarkAnswered(entry)
                          : null,
                      onDelete: () => onDelete(entry),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _AnsweredPrayersView extends StatelessWidget {
  const _AnsweredPrayersView({
    required this.answered,
    required this.onTap,
    required this.onDelete,
  });

  final List<JournalEntry> answered;
  final ValueChanged<JournalEntry> onTap;
  final ValueChanged<JournalEntry> onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (answered.isEmpty) {
      return const EmptyState(
        icon: Icons.auto_awesome_outlined,
        title: 'No answered prayers yet',
        message: 'When a prayer is answered, mark it here — '
            'a record of what God has carried you through.',
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
      children: [
        PremiumCard(
          padding: const EdgeInsets.all(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.warmGold.withValues(alpha: 0.18),
              theme.colorScheme.surfaceContainer,
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.warmGold),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${answered.length} answered ${answered.length == 1 ? 'prayer' : 'prayers'}',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Remember what God has carried you through.',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        for (final (index, entry) in answered.indexed) ...[
          _TimelineTile(
            entry: entry,
            isLast: index == answered.length - 1,
            onTap: () => onTap(entry),
            onDelete: () => onDelete(entry),
          ),
        ],
      ],
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.entry,
    required this.isLast,
    required this.onTap,
    required this.onDelete,
  });

  final JournalEntry entry;
  final bool isLast;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                    color: AppColors.warmGold,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.warmGold.withValues(alpha: 0.35),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: PremiumCard(
                padding: const EdgeInsets.all(16),
                onTap: onTap,
                semanticLabel: 'Answered prayer: ${entry.title}',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMd().format(entry.date),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.warmGold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.title.isEmpty ? 'Answered Prayer' : entry.title,
                      style: theme.textTheme.titleMedium,
                    ),
                    if (entry.content.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        entry.content.trim(),
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.45),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (entry.verseReference.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.menu_book_outlined,
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 5),
                          Text(entry.verseReference,
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ],
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
