import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/models/journal_entry.dart';
import '../../../shared/models/mood_check_in.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/providers/journal_providers.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/mood_selector.dart';
import '../../../shared/widgets/section_header.dart';

/// Create a new journal entry, or edit an existing one when [entryId] is set.
class JournalEntryEditorScreen extends ConsumerStatefulWidget {
  const JournalEntryEditorScreen({super.key, this.entryId, this.initialType});

  final String? entryId;
  final JournalEntryType? initialType;

  @override
  ConsumerState<JournalEntryEditorScreen> createState() =>
      _JournalEntryEditorScreenState();
}

class _JournalEntryEditorScreenState
    extends ConsumerState<JournalEntryEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _verseController;

  JournalEntry? _existing;
  JournalEntryType _type = JournalEntryType.reflection;
  Mood? _mood;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.entryId != null) {
      _existing =
          ref.read(journalEntriesProvider.notifier).byId(widget.entryId!);
    }
    _type = _existing?.type ?? widget.initialType ?? JournalEntryType.reflection;
    _mood = _existing?.mood;
    _titleController = TextEditingController(text: _existing?.title ?? '');
    _contentController = TextEditingController(text: _existing?.content ?? '');
    _verseController =
        TextEditingController(text: _existing?.verseReference ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _verseController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Write a few words first — even one line is enough.')));
      return;
    }
    setState(() => _saving = true);
    final notifier = ref.read(journalEntriesProvider.notifier);
    if (_existing != null) {
      await notifier.update(_existing!.copyWith(
        type: _type,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        mood: _mood,
        clearMood: _mood == null,
        verseReference: _verseController.text.trim(),
        isAnsweredPrayer: _type == JournalEntryType.answeredPrayer
            ? true
            : _existing!.isAnsweredPrayer,
      ));
    } else {
      await notifier.add(
        type: _type,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        mood: _mood,
        verseReference: _verseController.text.trim(),
      );
    }
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final savedVerses = ref.watch(savedVersesProvider);
    final date = _existing?.date ?? DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(_existing == null ? 'New Entry' : 'Edit Entry'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                DateFormat.yMMMd().format(date),
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                const SectionHeader(title: 'What kind of entry is this?'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final type in JournalEntryType.values)
                      ChoiceChip(
                        selected: type == _type,
                        onSelected: (_) => setState(() => _type = type),
                        avatar: Icon(type.icon,
                            size: 17,
                            color: type == _type
                                ? theme.colorScheme.onPrimaryContainer
                                : theme.colorScheme.onSurfaceVariant),
                        label: Text(type.label),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(hintText: 'Title (optional)'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _contentController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 8,
                  minLines: 5,
                  decoration: const InputDecoration(
                      hintText: 'Write what is on your heart…'),
                ),
                const SizedBox(height: 24),
                const SectionHeader(title: 'How is your heart?'),
                MoodSelector(
                  selected: _mood,
                  onSelected: (mood) =>
                      setState(() => _mood = _mood == mood ? null : mood),
                ),
                const SizedBox(height: 24),
                const SectionHeader(
                  title: 'Attach a verse',
                  subtitle: 'Optional — link a verse that speaks to this.',
                ),
                TextField(
                  controller: _verseController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'e.g. Philippians 4:6',
                    suffixIcon: _verseController.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Remove verse',
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                setState(() => _verseController.clear()),
                          ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                if (savedVerses.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final v in savedVerses.take(6))
                        ActionChip(
                          avatar: const Icon(Icons.menu_book_outlined, size: 15),
                          label: Text(v.reference),
                          onPressed: () => setState(
                              () => _verseController.text = v.reference),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 32),
                PrimaryButton(
                  label: _existing == null ? 'Save Entry' : 'Save Changes',
                  icon: Icons.check_rounded,
                  onPressed: _saving ? null : _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
