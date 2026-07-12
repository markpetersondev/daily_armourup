import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../providers/app_providers.dart';
import 'premium_card.dart';

/// A verse card with save, copy, note, and pray actions — used across the
/// Scripture library and rescue-related lists.
class ScriptureVerseCard extends ConsumerWidget {
  const ScriptureVerseCard({
    super.key,
    required this.text,
    required this.reference,
    this.category = '',
    this.showCategory = true,
  });

  final String text;
  final String reference;
  final String category;
  final bool showCategory;

  Future<void> _addNote(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(savedVersesProvider.notifier);
    if (!notifier.isSaved(reference)) {
      await notifier.toggle(text: text, reference: reference, category: category);
    }
    final saved = ref
        .read(savedVersesProvider)
        .where((v) => v.reference == reference)
        .firstOrNull;
    if (saved == null || !context.mounted) return;
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) =>
          _NoteSheet(reference: reference, initialNotes: saved.notes),
    );
    if (result != null) {
      await notifier.updateNotes(saved.id, result.trim());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isSaved =
        ref.watch(savedVersesProvider).any((v) => v.reference == reference);

    return PremiumCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showCategory && category.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                category,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text('“$text”',
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.55)),
          const SizedBox(height: 10),
          Text(
            '— $reference',
            style: theme.textTheme.titleSmall
                ?.copyWith(color: AppColors.warmGold),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              IconButton(
                onPressed: () => ref.read(savedVersesProvider.notifier).toggle(
                    text: text, reference: reference, category: category),
                tooltip: isSaved ? 'Remove from saved' : 'Save verse',
                constraints:
                    const BoxConstraints(minWidth: 44, minHeight: 44),
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_outline,
                  color: isSaved
                      ? AppColors.warmGold
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await Clipboard.setData(
                      ClipboardData(text: '“$text” — $reference'));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Verse copied.')));
                  }
                },
                tooltip: 'Copy verse',
                constraints:
                    const BoxConstraints(minWidth: 44, minHeight: 44),
                icon: Icon(Icons.copy_outlined,
                    color: theme.colorScheme.onSurfaceVariant),
              ),
              IconButton(
                onPressed: () => _addNote(context, ref),
                tooltip: 'Add note',
                constraints:
                    const BoxConstraints(minWidth: 44, minHeight: 44),
                icon: Icon(Icons.edit_note_outlined,
                    color: theme.colorScheme.onSurfaceVariant),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => context.push('/prayers'),
                icon: const Icon(Icons.wb_twilight_outlined, size: 18),
                label: const Text('Pray'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Bottom-sheet note editor. Owns its text controller so the controller
/// outlives the sheet's closing animation and is disposed safely.
class _NoteSheet extends StatefulWidget {
  const _NoteSheet({required this.reference, required this.initialNotes});

  final String reference;
  final String initialNotes;

  @override
  State<_NoteSheet> createState() => _NoteSheetState();
}

class _NoteSheetState extends State<_NoteSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNotes);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
          24, 0, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Note on ${widget.reference}',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 14),
          TextField(
            controller: _controller,
            maxLines: 4,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'What is God showing you through this verse?',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(_controller.text),
              child: const Text('Save note'),
            ),
          ),
        ],
      ),
    );
  }
}
