import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/models/rescue_session.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/guided_prayer_view.dart';
import '../../../shared/widgets/premium_card.dart';
import '../data/rescue_content.dart';
import '../widgets/breathing_circle.dart';
import '../widgets/rescue_progress_header.dart';

/// The five-step guided Rescue journey:
/// breathe → Scripture → prayer → action → check-in.
class RescueFlowScreen extends ConsumerStatefulWidget {
  const RescueFlowScreen({super.key, required this.category});

  final RescueCategory category;

  @override
  ConsumerState<RescueFlowScreen> createState() => _RescueFlowScreenState();
}

enum _FlowPhase { steps, success, needHelp }

class _RescueFlowScreenState extends ConsumerState<RescueFlowScreen> {
  static const _stepLabels = [
    'Pause and breathe',
    'Scripture',
    'Guided prayer',
    'Take action',
    'Check-in',
  ];

  PageController _pageController = PageController();
  int _step = 0;
  _FlowPhase _phase = _FlowPhase.steps;

  bool _breathingDone = false;
  int _verseIndex = 0;
  String? _selectedAction;

  List get _verses => rescueVerses[widget.category]!;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int step) {
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  void _next() {
    if (_step < _stepLabels.length - 1) _goTo(_step + 1);
  }

  Future<void> _saveSession(RescueOutcome outcome) async {
    await ref.read(rescueSessionsProvider.notifier).add(RescueSession(
          id: '${DateTime.now().microsecondsSinceEpoch}',
          category: widget.category.name,
          dateTime: DateTime.now(),
          outcome: outcome,
          selectedAction: _selectedAction,
          feltStronger: outcome == RescueOutcome.feltStronger,
        ));
  }

  Future<void> _onOutcome(RescueOutcome outcome) async {
    switch (outcome) {
      case RescueOutcome.feltStronger:
        await _saveSession(outcome);
        setState(() => _phase = _FlowPhase.success);
      case RescueOutcome.stillNeedHelp:
        await _saveSession(outcome);
        setState(() => _phase = _FlowPhase.needHelp);
      case RescueOutcome.slipped:
        // The Recovery flow saves the session with its optional notes.
        if (mounted) {
          context.pushReplacement('/rescue/recovery', extra: {
            'category': widget.category,
            'selectedAction': _selectedAction,
          });
        }
    }
  }

  /// Re-enters the steps phase at [step]. The PageView is unmounted while a
  /// success/help view is shown, so the old controller has no clients —
  /// recreate it with the target page instead of jumping.
  void _reenterStepsAt(int step, {bool reset = false}) {
    _pageController.dispose();
    _pageController = PageController(initialPage: step);
    setState(() {
      _phase = _FlowPhase.steps;
      _step = step;
      if (reset) {
        _breathingDone = false;
        _verseIndex = 0;
        _selectedAction = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: switch (_phase) {
              _FlowPhase.success => _SuccessView(
                  onDone: () => context.go('/home'),
                  onBackToRescue: () => context.go('/rescue'),
                ),
              _FlowPhase.needHelp => _NeedHelpView(
                  onReadVerse: () {
                    _verseIndex = (_verseIndex + 1) % _verses.length;
                    _reenterStepsAt(1);
                  },
                  onRestart: () => _reenterStepsAt(0, reset: true),
                ),
              _FlowPhase.steps => Column(
                  children: [
                    RescueProgressHeader(
                      step: _step,
                      totalSteps: _stepLabels.length,
                      stepLabel: _stepLabels[_step],
                      onClose: () => context.pop(),
                    ),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (p) => setState(() => _step = p),
                        children: [
                          _buildBreatheStep(),
                          _buildScriptureStep(),
                          _buildPrayerStep(),
                          _buildActionStep(),
                          _buildCheckInStep(),
                        ],
                      ),
                    ),
                  ],
                ),
            },
          ),
        ),
      ),
    );
  }

  Widget _stepLayout({
    required Widget child,
    String primaryLabel = 'Continue',
    VoidCallback? onPrimary,
    Widget? secondary,
  }) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: child,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            children: [
              PrimaryButton(label: primaryLabel, onPressed: onPrimary),
              if (secondary != null) ...[
                const SizedBox(height: 8),
                secondary,
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBreatheStep() {
    final theme = Theme.of(context);
    return _stepLayout(
      onPrimary: _breathingDone ? _next : null,
      secondary: _breathingDone
          ? null
          : TextButton(onPressed: _next, child: const Text('Skip for now')),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text(
            'Breathe in grace. Breathe out fear.',
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          BreathingCircle(
            onComplete: () => setState(() => _breathingDone = true),
          ),
        ],
      ),
    );
  }

  Widget _buildScriptureStep() {
    final theme = Theme.of(context);
    final verse = _verses[_verseIndex];
    final isSaved = ref
        .watch(savedVersesProvider)
        .any((v) => v.reference == verse.reference);
    return _stepLayout(
      onPrimary: _next,
      secondary: TextButton.icon(
        onPressed: () => setState(
            () => _verseIndex = (_verseIndex + 1) % _verses.length),
        icon: const Icon(Icons.refresh_rounded, size: 18),
        label: const Text('Read another verse'),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text('A word for this moment',
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: 28),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: PremiumCard(
              key: ValueKey(verse.reference),
              padding: const EdgeInsets.all(26),
              child: Column(
                children: [
                  const Icon(Icons.format_quote_rounded,
                      color: AppColors.warmGold, size: 30),
                  const SizedBox(height: 12),
                  Text(
                    '“${verse.text}”',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(height: 1.5, fontSize: 19),
                  ),
                  const SizedBox(height: 14),
                  Text('— ${verse.reference}',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: AppColors.warmGold)),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () =>
                        ref.read(savedVersesProvider.notifier).toggle(
                              text: verse.text,
                              reference: verse.reference,
                              category: widget.category.label,
                            ),
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_outline,
                      size: 18,
                    ),
                    label: Text(isSaved ? 'Saved' : 'Save verse'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerStep() {
    final theme = Theme.of(context);
    return _stepLayout(
      onPrimary: _next,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text('Pray this slowly',
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            'Let each line settle before the next.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GuidedPrayerView(lines: rescuePrayers[widget.category]!),
        ],
      ),
    );
  }

  Widget _buildActionStep() {
    final theme = Theme.of(context);
    return _stepLayout(
      onPrimary: _selectedAction != null ? _next : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text('Take one faithful step',
              style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Choose one small action to carry this moment forward.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          for (final action in rescueActions)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ActionCard(
                action: action,
                selected: _selectedAction == action.label,
                onTap: () =>
                    setState(() => _selectedAction = action.label),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCheckInStep() {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text('Did this moment become easier?',
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center),
                const SizedBox(height: 32),
                _OutcomeCard(
                  icon: Icons.shield_outlined,
                  color: AppColors.softGreen,
                  label: RescueOutcome.feltStronger.label,
                  onTap: () => _onOutcome(RescueOutcome.feltStronger),
                ),
                const SizedBox(height: 12),
                _OutcomeCard(
                  icon: Icons.support_outlined,
                  color: AppColors.warmGold,
                  label: RescueOutcome.stillNeedHelp.label,
                  onTap: () => _onOutcome(RescueOutcome.stillNeedHelp),
                ),
                const SizedBox(height: 12),
                _OutcomeCard(
                  icon: Icons.restart_alt_rounded,
                  color: AppColors.gentleRed,
                  label: RescueOutcome.slipped.label,
                  onTap: () => _onOutcome(RescueOutcome.slipped),
                ),
                const SizedBox(height: 24),
                Text(
                  'However this went, grace meets you here.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.action,
    required this.selected,
    required this.onTap,
  });

  final RescueAction action;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: action.label,
      child: Material(
        color: selected ? scheme.primaryContainer : scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected ? scheme.primary : scheme.outlineVariant,
                width: selected ? 1.6 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(action.icon,
                    size: 22,
                    color: selected ? scheme.primary : AppColors.warmGold),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    action.label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w500,
                        ),
                  ),
                ),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  color: selected ? scheme.primary : scheme.outline,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OutcomeCard extends StatelessWidget {
  const _OutcomeCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: onTap,
      semanticLabel: label,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          Icon(Icons.arrow_forward_ios_rounded,
              size: 15,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.onDone, required this.onBackToRescue});

  final VoidCallback onDone;
  final VoidCallback onBackToRescue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.softGreen, AppColors.forestGreen],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.softGreen.withValues(alpha: 0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.shield,
                size: 42, color: AppColors.softGold),
          ),
          const SizedBox(height: 32),
          Text('You stood firm.',
              style: theme.textTheme.headlineLarge,
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(
            'Well done for pausing. One faithful step at a time.',
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          PrimaryButton(label: 'Return Home', onPressed: onDone),
          const SizedBox(height: 8),
          TextButton(
              onPressed: onBackToRescue,
              child: const Text('Back to Rescue')),
        ],
      ),
    );
  }
}

class _NeedHelpView extends StatelessWidget {
  const _NeedHelpView({required this.onReadVerse, required this.onRestart});

  final VoidCallback onReadVerse;
  final VoidCallback onRestart;

  Future<void> _showAccountabilitySheet(BuildContext context) async {
    const message =
        'Hey — I\'m in a hard moment and choosing to reach out instead of '
        'giving in. Could you pray for me right now?';
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reach out to someone you trust',
                style: Theme.of(sheetContext).textTheme.headlineSmall),
            const SizedBox(height: 10),
            Text(
              'A short message is enough. Copy this and send it to your '
              'accountability partner in any app.',
              style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(sheetContext).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            PremiumCard(
              child: Text('“$message”',
                  style: Theme.of(sheetContext).textTheme.bodyLarge),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  await Clipboard.setData(
                      const ClipboardData(text: message));
                  if (sheetContext.mounted) {
                    Navigator.of(sheetContext).pop();
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Message copied. You are not alone.')));
                  }
                },
                icon: const Icon(Icons.copy_outlined, size: 18),
                label: const Text('Copy message'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final options = <(IconData, String, VoidCallback)>[
      (Icons.menu_book_outlined, 'Read another verse', onReadVerse),
      (
        Icons.self_improvement_outlined,
        'Start a focus session',
        () => context.pushReplacement('/focus'),
      ),
      (
        Icons.wb_twilight_outlined,
        'Write a prayer',
        () => context.pushReplacement('/prayers'),
      ),
      (
        Icons.chat_bubble_outline,
        'Contact accountability partner',
        () => _showAccountabilitySheet(context),
      ),
      (Icons.replay_rounded, 'Begin the rescue flow again', onRestart),
    ];
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ListView(
        children: [
          const SizedBox(height: 24),
          Text('Stay here a little longer.',
              style: theme.textTheme.headlineLarge,
              textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(
            'You are not alone in this moment. Choose what would help next.',
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          for (final (icon, label, onTap) in options)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                onTap: onTap,
                semanticLabel: label,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(icon, color: AppColors.warmGold, size: 22),
                    const SizedBox(width: 14),
                    Expanded(
                      child:
                          Text(label, style: theme.textTheme.titleMedium),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 15, color: theme.colorScheme.onSurfaceVariant),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.go('/home'),
            child: const Text('Return Home'),
          ),
        ],
      ),
    );
  }
}
