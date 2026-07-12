import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/models/spiritual_habit.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/providers/habit_providers.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/section_header.dart';

/// Suggested custom practices to start from.
const _suggestions = [
  ('Attend church', 'church', GoalFrequency.weekly),
  ('Pray for someone', 'pray_for', GoalFrequency.daily),
  ('Serve someone', 'serve', GoalFrequency.threeTimesAWeek),
  ('Read a Psalm', 'psalm', GoalFrequency.daily),
  ('Reduce late-night scrolling', 'night', GoalFrequency.daily),
];

/// Add a new spiritual practice, or edit an existing one when [habitId] is set.
class HabitEditorScreen extends ConsumerStatefulWidget {
  const HabitEditorScreen({super.key, this.habitId});

  final String? habitId;

  @override
  ConsumerState<HabitEditorScreen> createState() => _HabitEditorScreenState();
}

class _HabitEditorScreenState extends ConsumerState<HabitEditorScreen> {
  late final TextEditingController _titleController;
  SpiritualHabit? _existing;
  String _iconName = 'star';
  GoalFrequency _frequency = GoalFrequency.daily;

  @override
  void initState() {
    super.initState();
    if (widget.habitId != null) {
      _existing =
          ref.read(spiritualHabitsProvider.notifier).byId(widget.habitId!);
    }
    _titleController = TextEditingController(text: _existing?.title ?? '');
    _iconName = _existing?.iconName ?? 'star';
    _frequency = _existing?.frequency ?? GoalFrequency.daily;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Give this practice a name so you can find it again.')));
      return;
    }
    final notifier = ref.read(spiritualHabitsProvider.notifier);
    if (_existing != null) {
      await notifier.updateDetails(_existing!.id,
          title: title, iconName: _iconName, frequency: _frequency);
    } else {
      await notifier.addCustom(
          title: title, iconName: _iconName, frequency: _frequency);
    }
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
          title: Text(_existing == null
              ? 'Add Spiritual Practice'
              : 'Edit ${_existing!.title}')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                Text(
                  'Small acts of faith build a steady life.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                      hintText: 'Practice name, e.g. Read a Psalm'),
                ),
                if (_existing == null) ...[
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final (label, icon, freq) in _suggestions)
                        ActionChip(
                          avatar: Icon(habitIcon(icon), size: 16),
                          label: Text(label),
                          onPressed: () => setState(() {
                            _titleController.text = label;
                            _iconName = icon;
                            _frequency = freq;
                          }),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                const SectionHeader(title: 'How often?'),
                SegmentedButton<GoalFrequency>(
                  segments: [
                    for (final f in GoalFrequency.values)
                      ButtonSegment(
                        value: f,
                        label: Text(switch (f) {
                          GoalFrequency.daily => 'Daily',
                          GoalFrequency.threeTimesAWeek => '3× a week',
                          GoalFrequency.weekly => 'Weekly',
                        }),
                      ),
                  ],
                  selected: {_frequency},
                  onSelectionChanged: (s) =>
                      setState(() => _frequency = s.first),
                  style: SegmentedButton.styleFrom(
                    minimumSize: const Size(44, 48),
                    selectedBackgroundColor: scheme.primaryContainer,
                  ),
                ),
                const SizedBox(height: 24),
                const SectionHeader(title: 'Choose an icon'),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final entry in habitIcons.entries)
                      Semantics(
                        button: true,
                        selected: _iconName == entry.key,
                        label: 'Icon ${entry.key}',
                        child: Material(
                          color: _iconName == entry.key
                              ? scheme.primaryContainer
                              : scheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () =>
                                setState(() => _iconName = entry.key),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _iconName == entry.key
                                      ? scheme.primary
                                      : scheme.outlineVariant,
                                  width: _iconName == entry.key ? 1.6 : 1,
                                ),
                              ),
                              child: Icon(entry.value,
                                  size: 22,
                                  color: _iconName == entry.key
                                      ? scheme.onPrimaryContainer
                                      : scheme.onSurfaceVariant),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label:
                      _existing == null ? 'Add Practice' : 'Save Changes',
                  icon: Icons.check_rounded,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
