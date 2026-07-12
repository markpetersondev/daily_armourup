import 'package:flutter/material.dart';

import 'user_profile.dart';

/// Icon names persisted with habits, resolved to Material icons.
const Map<String, IconData> habitIcons = {
  'morning': Icons.wb_twilight_outlined,
  'evening': Icons.nights_stay_outlined,
  'bible': Icons.menu_book_outlined,
  'devotional': Icons.local_library_outlined,
  'journal': Icons.edit_note_outlined,
  'gratitude': Icons.volunteer_activism_outlined,
  'memory': Icons.psychology_outlined,
  'fasting': Icons.restaurant_outlined,
  'worship': Icons.music_note_outlined,
  'serve': Icons.handshake_outlined,
  'focus': Icons.timer_outlined,
  'church': Icons.church_outlined,
  'pray_for': Icons.favorite_outline,
  'psalm': Icons.auto_stories_outlined,
  'night': Icons.bedtime_outlined,
  'star': Icons.star_outline,
};

IconData habitIcon(String name) => habitIcons[name] ?? Icons.star_outline;

/// A spiritual practice the user is building, with local completion history.
class SpiritualHabit {
  const SpiritualHabit({
    required this.id,
    required this.title,
    required this.iconName,
    this.frequency = GoalFrequency.daily,
    this.completedDates = const [],
    required this.createdAt,
    this.isEnabled = true,
    this.isCustom = false,
    this.sortOrder = 0,
  });

  final String id;
  final String title;
  final String iconName;
  final GoalFrequency frequency;

  /// Completed days stored as `yyyy-MM-dd` strings (local dates).
  final List<String> completedDates;
  final DateTime createdAt;
  final bool isEnabled;
  final bool isCustom;
  final int sortOrder;

  IconData get icon => habitIcon(iconName);

  static String dateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  bool isCompletedOn(DateTime day) => completedDates.contains(dateKey(day));

  bool get isCompletedToday => isCompletedOn(DateTime.now());

  /// Completions per target this week (Monday-start).
  int get completionsThisWeek {
    final now = DateTime.now();
    final monday = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    var count = 0;
    for (var i = 0; i < 7; i++) {
      if (isCompletedOn(monday.add(Duration(days: i)))) count++;
    }
    return count;
  }

  /// How many completions this habit aims for in a week.
  int get weeklyTarget => switch (frequency) {
        GoalFrequency.daily => 7,
        GoalFrequency.threeTimesAWeek => 3,
        GoalFrequency.weekly => 1,
      };

  /// Current streak. Daily habits count consecutive days (today may still
  /// be pending); other frequencies count consecutive weeks that met their
  /// target (this week counts once any progress is made).
  int get currentStreak {
    if (completedDates.isEmpty) return 0;
    final today = DateTime.now();
    if (frequency == GoalFrequency.daily) {
      var streak = 0;
      var day = DateTime(today.year, today.month, today.day);
      if (!isCompletedOn(day)) day = day.subtract(const Duration(days: 1));
      while (isCompletedOn(day)) {
        streak++;
        day = day.subtract(const Duration(days: 1));
      }
      return streak;
    }
    // Week-based streak.
    var monday = DateTime(today.year, today.month, today.day)
        .subtract(Duration(days: today.weekday - 1));
    int completionsInWeek(DateTime weekStart) {
      var count = 0;
      for (var i = 0; i < 7; i++) {
        if (isCompletedOn(weekStart.add(Duration(days: i)))) count++;
      }
      return count;
    }

    var streak = 0;
    // The current, in-progress week counts as soon as it has any progress.
    if (completionsInWeek(monday) > 0) streak++;
    monday = monday.subtract(const Duration(days: 7));
    while (completionsInWeek(monday) >= weeklyTarget) {
      streak++;
      monday = monday.subtract(const Duration(days: 7));
    }
    return streak;
  }

  /// Most recent completion dates, newest first.
  List<DateTime> get recentCompletions {
    final dates = completedDates
        .map((s) => DateTime.tryParse(s))
        .whereType<DateTime>()
        .toList()
      ..sort((a, b) => b.compareTo(a));
    return dates;
  }

  SpiritualHabit copyWith({
    String? title,
    String? iconName,
    GoalFrequency? frequency,
    List<String>? completedDates,
    bool? isEnabled,
    int? sortOrder,
  }) =>
      SpiritualHabit(
        id: id,
        title: title ?? this.title,
        iconName: iconName ?? this.iconName,
        frequency: frequency ?? this.frequency,
        completedDates: completedDates ?? this.completedDates,
        createdAt: createdAt,
        isEnabled: isEnabled ?? this.isEnabled,
        isCustom: isCustom,
        sortOrder: sortOrder ?? this.sortOrder,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'iconName': iconName,
        'frequency': frequency.name,
        'completedDates': completedDates,
        'createdAt': createdAt.toIso8601String(),
        'isEnabled': isEnabled,
        'isCustom': isCustom,
        'sortOrder': sortOrder,
        'currentStreak': currentStreak,
      };

  factory SpiritualHabit.fromJson(Map<String, dynamic> json) => SpiritualHabit(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        iconName: json['iconName'] as String? ?? 'star',
        frequency: GoalFrequency.values.firstWhere(
          (f) => f.name == json['frequency'],
          orElse: () => GoalFrequency.daily,
        ),
        completedDates:
            (json['completedDates'] as List<dynamic>? ?? const []).cast<String>(),
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
        isEnabled: json['isEnabled'] as bool? ?? true,
        isCustom: json['isCustom'] as bool? ?? false,
        sortOrder: json['sortOrder'] as int? ?? 0,
      );
}
