import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_storage_service.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/providers/habit_providers.dart';

/// In-progress onboarding answers, committed to the profile on completion.
class OnboardingState {
  const OnboardingState({
    this.name = '',
    this.focusAreas = const {},
    this.goals = const {},
    this.reminders = const ReminderPreferences(),
  });

  final String name;
  final Set<String> focusAreas;

  /// goal id → chosen frequency
  final Map<String, GoalFrequency> goals;
  final ReminderPreferences reminders;

  OnboardingState copyWith({
    String? name,
    Set<String>? focusAreas,
    Map<String, GoalFrequency>? goals,
    ReminderPreferences? reminders,
  }) =>
      OnboardingState(
        name: name ?? this.name,
        focusAreas: focusAreas ?? this.focusAreas,
        goals: goals ?? this.goals,
        reminders: reminders ?? this.reminders,
      );
}

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
        OnboardingNotifier.new);

class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  void setName(String name) => state = state.copyWith(name: name);

  void toggleFocusArea(String area) {
    final areas = {...state.focusAreas};
    areas.contains(area) ? areas.remove(area) : areas.add(area);
    state = state.copyWith(focusAreas: areas);
  }

  void toggleGoal(String id) {
    final goals = {...state.goals};
    if (goals.containsKey(id)) {
      goals.remove(id);
    } else {
      goals[id] = GoalFrequency.daily;
    }
    state = state.copyWith(goals: goals);
  }

  void setGoalFrequency(String id, GoalFrequency frequency) {
    state = state.copyWith(goals: {...state.goals, id: frequency});
  }

  void setReminders(ReminderPreferences reminders) =>
      state = state.copyWith(reminders: reminders);

  /// Persists everything to the user profile and marks onboarding complete.
  Future<void> complete() async {
    await ref.read(userProfileProvider.notifier).completeOnboarding(
          name: state.name.trim(),
          focusAreas: state.focusAreas.toList(),
          goals: state.goals.entries
              .map((e) => SpiritualGoal(id: e.key, frequency: e.value))
              .toList(),
          reminders: state.reminders,
        );
    // Re-seed spiritual habits so the chosen goals become starting practices.
    await ref
        .read(localStorageProvider)
        .remove(LocalStorageService.keySpiritualHabits);
    ref.invalidate(spiritualHabitsProvider);
  }
}
