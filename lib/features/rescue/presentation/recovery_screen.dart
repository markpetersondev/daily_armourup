import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/models/rescue_session.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/guided_prayer_view.dart';
import '../../../shared/widgets/premium_card.dart';
import '../data/rescue_content.dart';
// import '../widgets/crisis_support_note.dart';

/// The compassionate Recovery flow shown after a slip. Nothing is reset;
/// the user is invited to return, reflect, and begin again.
class RecoveryScreen extends ConsumerStatefulWidget {
  const RecoveryScreen({
    super.key,
    required this.category,
    this.selectedAction,
  });

  final RescueCategory category;
  final String? selectedAction;

  @override
  ConsumerState<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends ConsumerState<RecoveryScreen> {
  final _triggerController = TextEditingController();
  final _beforeController = TextEditingController();
  bool _saving = false;
  bool _sessionSaved = false;

  @override
  void dispose() {
    _triggerController.dispose();
    _beforeController.dispose();
    super.dispose();
  }

  Future<void> _saveSession() async {
    if (_sessionSaved) return;
    _sessionSaved = true;
    final noteParts = <String>[
      if (_triggerController.text.trim().isNotEmpty)
        'Trigger: ${_triggerController.text.trim()}',
      if (_beforeController.text.trim().isNotEmpty)
        'Before this: ${_beforeController.text.trim()}',
    ];
    await ref.read(rescueSessionsProvider.notifier).add(RescueSession(
          id: '${DateTime.now().microsecondsSinceEpoch}',
          category: widget.category.name,
          dateTime: DateTime.now(),
          outcome: RescueOutcome.slipped,
          selectedAction: widget.selectedAction,
          note: noteParts.isEmpty ? null : noteParts.join('\n'),
        ));
  }

  Future<void> _beginAgain() async {
    if (_saving) return;
    setState(() => _saving = true);
    await _saveSession();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Grace meets you here. Begin again today.')));
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      // Leaving still counts as having reached for help (PRD 7.3).
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _saveSession();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _saveSession();
              context.go('/rescue');
            },
            tooltip: 'Back to Rescue',
            icon: const Icon(Icons.close_rounded),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                children: [
                  Center(
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.warmGold, AppColors.softGold],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.warmGold.withValues(alpha: 0.35),
                            blurRadius: 28,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.wb_sunny_outlined,
                          size: 38, color: AppColors.deepCharcoal),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text('You are not beyond grace.',
                      style: theme.textTheme.headlineLarge,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text(
                    'Falling is not the end of your story. Return to God, learn '
                    'from this moment, and begin again.',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  PremiumCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Icon(Icons.format_quote_rounded,
                            color: AppColors.warmGold, size: 28),
                        const SizedBox(height: 10),
                        Text(
                          '“${recoveryVerse.text}”',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(height: 1.5, fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        Text('— ${recoveryVerse.reference}',
                            style: theme.textTheme.titleSmall
                                ?.copyWith(color: AppColors.warmGold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text('A prayer of return',
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  const GuidedPrayerView(lines: recoveryPrayer),
                  const SizedBox(height: 28),
                  Text('If it helps, reflect for a moment',
                      style: theme.textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text(
                    'Both of these are optional and stay private on this device.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _triggerController,
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'What triggered this moment?',
                      hintText: 'A place, a feeling, a time of day…',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _beforeController,
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'What happened before this?',
                      hintText: 'What was going on earlier today?',
                    ),
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    label: 'Begin Again',
                    onPressed: _saving ? null : _beginAgain,
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Nothing is lost. Take the next faithful step.',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                  // Hidden for the MVP release; see docs/IOS_SETUP.md step 4.9.
                  // const SizedBox(height: 28),
                  // const CrisisSupportNote(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
