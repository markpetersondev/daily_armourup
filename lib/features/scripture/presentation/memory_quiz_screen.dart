import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/models/saved_verse.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/premium_card.dart';

/// Gentle fill-in-the-blank practice for a saved verse. Feedback is always
/// encouraging — this is practice, not a test.
class MemoryQuizScreen extends ConsumerStatefulWidget {
  const MemoryQuizScreen({super.key, required this.verse});

  final SavedVerse verse;

  @override
  ConsumerState<MemoryQuizScreen> createState() => _MemoryQuizScreenState();
}

class _MemoryQuizScreenState extends ConsumerState<MemoryQuizScreen> {
  late List<String> _words;
  late Set<int> _hiddenIndexes;
  late List<TextEditingController> _controllers;
  bool _checked = false;
  int _correct = 0;

  @override
  void initState() {
    super.initState();
    _setUpQuiz();
  }

  void _setUpQuiz() {
    _words = widget.verse.text.split(' ');
    final candidates = <int>[
      for (var i = 0; i < _words.length; i++)
        // Words joined by a dash ("salvation—whom") would be unfair blanks.
        if (_cleanWord(_words[i]).length >= 4 && !_words[i].contains('—')) i,
    ];
    candidates.shuffle(Random());
    final hideCount = min(max(2, _words.length ~/ 8), 4);
    _hiddenIndexes = candidates.take(hideCount).toSet();
    if (_hiddenIndexes.isEmpty && _words.isNotEmpty) {
      _hiddenIndexes = {0};
    }
    _controllers = [
      for (var i = 0; i < _hiddenIndexes.length; i++) TextEditingController(),
    ];
    _checked = false;
    _correct = 0;
  }

  String _cleanWord(String word) =>
      word.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  List<int> get _sortedHidden => _hiddenIndexes.toList()..sort();

  void _check() {
    var correct = 0;
    final hidden = _sortedHidden;
    for (var i = 0; i < hidden.length; i++) {
      if (_cleanWord(_controllers[i].text) == _cleanWord(_words[hidden[i]])) {
        correct++;
      }
    }
    setState(() {
      _correct = correct;
      _checked = true;
    });
    if (correct == hidden.length &&
        widget.verse.memoryStatus == MemoryStatus.none) {
      ref
          .read(savedVersesProvider.notifier)
          .updateMemoryStatus(widget.verse.id, MemoryStatus.learning);
    }
  }

  void _tryAgain() {
    for (final c in _controllers) {
      c.dispose();
    }
    setState(_setUpQuiz);
  }

  String get _feedback {
    final total = _hiddenIndexes.length;
    if (_correct == total) {
      return 'Beautifully done — this verse is taking root in your heart.';
    }
    if (_correct > 0) {
      return 'You remembered $_correct of $total — the word is settling in. '
          'Keep going, one faithful step at a time.';
    }
    return 'Every attempt plants the word deeper. Read it once more and '
        'try again — grace meets you here.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hidden = _sortedHidden;

    return Scaffold(
      appBar: AppBar(title: Text('Practise ${widget.verse.reference}')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              children: [
                Text(
                  'Fill in the missing words from memory. However it goes, '
                  'you are hiding His word in your heart.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 20),
                PremiumCard(
                  padding: const EdgeInsets.all(22),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 8,
                    children: [
                      for (var i = 0; i < _words.length; i++)
                        _hiddenIndexes.contains(i)
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 2),
                                decoration: BoxDecoration(
                                  color: theme
                                      .colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '•' * max(4, _cleanWord(_words[i]).length),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                      color: AppColors.warmGold,
                                      height: 1.6),
                                ),
                              )
                            : Text(_words[i],
                                style: theme.textTheme.bodyLarge
                                    ?.copyWith(height: 1.6)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('— ${widget.verse.reference}',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: AppColors.warmGold)),
                ),
                const SizedBox(height: 20),
                for (var i = 0; i < hidden.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: _controllers[i],
                      textInputAction: i == hidden.length - 1
                          ? TextInputAction.done
                          : TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Missing word ${i + 1}',
                        suffixIcon: !_checked
                            ? null
                            : Icon(
                                _cleanWord(_controllers[i].text) ==
                                        _cleanWord(_words[hidden[i]])
                                    ? Icons.check_circle_outline
                                    : Icons.favorite_outline,
                                color: _cleanWord(_controllers[i].text) ==
                                        _cleanWord(_words[hidden[i]])
                                    ? AppColors.softGreen
                                    : AppColors.warmGold,
                              ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                if (_checked) ...[
                  PremiumCard(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_feedback,
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(height: 1.5)),
                        if (_correct < _hiddenIndexes.length) ...[
                          const SizedBox(height: 10),
                          Text(
                            'The full verse: “${widget.verse.text}”',
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.5),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(label: 'Practise again', onPressed: _tryAgain),
                  const SizedBox(height: 8),
                  SecondaryButton(
                    label: 'Done for now',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ] else
                  PrimaryButton(label: 'Check', onPressed: _check),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
