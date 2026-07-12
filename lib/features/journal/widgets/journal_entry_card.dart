import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/models/journal_entry.dart';
import '../../../shared/widgets/premium_card.dart';

/// One journal entry in the list: type, title, preview, date, mood, verse.
class JournalEntryCard extends StatelessWidget {
  const JournalEntryCard({
    super.key,
    required this.entry,
    required this.onTap,
    this.onMarkAnswered,
    required this.onDelete,
  });

  final JournalEntry entry;
  final VoidCallback onTap;

  /// Non-null only for prayers that can still be marked as answered.
  final VoidCallback? onMarkAnswered;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return PremiumCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 8, 16),
      onTap: onTap,
      semanticLabel: '${entry.type.label}: ${entry.title}',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: entry.countsAsAnswered
                  ? AppColors.warmGold.withValues(alpha: 0.18)
                  : scheme.primaryContainer.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              entry.type.icon,
              size: 21,
              color: entry.countsAsAnswered
                  ? AppColors.warmGold
                  : scheme.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.title.isEmpty ? entry.type.label : entry.title,
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (entry.countsAsAnswered)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Icon(Icons.auto_awesome,
                            size: 16, color: AppColors.warmGold),
                      ),
                  ],
                ),
                if (entry.content.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    entry.content.trim(),
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant, height: 1.45),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      DateFormat.MMMd().format(entry.date),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    if (entry.mood != null)
                      _MiniChip(
                          icon: entry.mood!.icon, label: entry.mood!.label),
                    if (entry.verseReference.isNotEmpty)
                      _MiniChip(
                          icon: Icons.menu_book_outlined,
                          label: entry.verseReference),
                    if (entry.countsAsAnswered)
                      const _MiniChip(
                          icon: Icons.auto_awesome_outlined,
                          label: 'Answered',
                          gold: true),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Entry options',
            icon: Icon(Icons.more_vert, color: scheme.onSurfaceVariant),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  onTap();
                case 'answered':
                  onMarkAnswered?.call();
                case 'delete':
                  onDelete();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text('Edit'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              if (onMarkAnswered != null)
                const PopupMenuItem(
                  value: 'answered',
                  child: ListTile(
                    leading: Icon(Icons.auto_awesome_outlined),
                    title: Text('Mark as answered'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text('Delete'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.icon, required this.label, this.gold = false});

  final IconData icon;
  final String label;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = gold ? AppColors.warmGold : scheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: gold
            ? AppColors.warmGold.withValues(alpha: 0.14)
            : scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: theme.textTheme.bodySmall
                  ?.copyWith(fontSize: 11, color: color)),
        ],
      ),
    );
  }
}
