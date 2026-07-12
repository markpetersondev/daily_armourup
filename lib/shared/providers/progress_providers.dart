import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mood_check_in.dart';
import '../models/spiritual_habit.dart';
import 'app_providers.dart';
import 'habit_providers.dart';

/// The mood the user has checked in with most often since Monday.
final mostCommonMoodThisWeekProvider = Provider<Mood?>((ref) {
  final now = DateTime.now();
  final monday = DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: now.weekday - 1));
  final counts = <Mood, int>{};
  for (final c in ref.watch(moodCheckInsProvider)) {
    if (!c.date.isBefore(monday)) {
      counts[c.mood] = (counts[c.mood] ?? 0) + 1;
    }
  }
  if (counts.isEmpty) return null;
  return (counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
      .first
      .key;
});

/// The scripture category the user saves from most often.
final favouriteScriptureCategoryProvider = Provider<String?>((ref) {
  final counts = <String, int>{};
  for (final v in ref.watch(savedVersesProvider)) {
    if (v.category.isNotEmpty) {
      counts[v.category] = (counts[v.category] ?? 0) + 1;
    }
  }
  if (counts.isEmpty) return null;
  return (counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
      .first
      .key;
});

/// Rescue sessions the user has completed, total.
final rescueSessionsCompletedProvider =
    Provider<int>((ref) => ref.watch(rescueSessionsProvider).length);

/// One point of the seven-day rhythm chart.
class DayCompletion {
  const DayCompletion({
    required this.date,
    required this.completed,
    required this.target,
  });

  final DateTime date;
  final int completed;
  final int target;

  double get ratio => target == 0 ? 0 : (completed / target).clamp(0.0, 1.0);
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

/// Habit completion for each of the last seven days (oldest first).
final weekCompletionProvider = Provider<List<DayCompletion>>((ref) {
  final habits = ref.watch(enabledHabitsProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return [
    for (var i = 6; i >= 0; i--)
      () {
        final day = today.subtract(Duration(days: i));
        var completed = 0;
        for (final h in habits) {
          if (h.isCompletedOn(day)) completed++;
        }
        return DayCompletion(
          date: day,
          completed: completed,
          target: habits.length,
        );
      }(),
  ];
});

/// A gentle suggested next action for the Home dashboard.
class JourneySuggestion {
  const JourneySuggestion({
    required this.message,
    required this.actionLabel,
    required this.route,
  });

  final String message;
  final String actionLabel;
  final String route;
}

/// Picks one relevant next step from the latest mood, missed habits, or
/// chosen focus areas — encouragement, never pressure.
final journeySuggestionProvider = Provider<JourneySuggestion>((ref) {
  final todayMood = ref.watch(todayCheckInProvider)?.mood;

  // 1. Respond to how the heart is today.
  switch (todayMood) {
    case Mood.anxious:
      return const JourneySuggestion(
        message:
            'You said today feels anxious. Take two minutes to pray for peace.',
        actionLabel: 'Pray for Peace',
        route: '/prayers/anxiety',
      );
    case Mood.tempted:
      return const JourneySuggestion(
        message: 'Strength is one prayer away. You are not facing this alone.',
        actionLabel: 'Open Rescue',
        route: '/rescue',
      );
    case Mood.discouraged:
    case Mood.lonely:
      return const JourneySuggestion(
        message: 'Let a promise from Scripture speak over how you feel today.',
        actionLabel: 'Read a Verse',
        route: '/scripture',
      );
    case Mood.grateful:
      return const JourneySuggestion(
        message: 'A grateful heart is worth remembering. Write it down.',
        actionLabel: 'Write Gratitude',
        route: '/journal/new',
      );
    default:
      break;
  }

  // 2. Point to a practice still open today.
  final habits = ref.watch(enabledHabitsProvider);
  SpiritualHabit? open;
  for (final h in habits) {
    if (!h.isCompletedToday && h.completionsThisWeek < h.weeklyTarget) {
      open = h;
      break;
    }
  }
  if (open != null) {
    return JourneySuggestion(
      message: '“${_habitNudge(open.id)}” — ${open.title} is still open today.',
      actionLabel: 'Open Practices',
      route: '/disciplines',
    );
  }

  // 3. Fall back to the user's focus areas.
  final focusAreas = ref.watch(userProfileProvider).focusAreas;
  if (focusAreas.contains('Anxiety and fear')) {
    return const JourneySuggestion(
      message:
          'You marked anxiety as a focus area. Take two minutes to pray for peace.',
      actionLabel: 'Pray for Peace',
      route: '/prayers/anxiety',
    );
  }
  if (focusAreas.contains('Prayer consistency')) {
    return const JourneySuggestion(
      message: 'A quiet moment of prayer keeps your focus steady.',
      actionLabel: 'Pray Now',
      route: '/prayers',
    );
  }
  return const JourneySuggestion(
    message: 'Your next faithful step can begin now.',
    actionLabel: 'Take a Quiet Moment',
    route: '/focus',
  );
});

String _habitNudge(String habitId) => switch (habitId) {
      'morning_prayer' || 'evening_prayer' => 'Begin again today',
      'bible_reading' || 'devotional' => 'Small acts of faith build a steady life',
      'journal_reflection' => 'Faithfulness is built in quiet moments',
      _ => 'One faithful step at a time',
    };
