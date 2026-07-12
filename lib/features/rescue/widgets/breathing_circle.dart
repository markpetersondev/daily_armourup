import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

/// A 30-second guided breathing exercise: an expanding/contracting circle
/// cycling through "Breathe in", "Hold", and "Breathe out".
class BreathingCircle extends StatefulWidget {
  const BreathingCircle({
    super.key,
    this.totalDuration = const Duration(seconds: 30),
    required this.onComplete,
  });

  final Duration totalDuration;
  final VoidCallback onComplete;

  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

/// One in-hold-out cycle: 4s in, 2s hold, 4s out.
const _cycle = Duration(seconds: 10);
const _inEnd = 0.4; // fraction of cycle
const _holdEnd = 0.6;

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _cycle)
      ..addStatusListener(_onCycleStatus)
      ..forward();
  }

  int get _totalCycles =>
      (widget.totalDuration.inMilliseconds / _cycle.inMilliseconds).ceil();

  int _cyclesDone = 0;

  void _onCycleStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    _cyclesDone++;
    if (_cyclesDone >= _totalCycles) {
      setState(() => _completed = true);
      widget.onComplete();
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  (String, double) _phase(double t) {
    if (t < _inEnd) {
      return ('Breathe in', 0.55 + 0.45 * (t / _inEnd));
    }
    if (t < _holdEnd) {
      return ('Hold', 1.0);
    }
    return ('Breathe out', 1.0 - 0.45 * ((t - _holdEnd) / (1 - _holdEnd)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final (label, scale) =
            _completed ? ('Well done', 0.85) : _phase(_controller.value);
        return Semantics(
          label: 'Breathing exercise: $label',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 220,
                height: 220,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 200 * scale,
                    height: 200 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.softSage.withValues(alpha: 0.9),
                          AppColors.forestGreen.withValues(alpha: 0.55),
                        ],
                      ),
                      border: Border.all(
                        color: AppColors.warmGold.withValues(alpha: 0.7),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.forestGreen.withValues(alpha: 0.25),
                          blurRadius: 40 * scale,
                          spreadRadius: 6 * scale,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        _completed ? Icons.check_rounded : Icons.spa_outlined,
                        size: 34,
                        color: theme.brightness == Brightness.dark
                            ? AppColors.softGold
                            : AppColors.forestGreen,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  label,
                  key: ValueKey(label),
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 10),
              if (!_completed)
                Text(
                  'Cycle ${_cyclesDone + 1} of $_totalCycles',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
            ],
          ),
        );
      },
    );
  }
}
