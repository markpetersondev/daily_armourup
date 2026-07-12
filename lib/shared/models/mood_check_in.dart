import 'package:flutter/material.dart';

/// The moods a user can check in with, plus tailored grace-centered support.
enum Mood {
  peaceful('Peaceful', Icons.spa_outlined,
      'Rest in this peace — it is a gift worth guarding.', 'Give thanks in prayer', '/prayers'),
  hopeful('Hopeful', Icons.wb_twilight_outlined,
      'Hope anchors the soul. Keep your eyes lifted.', 'Read a verse', '/scripture'),
  grateful('Grateful', Icons.volunteer_activism_outlined,
      'A grateful heart sees God\'s hand everywhere.', 'Write it down', '/journal'),
  tired('Tired', Icons.nightlight_outlined,
      'Come to Him, weary one. He gives rest.', 'Take a quiet moment', '/focus'),
  anxious('Anxious', Icons.air_outlined,
      'Take a breath. God is near.', 'Pray for peace', '/prayers/anxiety'),
  tempted('Tempted', Icons.shield_outlined,
      'You do not have to face this moment alone.', 'Open Rescue', '/rescue'),
  lonely('Lonely', Icons.person_outline,
      'You are seen, known, and never truly alone.', 'Read a verse', '/scripture'),
  angry('Angry', Icons.local_fire_department_outlined,
      'Be slow to anger — bring it honestly to God.', 'Write it out', '/journal'),
  discouraged('Discouraged', Icons.filter_drama_outlined,
      'Grace meets you here. Take the next faithful step.', 'Read a verse', '/scripture');

  const Mood(this.label, this.icon, this.support, this.actionLabel, this.actionRoute);

  final String label;
  final IconData icon;
  final String support;
  final String actionLabel;
  final String actionRoute;
}

/// One persisted daily heart check-in.
class MoodCheckIn {
  const MoodCheckIn({required this.mood, required this.date});

  final Mood mood;
  final DateTime date;

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  Map<String, dynamic> toJson() =>
      {'mood': mood.name, 'date': date.toIso8601String()};

  factory MoodCheckIn.fromJson(Map<String, dynamic> json) => MoodCheckIn(
        mood: Mood.values.firstWhere(
          (m) => m.name == json['mood'],
          orElse: () => Mood.peaceful,
        ),
        date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      );
}
