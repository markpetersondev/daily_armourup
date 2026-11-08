import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../providers/onboarding_provider.dart';
import 'onboarding_steps.dart';

/// Five-step onboarding: welcome, name, focus areas, goals, ready.
/// The reminders step is hidden for the MVP release (no notifications yet);
/// see docs/IOS_SETUP.md step 4.6.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _stepCount = 5; // 6 with the reminders step

  final _pageController = PageController();
  int _step = 0;

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
    if (_step < _stepCount - 1) _goTo(_step + 1);
  }

  void _back() {
    if (_step > 0) _goTo(_step - 1);
  }

  Future<void> _finish() async {
    await ref.read(onboardingProvider.notifier).complete();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.shield_outlined,
                color: AppColors.softGold, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Welcome, ${ref.read(onboardingProvider).name.trim().isEmpty ? 'Friend' : ref.read(onboardingProvider).name.trim()}. '
                'Grace meets you here.',
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: Row(
                    children: [
                      AnimatedOpacity(
                        opacity: _step > 0 ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: IconButton(
                          onPressed: _step > 0 ? _back : null,
                          icon: const Icon(Icons.arrow_back_rounded),
                          tooltip: 'Back',
                          constraints: const BoxConstraints(
                              minWidth: 44, minHeight: 44),
                        ),
                      ),
                      Expanded(
                        child: Semantics(
                          label: 'Step ${_step + 1} of $_stepCount',
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(
                                    end: (_step + 1) / _stepCount),
                                duration:
                                    const Duration(milliseconds: 350),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, _) =>
                                    LinearProgressIndicator(
                                  value: value,
                                  minHeight: 6,
                                  backgroundColor: theme
                                      .colorScheme.surfaceContainerHighest,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          AppColors.warmGold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) => setState(() => _step = page),
                    children: [
                      WelcomeStep(onNext: _next),
                      NameStep(onNext: _next),
                      FocusAreasStep(onNext: _next),
                      GoalsStep(onNext: _next),
                      // Hidden for the MVP release; see docs/IOS_SETUP.md step 4.6.
                      // RemindersStep(onNext: _next),
                      ReadyStep(onFinish: _finish),
                    ],
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
