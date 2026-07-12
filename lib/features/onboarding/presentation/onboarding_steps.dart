import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/premium_card.dart';
import '../data/onboarding_options.dart';
import '../providers/onboarding_provider.dart';

/// Shared layout for an onboarding step: scrollable content with the
/// primary action pinned below.
class _StepLayout extends StatelessWidget {
  const _StepLayout({
    required this.child,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondary,
    this.footnote,
  });

  final Widget child;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final Widget? secondary;
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                secondary!,
              ],
              if (footnote != null) ...[
                const SizedBox(height: 12),
                Text(
                  footnote!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Step 1 — Welcome
// ---------------------------------------------------------------------------

class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _StepLayout(
      primaryLabel: 'Begin My Journey',
      onPrimary: onNext,
      footnote: AppStrings.privacyNote,
      child: Column(
        children: [
          const SizedBox(height: 32),
          const AppLogo(size: 110),
          const SizedBox(height: 32),
          Text(AppStrings.appName,
              style: theme.textTheme.displaySmall, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(
            AppStrings.tagline,
            style: theme.textTheme.titleMedium
                ?.copyWith(color: AppColors.warmGold, letterSpacing: 0.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          Text(
            AppStrings.welcomeDescription,
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step 2 — Name
// ---------------------------------------------------------------------------

class NameStep extends ConsumerStatefulWidget {
  const NameStep({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  ConsumerState<NameStep> createState() => _NameStepState();
}

class _NameStepState extends ConsumerState<NameStep> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: ref.read(onboardingProvider).name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _continue({bool skip = false}) {
    ref
        .read(onboardingProvider.notifier)
        .setName(skip ? '' : _controller.text);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _StepLayout(
      primaryLabel: 'Continue',
      onPrimary: _continue,
      secondary: TextButton(
        onPressed: () => _continue(skip: true),
        child: const Text('Skip for now'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text('What should we call you?',
              style: theme.textTheme.headlineLarge),
          const SizedBox(height: 12),
          Text(
            'We will use this to greet you gently. Skip it and we will call you Friend.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),
          Semantics(
            textField: true,
            label: 'Your first name',
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _continue(),
              decoration: const InputDecoration(
                hintText: 'Your first name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step 3 — Focus areas
// ---------------------------------------------------------------------------

class FocusAreasStep extends ConsumerWidget {
  const FocusAreasStep({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selected = ref.watch(onboardingProvider).focusAreas;
    return _StepLayout(
      primaryLabel: 'Continue',
      onPrimary: onNext,
      footnote: 'Choose as many as you like — you can change these later.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text('Where do you want God\'s strength most right now?',
              style: theme.textTheme.headlineMedium),
          const SizedBox(height: 24),
          for (final option in focusAreaOptions)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SelectableCard(
                icon: option.icon,
                label: option.label,
                selected: selected.contains(option.label),
                onTap: () => ref
                    .read(onboardingProvider.notifier)
                    .toggleFocusArea(option.label),
              ),
            ),
        ],
      ),
    );
  }
}

class _SelectableCard extends StatelessWidget {
  const _SelectableCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? scheme.primaryContainer : scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            constraints: const BoxConstraints(minHeight: 60),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? scheme.primary : scheme.outlineVariant,
                width: selected ? 1.6 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selected
                        ? scheme.primary.withValues(alpha: 0.14)
                        : scheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon,
                      size: 21,
                      color: selected ? scheme.primary : AppColors.warmGold),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w500,
                          color: selected ? scheme.onPrimaryContainer : null,
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

// ---------------------------------------------------------------------------
// Step 4 — Spiritual goals
// ---------------------------------------------------------------------------

class GoalsStep extends ConsumerWidget {
  const GoalsStep({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final goals = ref.watch(onboardingProvider).goals;
    final notifier = ref.read(onboardingProvider.notifier);
    return _StepLayout(
      primaryLabel: 'Continue',
      onPrimary: onNext,
      footnote: 'Small, steady habits shape a strong faith.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text('Which habits would you like to build?',
              style: theme.textTheme.headlineMedium),
          const SizedBox(height: 24),
          for (final option in goalOptions) ...[
            _SelectableCard(
              icon: option.icon,
              label: option.label,
              selected: goals.containsKey(option.id),
              onTap: () => notifier.toggleGoal(option.id),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: goals.containsKey(option.id)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 8, 4),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final freq in GoalFrequency.values)
                            ChoiceChip(
                              label: Text(freq.label),
                              selected: goals[option.id] == freq,
                              onSelected: (_) =>
                                  notifier.setGoalFrequency(option.id, freq),
                            ),
                        ],
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step 5 — Reminder preferences
// ---------------------------------------------------------------------------

class RemindersStep extends ConsumerWidget {
  const RemindersStep({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final reminders = ref.watch(onboardingProvider).reminders;
    final notifier = ref.read(onboardingProvider.notifier);

    return _StepLayout(
      primaryLabel: 'Continue',
      onPrimary: onNext,
      footnote: 'Reminders stay on this device. Notifications arrive in a later update.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text('When should we gently nudge you?',
              style: theme.textTheme.headlineMedium),
          const SizedBox(height: 24),
          _ReminderTile(
            icon: Icons.wb_sunny_outlined,
            title: 'Morning reminder',
            subtitle: 'Begin the day anchored in prayer.',
            enabled: reminders.morningEnabled,
            minutes: reminders.morningMinutes,
            onChanged: (enabled, minutes) => notifier.setReminders(
                reminders.copyWith(
                    morningEnabled: enabled, morningMinutes: minutes)),
          ),
          _ReminderTile(
            icon: Icons.light_mode_outlined,
            title: 'Midday prayer reminder',
            subtitle: 'Pause and reset in the middle of the day.',
            enabled: reminders.middayEnabled,
            minutes: reminders.middayMinutes,
            onChanged: (enabled, minutes) => notifier.setReminders(
                reminders.copyWith(
                    middayEnabled: enabled, middayMinutes: minutes)),
          ),
          _ReminderTile(
            icon: Icons.nightlight_outlined,
            title: 'Evening reflection reminder',
            subtitle: 'Pause, pray, and release today to God.',
            enabled: reminders.eveningEnabled,
            minutes: reminders.eveningMinutes,
            onChanged: (enabled, minutes) => notifier.setReminders(
                reminders.copyWith(
                    eveningEnabled: enabled, eveningMinutes: minutes)),
          ),
          _ReminderTile(
            icon: Icons.shield_outlined,
            title: 'High-risk temptation reminder',
            subtitle: 'Extra strength at the hour you need it most.',
            enabled: reminders.highRiskEnabled,
            minutes: reminders.highRiskMinutes,
            onChanged: (enabled, minutes) => notifier.setReminders(
                reminders.copyWith(
                    highRiskEnabled: enabled, highRiskMinutes: minutes)),
          ),
        ],
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.minutes,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final int minutes;
  final void Function(bool enabled, int minutes) onChanged;

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
      helpText: title.toUpperCase(),
    );
    if (picked != null) {
      onChanged(true, picked.hour * 60 + picked.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final time = TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon,
                color: enabled
                    ? AppColors.warmGold
                    : theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                  if (enabled)
                    TextButton.icon(
                      onPressed: () => _pickTime(context),
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(44, 44),
                          alignment: Alignment.centerLeft),
                      icon: const Icon(Icons.schedule, size: 16),
                      label: Text(time.format(context)),
                    ),
                ],
              ),
            ),
            Semantics(
              label: '$title toggle',
              child: Switch(
                value: enabled,
                onChanged: (v) => onChanged(v, minutes),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step 6 — Ready
// ---------------------------------------------------------------------------

class ReadyStep extends StatelessWidget {
  const ReadyStep({super.key, required this.onFinish});

  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _StepLayout(
      primaryLabel: 'Enter Armour & Prayer',
      onPrimary: onFinish,
      footnote: 'One faithful step at a time.',
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
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
                  color: AppColors.warmGold.withValues(alpha: 0.4),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.shield,
                size: 38, color: AppColors.deepCharcoal),
          ),
          const SizedBox(height: 36),
          Text(
            '“Put on the full armor of God, so that you can take your stand against the devil\'s schemes.”',
            style: theme.textTheme.headlineMedium?.copyWith(height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          Text(
            '— Ephesians 6:11',
            style: theme.textTheme.titleMedium
                ?.copyWith(color: AppColors.warmGold),
          ),
          const SizedBox(height: 32),
          Text(
            'Your armour is ready. Grace meets you here.',
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
