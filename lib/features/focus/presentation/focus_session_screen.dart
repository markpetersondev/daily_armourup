import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/models/focus_session.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/progress_ring.dart';
import '../data/focus_content.dart';
import 'focus_screen.dart';

/// The active Sacred Focus session: calm countdown, pause/resume, and a
/// peaceful completion screen with an optional reflection.
class FocusSessionScreen extends ConsumerStatefulWidget {
  const FocusSessionScreen({super.key, required this.config});

  final FocusSessionConfig config;

  @override
  ConsumerState<FocusSessionScreen> createState() =>
      _FocusSessionScreenState();
}

class _FocusSessionScreenState extends ConsumerState<FocusSessionScreen>
    with SingleTickerProviderStateMixin {
  late int _remainingSeconds;
  Timer? _timer;
  bool _paused = false;
  bool _finished = false;
  bool _completedFully = false;
  bool _saving = false;

  late final AnimationController _breathe;
  final _reflectionController = TextEditingController();

  int get _totalSeconds => widget.config.duration.inSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _totalSeconds;
    _breathe = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathe.dispose();
    _reflectionController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 1) {
        _timer?.cancel();
        setState(() {
          _remainingSeconds = 0;
          _finished = true;
          _completedFully = true;
        });
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
    if (_paused) {
      _timer?.cancel();
      _breathe.stop();
    } else {
      _startTimer();
      _breathe.repeat(reverse: true);
    }
  }

  void _endEarly() {
    _timer?.cancel();
    setState(() {
      _finished = true;
      _completedFully = false;
    });
  }

  Future<void> _saveAndClose() async {
    if (_saving) return;
    setState(() => _saving = true);
    final elapsed = _totalSeconds - _remainingSeconds;
    await ref.read(focusSessionsProvider.notifier).add(FocusSession(
          id: '${DateTime.now().microsecondsSinceEpoch}',
          mode: widget.config.mode,
          duration: Duration(seconds: _completedFully ? _totalSeconds : elapsed),
          completedAt: DateTime.now(),
          reflection: _reflectionController.text.trim().isEmpty
              ? null
              : _reflectionController.text.trim(),
          completed: _completedFully,
        ));
    if (mounted) context.go('/home');
  }

  String get _timeLabel {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final content = focusModeContent[widget.config.mode]!;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: _finished
                ? _buildCompletion(content)
                : _buildActive(content),
          ),
        ),
      ),
    );
  }

  Widget _buildActive(FocusModeContent content) {
    final theme = Theme.of(context);
    final progress =
        _totalSeconds == 0 ? 0.0 : 1 - (_remainingSeconds / _totalSeconds);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Icon(content.icon, size: 20, color: AppColors.warmGold),
              const SizedBox(width: 10),
              Text(widget.config.mode.label,
                  style: theme.textTheme.titleMedium),
              const Spacer(),
              if (widget.config.ambientSound)
                Icon(Icons.graphic_eq_outlined,
                    size: 20, color: theme.colorScheme.onSurfaceVariant),
            ],
          ),
          const Spacer(),
          AnimatedBuilder(
            animation: _breathe,
            builder: (context, child) {
              final glow = 0.15 + 0.12 * _breathe.value;
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.warmGold.withValues(alpha: glow),
                      blurRadius: 70,
                      spreadRadius: 16 + 10 * _breathe.value,
                    ),
                  ],
                ),
                child: child,
              );
            },
            child: ProgressRing(
              progress: progress,
              size: 230,
              strokeWidth: 8,
              semanticLabel: 'Time remaining $_timeLabel',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_timeLabel, style: theme.textTheme.displayMedium),
                  const SizedBox(height: 4),
                  Text(
                    _paused ? 'Paused' : content.sessionPrompt,
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          if (widget.config.showVerse)
            PremiumCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Text(
                    '“${content.verse.text}”',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(height: 1.5, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 8),
                  Text('— ${content.verse.reference}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.warmGold)),
                ],
              ),
            ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _endEarly,
                tooltip: 'End session',
                iconSize: 26,
                constraints:
                    const BoxConstraints(minWidth: 52, minHeight: 52),
                icon: const Icon(Icons.stop_rounded),
              ),
              const SizedBox(width: 16),
              IconButton.filled(
                onPressed: _togglePause,
                tooltip: _paused ? 'Resume' : 'Pause',
                iconSize: 34,
                constraints:
                    const BoxConstraints(minWidth: 72, minHeight: 72),
                icon: Icon(
                    _paused ? Icons.play_arrow_rounded : Icons.pause_rounded),
              ),
              const SizedBox(width: 68),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletion(FocusModeContent content) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.forestGreen, AppColors.deepOlive],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.forestGreen.withValues(alpha: 0.3),
                  blurRadius: 26,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              _completedFully
                  ? Icons.check_rounded
                  : Icons.wb_twilight_outlined,
              size: 40,
              color: AppColors.softGold,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            _completedFully
                ? 'Time well set apart.'
                : 'Every quiet minute counts.',
            style: theme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            _completedFully
                ? 'You stayed present for ${widget.config.duration.inMinutes} minutes of ${widget.config.mode.label.toLowerCase()}.'
                : 'You gave God this time, and that matters. Begin again any time.',
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('How was this time with God?',
                style: theme.textTheme.titleLarge),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reflectionController,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'A word, a feeling, something He showed you… (optional)',
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Finish',
            onPressed: _saving ? null : _saveAndClose,
          ),
        ],
      ),
    );
  }
}
