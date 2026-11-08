import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/models/saved_verse.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/scripture_verse_card.dart';
import '../data/scripture_library.dart';

/// Scripture tab: searchable library, saved verses, and verse memory.
class ScriptureScreen extends ConsumerStatefulWidget {
  const ScriptureScreen({super.key});

  @override
  ConsumerState<ScriptureScreen> createState() => _ScriptureScreenState();
}

class _ScriptureScreenState extends ConsumerState<ScriptureScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late final TabController _tabController =
      TabController(length: 3, vsync: this);
  String _query = '';
  String? _category;

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<LibraryVerse> get _filtered {
    final q = _query.trim().toLowerCase();
    return scriptureLibrary.where((v) {
      final matchesCategory = _category == null || v.category == _category;
      final matchesQuery = q.isEmpty ||
          v.text.toLowerCase().contains(q) ||
          v.reference.toLowerCase().contains(q) ||
          v.category.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scripture'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Library'),
            Tab(text: 'Saved'),
            Tab(text: 'Memory'),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLibraryTab(),
                _buildSavedTab(),
                _buildMemoryTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLibraryTab() {
    final verses = _filtered;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        Semantics(
          textField: true,
          label: 'Search Scripture',
          child: TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: 'Search by words, reference, or theme',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      tooltip: 'Clear search',
                      icon: const Icon(Icons.close),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        // Sized by its content, so chips aren't clipped at large text sizes.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: const Text('All'),
                  selected: _category == null,
                  onSelected: (_) => setState(() => _category = null),
                ),
              ),
              for (final category in scriptureCategories)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _category == category,
                    onSelected: (_) => setState(() =>
                        _category = _category == category ? null : category),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (verses.isEmpty)
          const EmptyState(
            icon: Icons.search_off_outlined,
            title: 'Nothing found here',
            message:
                'Try a different word or theme — the right verse is waiting.',
          )
        else
          for (final verse in verses)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: ScriptureVerseCard(
                  key: ValueKey(verse.reference),
                  text: verse.text,
                  reference: verse.reference,
                  category: verse.category,
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildSavedTab() {
    final saved = ref.watch(savedVersesProvider);
    if (saved.isEmpty) {
      return EmptyState(
        icon: Icons.bookmark_outline,
        title: 'No saved verses yet',
        message:
            'Save verses from the library or the daily verse, and they will '
            'wait for you here.',
        actionLabel: 'Browse the library',
        onAction: () => _tabController.animateTo(0),
      );
    }
    final sorted = [...saved]..sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        for (final verse in sorted)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ScriptureVerseCard(
                  text: verse.text,
                  reference: verse.reference,
                  category: verse.category,
                  showCategory: verse.category.isNotEmpty,
                ),
                if (verse.notes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12, right: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.edit_note_outlined,
                            size: 16, color: AppColors.warmGold),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            verse.notes,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMemoryTab() {
    final saved = ref.watch(savedVersesProvider);
    final theme = Theme.of(context);
    if (saved.isEmpty) {
      return EmptyState(
        icon: Icons.psychology_outlined,
        title: 'Hide His word in your heart',
        message:
            'Save a verse first, then return here to learn it by heart — '
            'one line at a time.',
        actionLabel: 'Browse the library',
        onAction: () => _tabController.animateTo(0),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        Text(
          'Mark where each verse is on its journey into your heart, and '
          'practise with a gentle quiz.',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        for (final verse in saved)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _MemoryVerseCard(verse: verse),
          ),
      ],
    );
  }
}

class _MemoryVerseCard extends ConsumerWidget {
  const _MemoryVerseCard({required this.verse});

  final SavedVerse verse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return PremiumCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(verse.reference, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            verse.text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final status in const [
                MemoryStatus.learning,
                MemoryStatus.practising,
                MemoryStatus.memorised,
              ])
                ChoiceChip(
                  label: Text(status.label),
                  selected: verse.memoryStatus == status,
                  onSelected: (_) => ref
                      .read(savedVersesProvider.notifier)
                      .updateMemoryStatus(
                          verse.id,
                          verse.memoryStatus == status
                              ? MemoryStatus.none
                              : status),
                ),
            ],
          ),
          // Verses migrated from the old saved format may have no text;
          // there is nothing to quiz on for those.
          if (verse.text.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () =>
                    context.push('/scripture/memory-quiz', extra: verse),
                icon: const Icon(Icons.quiz_outlined, size: 18),
                label: const Text('Practise'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
