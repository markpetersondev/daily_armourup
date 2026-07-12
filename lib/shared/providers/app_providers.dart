import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/local_storage_service.dart';
import '../models/discipline_stats.dart';
import '../models/focus_session.dart';
import '../models/mood_check_in.dart';
import '../models/rescue_session.dart';
import '../models/saved_verse.dart';
import '../models/user_profile.dart';
import '../models/verse.dart';

/// Overridden in `main()` with the initialised instance.
final localStorageProvider = Provider<LocalStorageService>(
  (ref) => throw UnimplementedError('Initialised in main()'),
);

/// The user's locally persisted profile.
final userProfileProvider =
    NotifierProvider<UserProfileNotifier, UserProfile>(UserProfileNotifier.new);

class UserProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    final json =
        ref.read(localStorageProvider).readJson(LocalStorageService.keyUserProfile);
    return json != null ? UserProfile.fromJson(json) : const UserProfile();
  }

  Future<void> update(UserProfile profile) async {
    state = profile;
    await ref
        .read(localStorageProvider)
        .writeJson(LocalStorageService.keyUserProfile, profile.toJson());
  }

  Future<void> setThemeMode(ThemeMode mode) =>
      update(state.copyWith(selectedThemeMode: mode));

  Future<void> completeOnboarding({
    required String name,
    required List<String> focusAreas,
    required List<SpiritualGoal> goals,
    required ReminderPreferences reminders,
  }) =>
      update(state.copyWith(
        name: name,
        focusAreas: focusAreas,
        spiritualGoals: goals,
        reminderPreferences: reminders,
        onboardingCompleted: true,
      ));
}

/// Theme mode derived from the profile, so it persists across launches.
final themeModeProvider = Provider<ThemeMode>(
  (ref) => ref.watch(userProfileProvider.select((p) => p.selectedThemeMode)),
);

/// All mood check-ins, newest last.
final moodCheckInsProvider =
    NotifierProvider<MoodCheckInsNotifier, List<MoodCheckIn>>(
        MoodCheckInsNotifier.new);

class MoodCheckInsNotifier extends Notifier<List<MoodCheckIn>> {
  @override
  List<MoodCheckIn> build() => ref
      .read(localStorageProvider)
      .readJsonList(LocalStorageService.keyMoodCheckIns)
      .map(MoodCheckIn.fromJson)
      .toList();

  Future<void> checkIn(Mood mood) async {
    final today = MoodCheckIn(mood: mood, date: DateTime.now());
    state = [...state.where((c) => !c.isToday), today];
    await ref.read(localStorageProvider).writeJsonList(
          LocalStorageService.keyMoodCheckIns,
          state.map((c) => c.toJson()).toList(),
        );
  }
}

/// Today's check-in, if the user has already checked in.
final todayCheckInProvider = Provider<MoodCheckIn?>((ref) {
  final checkIns = ref.watch(moodCheckInsProvider);
  for (final c in checkIns.reversed) {
    if (c.isToday) return c;
  }
  return null;
});

/// Discipline metrics, seeded with starter values on first launch.
final disciplineStatsProvider =
    NotifierProvider<DisciplineStatsNotifier, DisciplineStats>(
        DisciplineStatsNotifier.new);

class DisciplineStatsNotifier extends Notifier<DisciplineStats> {
  @override
  DisciplineStats build() {
    final storage = ref.read(localStorageProvider);
    final json = storage.readJson(LocalStorageService.keyDisciplineStats);
    if (json != null) return DisciplineStats.fromJson(json);
    final starter = DisciplineStats.starter();
    storage.writeJson(LocalStorageService.keyDisciplineStats, starter.toJson());
    return starter;
  }

  Future<void> update(DisciplineStats stats) async {
    state = stats;
    await ref
        .read(localStorageProvider)
        .writeJson(LocalStorageService.keyDisciplineStats, stats.toJson());
  }
}

/// Today's verse from the local rotation (changes each calendar day).
final dailyVerseProvider = Provider<Verse>((ref) {
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year)).inDays;
  return dailyVerses[dayOfYear % dailyVerses.length];
});

/// Verses the user has saved, with notes and memory progress.
final savedVersesProvider =
    NotifierProvider<SavedVersesNotifier, List<SavedVerse>>(
        SavedVersesNotifier.new);

