import 'package:flutter/material.dart';

/// A spiritual goal the user committed to, with a chosen frequency.
class SpiritualGoal {
  const SpiritualGoal({required this.id, required this.frequency});

  final String id;
  final GoalFrequency frequency;

  SpiritualGoal copyWith({GoalFrequency? frequency}) =>
      SpiritualGoal(id: id, frequency: frequency ?? this.frequency);

  Map<String, dynamic> toJson() => {'id': id, 'frequency': frequency.name};

  factory SpiritualGoal.fromJson(Map<String, dynamic> json) => SpiritualGoal(
        id: json['id'] as String,
        frequency: GoalFrequency.values.firstWhere(
          (f) => f.name == json['frequency'],
          orElse: () => GoalFrequency.daily,
        ),
      );
}

enum GoalFrequency {
  daily('Daily'),
  threeTimesAWeek('Three times a week'),
  weekly('Weekly');

  const GoalFrequency(this.label);
  final String label;
}

/// Reminder preferences captured in onboarding. Stored as minutes since
/// midnight; notifications themselves come in a later phase.
class ReminderPreferences {
  const ReminderPreferences({
    this.morningEnabled = true,
    this.morningMinutes = 7 * 60,
    this.middayEnabled = false,
    this.middayMinutes = 12 * 60 + 30,
    this.eveningEnabled = true,
    this.eveningMinutes = 21 * 60,
    this.highRiskEnabled = false,
    this.highRiskMinutes = 22 * 60,
  });

  final bool morningEnabled;
  final int morningMinutes;
  final bool middayEnabled;
  final int middayMinutes;
  final bool eveningEnabled;
  final int eveningMinutes;
  final bool highRiskEnabled;
  final int highRiskMinutes;

  ReminderPreferences copyWith({
    bool? morningEnabled,
    int? morningMinutes,
    bool? middayEnabled,
    int? middayMinutes,
    bool? eveningEnabled,
    int? eveningMinutes,
    bool? highRiskEnabled,
    int? highRiskMinutes,
  }) =>
      ReminderPreferences(
        morningEnabled: morningEnabled ?? this.morningEnabled,
        morningMinutes: morningMinutes ?? this.morningMinutes,
        middayEnabled: middayEnabled ?? this.middayEnabled,
        middayMinutes: middayMinutes ?? this.middayMinutes,
        eveningEnabled: eveningEnabled ?? this.eveningEnabled,
        eveningMinutes: eveningMinutes ?? this.eveningMinutes,
        highRiskEnabled: highRiskEnabled ?? this.highRiskEnabled,
        highRiskMinutes: highRiskMinutes ?? this.highRiskMinutes,
      );

  Map<String, dynamic> toJson() => {
        'morningEnabled': morningEnabled,
        'morningMinutes': morningMinutes,
        'middayEnabled': middayEnabled,
        'middayMinutes': middayMinutes,
        'eveningEnabled': eveningEnabled,
        'eveningMinutes': eveningMinutes,
        'highRiskEnabled': highRiskEnabled,
        'highRiskMinutes': highRiskMinutes,
      };

  factory ReminderPreferences.fromJson(Map<String, dynamic> json) =>
      ReminderPreferences(
        morningEnabled: json['morningEnabled'] as bool? ?? true,
        morningMinutes: json['morningMinutes'] as int? ?? 7 * 60,
        middayEnabled: json['middayEnabled'] as bool? ?? false,
        middayMinutes: json['middayMinutes'] as int? ?? 12 * 60 + 30,
        eveningEnabled: json['eveningEnabled'] as bool? ?? true,
        eveningMinutes: json['eveningMinutes'] as int? ?? 21 * 60,
        highRiskEnabled: json['highRiskEnabled'] as bool? ?? false,
        highRiskMinutes: json['highRiskMinutes'] as int? ?? 22 * 60,
      );
}

/// Locally persisted user profile — no accounts, no backend.
class UserProfile {
  const UserProfile({
    this.name = '',
    this.focusAreas = const [],
    this.spiritualGoals = const [],
    this.reminderPreferences = const ReminderPreferences(),
    this.onboardingCompleted = false,
    this.selectedThemeMode = ThemeMode.system,
    this.journalLockEnabled = false,
  });

  final String name;
  final List<String> focusAreas;
  final List<SpiritualGoal> spiritualGoals;
  final ReminderPreferences reminderPreferences;
  final bool onboardingCompleted;
  final ThemeMode selectedThemeMode;

  /// App-level privacy toggle for the journal (a setting, not device security).
  final bool journalLockEnabled;

  String get displayName => name.trim().isEmpty ? 'Friend' : name.trim();

  UserProfile copyWith({
    String? name,
    List<String>? focusAreas,
    List<SpiritualGoal>? spiritualGoals,
    ReminderPreferences? reminderPreferences,
    bool? onboardingCompleted,
    ThemeMode? selectedThemeMode,
    bool? journalLockEnabled,
  }) =>
      UserProfile(
        name: name ?? this.name,
        focusAreas: focusAreas ?? this.focusAreas,
        spiritualGoals: spiritualGoals ?? this.spiritualGoals,
        reminderPreferences: reminderPreferences ?? this.reminderPreferences,
        onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
        selectedThemeMode: selectedThemeMode ?? this.selectedThemeMode,
        journalLockEnabled: journalLockEnabled ?? this.journalLockEnabled,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'focusAreas': focusAreas,
        'spiritualGoals': spiritualGoals.map((g) => g.toJson()).toList(),
        'reminderPreferences': reminderPreferences.toJson(),
        'onboardingCompleted': onboardingCompleted,
        'selectedThemeMode': selectedThemeMode.name,
        'journalLockEnabled': journalLockEnabled,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String? ?? '',
        focusAreas:
            (json['focusAreas'] as List<dynamic>? ?? const []).cast<String>(),
        spiritualGoals: (json['spiritualGoals'] as List<dynamic>? ?? const [])
            .map((g) => SpiritualGoal.fromJson(g as Map<String, dynamic>))
            .toList(),
        reminderPreferences: json['reminderPreferences'] != null
            ? ReminderPreferences.fromJson(
                json['reminderPreferences'] as Map<String, dynamic>)
            : const ReminderPreferences(),
        onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
        selectedThemeMode: ThemeMode.values.firstWhere(
          (m) => m.name == json['selectedThemeMode'],
          orElse: () => ThemeMode.system,
        ),
        journalLockEnabled: json['journalLockEnabled'] as bool? ?? false,
      );
}
