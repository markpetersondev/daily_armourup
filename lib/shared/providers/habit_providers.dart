import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/local_storage_service.dart';
import '../models/spiritual_habit.dart';
import '../models/user_profile.dart';
import 'app_providers.dart';

/// The built-in practices every journey starts with.
const _defaultHabitSeeds = [
  ('morning_prayer', 'Morning prayer', 'morning'),
  ('evening_prayer', 'Evening prayer', 'evening'),
  ('bible_reading', 'Bible reading', 'bible'),
  ('devotional', 'Devotional', 'devotional'),
  ('journal_reflection', 'Journal reflection', 'journal'),
  ('gratitude', 'Gratitude', 'gratitude'),
  ('verse_memorisation', 'Verse memorisation', 'memory'),
  ('fasting', 'Fasting', 'fasting'),
  ('worship_time', 'Worship time', 'worship'),
  ('helped_someone', 'Helped someone', 'serve'),
  ('reduced_distractions', 'Reduced distractions', 'focus'),
];

/// Onboarding goal id → habit ids it should switch on.
const _goalToHabits = <String, List<String>>{
  'pray_daily': ['morning_prayer', 'evening_prayer'],
  'read_scripture': ['bible_reading'],
  'journal_weekly': ['journal_reflection'],
  'gratitude': ['gratitude'],
  'memorise_verses': ['verse_memorisation'],
  'reduce_distraction': ['reduced_distractions'],
  'fasting': ['fasting'],
};

/// Habits enabled on a fresh start even without a matching goal.
const _enabledByDefault = {
  'morning_prayer',
  'bible_reading',
  'journal_reflection',
  'gratitude',
};

/// All spiritual habits, in the user's chosen order.
final spiritualHabitsProvider =
    NotifierProvider<SpiritualHabitsNotifier, List<SpiritualHabit>>(
        SpiritualHabitsNotifier.new);

class SpiritualHabitsNotifier extends Notifier<List<SpiritualHabit>> {
  @override
  List<SpiritualHabit> build() {
    final storage = ref.read(localStorageProvider);
    final stored = storage.readJsonList(LocalStorageService.keySpiritualHabits);
    if (stored.isNotEmpty) {
      return (stored.map(SpiritualHabit.fromJson).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)));
    }
    // First launch: seed from onboarding goals so chosen goals become habits.
    final goals = ref.read(userProfileProvider).spiritualGoals;
    final enabledIds = {..._enabledByDefault};
    final frequencies = <String, GoalFrequency>{};
    for (final goal in goals) {
      for (final habitId in _goalToHabits[goal.id] ?? const <String>[]) {
        enabledIds.add(habitId);
        frequencies[habitId] = goal.frequency;
      }
    }
    final now = DateTime.now();
    final seeded = <SpiritualHabit>[
      for (final (i, seed) in _defaultHabitSeeds.indexed)
        SpiritualHabit(
          id: seed.$1,
          title: seed.$2,
          iconName: seed.$3,
          frequency: frequencies[seed.$1] ?? GoalFrequency.daily,
          createdAt: now,
          isEnabled: enabledIds.contains(seed.$1),
          sortOrder: i,
        ),
    ];
    storage.writeJsonList(LocalStorageService.keySpiritualHabits,
        seeded.map((h) => h.toJson()).toList());
    return seeded;
  }

  Future<void> _persist() => ref.read(localStorageProvider).writeJsonList(
        LocalStorageService.keySpiritualHabits,
        state.map((h) => h.toJson()).toList(),
      );

  /// Marks or unmarks a habit as complete for the given day (today by default).
  Future<void> toggleCompleted(String id, [DateTime? day]) async {
    final key = SpiritualHabit.dateKey(day ?? DateTime.now());
    state = [
      for (final h in state)
        h.id == id
            ? h.copyWith(
                completedDates: h.completedDates.contains(key)
                    ? (h.completedDates.where((d) => d != key).toList())
                    : [...h.completedDates, key],
              )
            : h,
    ];
    await _persist();
  }

  Future<void> addCustom({
    required String title,
    required String iconName,
    required GoalFrequency frequency,
  }) async {
    final habit = SpiritualHabit(
      id: 'custom_${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      iconName: iconName,
      frequency: frequency,
      createdAt: DateTime.now(),
      isCustom: true,
      sortOrder: state.length,
    );
    state = [...state, habit];
    await _persist();
  }

  Future<void> updateDetails(
    String id, {
    String? title,
    String? iconName,
    GoalFrequency? frequency,
  }) async {
    state = [
      for (final h in state)
        h.id == id
            ? h.copyWith(title: title, iconName: iconName, frequency: frequency)
            : h,
    ];
    await _persist();
  }

  Future<void> setEnabled(String id, bool enabled) async {
    state = [
      for (final h in state) h.id == id ? h.copyWith(isEnabled: enabled) : h,
    ];
    await _persist();
  }

  Future<void> deleteCustom(String id) async {
    state = state.where((h) => h.id != id || !h.isCustom).toList();
    await _persist();
  }

  /// Clears one habit's completion history without touching the others.
  Future<void> resetHistory(String id) async {
    state = [
      for (final h in state)
        h.id == id ? h.copyWith(completedDates: const []) : h,
    ];
    await _persist();
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final list = [...state];
    if (newIndex > oldIndex) newIndex--;
    final moved = list.removeAt(oldIndex);
    list.insert(newIndex, moved);
    state = [
      for (final (i, h) in list.indexed) h.copyWith(sortOrder: i),
    ];
    await _persist();
  }

  SpiritualHabit? byId(String id) {
    for (final h in state) {
      if (h.id == id) return h;
    }
    return null;
  }
}

/// Habits currently shown on the tracker.
final enabledHabitsProvider = Provider<List<SpiritualHabit>>((ref) =>
    ref.watch(spiritualHabitsProvider).where((h) => h.isEnabled).toList());

/// Longest daily streak across the prayer habits.
final prayerStreakProvider = Provider<int>((ref) {
  final habits = ref.watch(spiritualHabitsProvider);
  var streak = 0;
  for (final h in habits) {
    if ((h.id == 'morning_prayer' || h.id == 'evening_prayer') &&
        h.currentStreak > streak) {
      streak = h.currentStreak;
    }
  }
  return streak;
});

/// Streak for scripture reading (Bible reading habit).
final scriptureStreakProvider = Provider<int>((ref) {
  final habits = ref.watch(spiritualHabitsProvider);
  for (final h in habits) {
    if (h.id == 'bible_reading') return h.currentStreak;
  }
  return 0;
});

/// 0.0–1.0: how much of this week's habit targets are complete so far.
final weeklyConsistencyProvider = Provider<double>((ref) {
  final habits = ref.watch(enabledHabitsProvider);
  if (habits.isEmpty) return 0;
  var total = 0.0;
  for (final h in habits) {
    total += (h.completionsThisWeek / h.weeklyTarget).clamp(0.0, 1.0);
  }
  return total / habits.length;
});
