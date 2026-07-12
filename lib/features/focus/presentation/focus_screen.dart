import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/models/focus_session.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/premium_card.dart';
import '../data/focus_content.dart';

/// Settings passed from setup to the active session screen.
class FocusSessionConfig {
  const FocusSessionConfig({
    required this.mode,
    required this.duration,
    required this.ambientSound,
    required this.showVerse,
  });

  final FocusMode mode;
  final Duration duration;
  final bool ambientSound;
  final bool showVerse;
}

/// Sacred Focus setup: choose a mode, a duration, and gentle options.
class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  FocusMode _mode = FocusMode.prayer;
  Duration _duration = const Duration(minutes: 10);
  bool _ambientSound = false;
  bool _showVerse = true;

  Future<void> _pickCustomDuration() async {
    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) =>
          _CustomDurationDialog(initialMinutes: _duration.inMinutes),
    );
    if (result != null && result > 0) {
      setState(
          () => _duration = Duration(minutes: result.clamp(1, 120)));
    }
  }

  void _showFocusLockInfo() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lock_outline, color: AppColors.warmGold),
                const SizedBox(width: 10),
                Text('Focus Lock',
                    style: Theme.of(sheetContext).textTheme.headlineSmall),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Use this session as a commitment to step away from '
              'distraction. Enhanced distraction protection can be added '
              'in a future Android version.',
              style: Theme.of(sheetContext).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  color:
                      Theme.of(sheetContext).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPreset = focusDurationPresets.contains(_duration);

    return Scaffold(
      appBar: AppBar(title: const Text('Sacred Focus')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                Text(
                  'Set apart a few quiet minutes for prayer, Scripture, '
                  'worship, or reflection.',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                Text('Choose a focus', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                FocusModeSelector(
                  selected: _mode,
                  onSelected: (m) => setState(() => _mode = m),
                ),
                const SizedBox(height: 24),
                Text('How long?', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final preset in focusDurationPresets)
                      ChoiceChip(
                        label: Text('${preset.inMinutes} min'),
                        selected: _duration == preset,
                        onSelected: (_) =>
                            setState(() => _duration = preset),
                      ),
                    ChoiceChip(
                      label: Text(isPreset
                          ? 'Custom'
                          : 'Custom · ${_duration.inMinutes} min'),
                      selected: !isPreset,
                      onSelected: (_) => _pickCustomDuration(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                PremiumCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: _ambientSound,
                        onChanged: (v) =>
                            setState(() => _ambientSound = v),
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Ambient sound'),
                        subtitle: const Text('A gentle atmosphere indicator'),
                        secondary: const Icon(Icons.graphic_eq_outlined,
                            color: AppColors.warmGold),
                      ),
                      SwitchListTile(
                        value: _showVerse,
                        onChanged: (v) => setState(() => _showVerse = v),
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Verse prompt'),
                        subtitle:
                            const Text('Show a Scripture during the session'),
                        secondary: const Icon(Icons.menu_book_outlined,
                            color: AppColors.warmGold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PremiumCard(
                  onTap: _showFocusLockInfo,
                  semanticLabel: 'About Focus Lock',
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline,
                          color: AppColors.warmGold, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('Focus Lock',
                            style: theme.textTheme.titleSmall),
                      ),
                      Icon(Icons.info_outline,
                          size: 18,
                          color: theme.colorScheme.onSurfaceVariant),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  label: 'Begin ${_duration.inMinutes} minutes of ${_mode.label.toLowerCase()}',
                  icon: Icons.self_improvement_outlined,
                  onPressed: () => context.push(
                    '/focus/session',
                    extra: FocusSessionConfig(
                      mode: _mode,
                      duration: _duration,
                      ambientSound: _ambientSound,
                      showVerse: _showVerse,
                    ),
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

/// Custom-minutes dialog. Owns its controller so it survives the dialog's
/// closing animation and is disposed safely.
class _CustomDurationDialog extends StatefulWidget {
  const _CustomDurationDialog({required this.initialMinutes});

  final int initialMinutes;

  @override
  State<_CustomDurationDialog> createState() => _CustomDurationDialogState();
}

class _CustomDurationDialogState extends State<_CustomDurationDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.initialMinutes.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Custom duration'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        autofocus: true,
        onSubmitted: (v) => Navigator.of(context).pop(int.tryParse(v)),
        decoration: const InputDecoration(
          labelText: 'Minutes',
          hintText: '1 – 120',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(int.tryParse(_controller.text)),
          child: const Text('Set'),
        ),
      ],
    );
  }
}

/// Selectable list of Sacred Focus modes.
class FocusModeSelector extends StatelessWidget {
  const FocusModeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final FocusMode selected;
  final ValueChanged<FocusMode> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Column(
      children: [
        for (final mode in FocusMode.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Semantics(
              button: true,
              selected: mode == selected,
              label: mode.label,
              child: Material(
                color: mode == selected
                    ? scheme.primaryContainer
                    : scheme.surfaceContainer,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => onSelected(mode),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 56),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: mode == selected
                            ? scheme.primary
                            : scheme.outlineVariant,
                        width: mode == selected ? 1.6 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(focusModeContent[mode]!.icon,
                            size: 22,
                            color: mode == selected
                                ? scheme.primary
                                : AppColors.warmGold),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mode.label,
                                  style: theme.textTheme.titleSmall),
                              const SizedBox(height: 2),
                              Text(
                                focusModeContent[mode]!.description,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          mode == selected
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: mode == selected
                              ? scheme.primary
                              : scheme.outline,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