class SavedVersesNotifier extends Notifier<List<SavedVerse>> {
  @override
  List<SavedVerse> build() {
    final storage = ref.read(localStorageProvider);
    final list = storage.readJsonList(LocalStorageService.keySavedVerses);
    if (list.isNotEmpty) return list.map(SavedVerse.fromJson).toList();

    // Migrate the Part 1 format ({'references': [...]}) if present.
    final legacy = storage.readJson(LocalStorageService.keySavedVerses);
    final refs =
        (legacy?['references'] as List<dynamic>? ?? const []).cast<String>();
    if (refs.isEmpty) return const [];
    final migrated = <SavedVerse>[
      for (final reference in refs)
        SavedVerse(
          id: reference,
          text: dailyVerses
              .firstWhere((v) => v.reference == reference,
                  orElse: () => const Verse(text: '', reference: ''))
              .text,
          reference: reference,
          savedAt: DateTime.now(),
        ),
    ];
    storage.writeJsonList(LocalStorageService.keySavedVerses,
        migrated.map((v) => v.toJson()).toList());
    return migrated;
  }

  bool isSaved(String reference) =>
      state.any((v) => v.reference == reference);

  Future<void> _persist() => ref.read(localStorageProvider).writeJsonList(
      LocalStorageService.keySavedVerses,
      state.map((v) => v.toJson()).toList());

  Future<void> toggle({
    required String text,
    required String reference,
    String category = '',
  }) async {
    if (isSaved(reference)) {
      state = state.where((v) => v.reference != reference).toList();
    } else {
      state = [
        ...state,
        SavedVerse(
          id: '${DateTime.now().microsecondsSinceEpoch}',
          text: text,
          reference: reference,
          category: category,
          savedAt: DateTime.now(),
        ),
      ];
    }
    await _persist();
  }

  Future<void> updateNotes(String id, String notes) async {
    state = [
      for (final v in state) v.id == id ? v.copyWith(notes: notes) : v,
    ];
    await _persist();
  }

  Future<void> updateMemoryStatus(String id, MemoryStatus status) async {
    state = [
      for (final v in state) v.id == id ? v.copyWith(memoryStatus: status) : v,
    ];
    await _persist();
  }
}

/// Completed rescue journeys, newest last.
final rescueSessionsProvider =
    NotifierProvider<RescueSessionsNotifier, List<RescueSession>>(
        RescueSessionsNotifier.new);

class RescueSessionsNotifier extends Notifier<List<RescueSession>> {
  @override
  List<RescueSession> build() => ref
      .read(localStorageProvider)
      .readJsonList(LocalStorageService.keyRescueSessions)
      .map(RescueSession.fromJson)
      .toList();

  Future<void> add(RescueSession session) async {
    state = [...state, session];
    await ref.read(localStorageProvider).writeJsonList(
        LocalStorageService.keyRescueSessions,
        state.map((s) => s.toJson()).toList());
    if (session.feltStronger) {
      final stats = ref.read(disciplineStatsProvider);
      await ref.read(disciplineStatsProvider.notifier).update(
          stats.copyWith(temptationsResisted: stats.temptationsResisted + 1));
    }
  }
}

/// Completed Sacred Focus sessions, newest last.
final focusSessionsProvider =
    NotifierProvider<FocusSessionsNotifier, List<FocusSession>>(
        FocusSessionsNotifier.new);

class FocusSessionsNotifier extends Notifier<List<FocusSession>> {
  @override
  List<FocusSession> build() => ref
      .read(localStorageProvider)
      .readJsonList(LocalStorageService.keyFocusSessions)
      .map(FocusSession.fromJson)
      .toList();

  Future<void> add(FocusSession session) async {
    state = [...state, session];
    await ref.read(localStorageProvider).writeJsonList(
        LocalStorageService.keyFocusSessions,
        state.map((s) => s.toJson()).toList());
  }
}

/// Focus sessions completed since Monday of this week.
final focusSessionsThisWeekProvider = Provider<int>((ref) => ref
    .watch(focusSessionsProvider)
    .where((s) => s.completed && s.isThisWeek)
    .length);

/// Ids of prayers the user has saved.
final savedPrayersProvider =
    NotifierProvider<SavedPrayersNotifier, Set<String>>(
        SavedPrayersNotifier.new);

class SavedPrayersNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final json = ref
        .read(localStorageProvider)
        .readJson(LocalStorageService.keySavedPrayers);
    return (json?['ids'] as List<dynamic>? ?? const []).cast<String>().toSet();
  }

  Future<void> toggle(String id) async {
    state =
        state.contains(id) ? ({...state}..remove(id)) : {...state, id};
    await ref.read(localStorageProvider).writeJson(
        LocalStorageService.keySavedPrayers, {'ids': state.toList()});
  }
}
