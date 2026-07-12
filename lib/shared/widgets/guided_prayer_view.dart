import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';

/// "Pray This Slowly" mode: reveals prayer lines one at a time with a calm
/// progress indicator and Next / Pause / Restart controls.
///
/// Lines auto-advance gently; the user can also tap Next. Used by the
/// Rescue flow, the Recovery flow, and Prayer detail pages.
class GuidedPrayerView extends StatefulWidget {
  const GuidedPrayerView({
    super.key,
    required this.lines,
    this.autoAdvance = const Duration(seconds: 7),
    this.onCompleted,
  });

  final List<String> lines;
  final Duration autoAdvance;
  final VoidCallback? onCompleted;

  @override
  State<GuidedPrayerView> createState() => _GuidedPrayerViewState();
}

class _GuidedPrayerViewState extends State<GuidedPrayerView> {
  int _revealed = 1;
  bool _paused = false;
  Timer? _timer;

  bool get _done => _revealed >= widget.lines.length;

  @override
  void initState() {
    super.initState();
    _schedule();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _schedule() {
    _timer?.cancel();
    if (_paused || _done) return;
    _timer = Timer(widget.autoAdvance, _next);
  }

  void _next() {
    if (_done) return;
    setState(() => _revealed++);
    if (_done) {
      widget.onCompleted?.call();
    } else {
      _schedule();
    }
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
    _schedule();
  }

  void _restart() {
    setState(() {
      _revealed = 1;
      _paused = false;
    });
    _schedule();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: _revealed / widget.lines.length),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 5,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.warmGold),
            ),
          ),
        ),
        const SizedBox(height: 28),
        for (var i = 0; i < widget.lines.length; i++)
          AnimatedOpacity(
            opacity: i < _revealed ? 1 : 0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                  bottom: 14, top: i < _revealed ? 0 : 8),
              child: Text(
                widget.lines[i],
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  height: 1.5,
                  fontWeight: i == _revealed - 1
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: i == _revealed - 1
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _restart,
              tooltip: 'Restart',
              iconSize: 26,
              constraints:
                  const BoxConstraints(minWidth: 48, minHeight: 48),
              icon: const Icon(Icons.replay_rounded),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              onPressed: _done ? null : _togglePause,
              tooltip: _paused ? 'Resume' : 'Pause',
              iconSize: 28,
              constraints:
                  const BoxConstraints(minWidth: 56, minHeight: 56),
              icon: Icon(_paused
                  ? Icons.play_arrow_rounded
                  : Icons.pause_rounded),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _done ? null : _next,
              tooltip: 'Next line',
              iconSize: 26,
              constraints:
                  const BoxConstraints(minWidth: 48, minHeight: 48),
              icon: const Icon(Icons.skip_next_rounded),
            ),
          ],
        ),
      ],
    );
  }
}
