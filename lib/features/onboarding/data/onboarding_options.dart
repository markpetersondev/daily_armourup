import 'package:flutter/material.dart';

/// A selectable focus area shown during onboarding.
class FocusAreaOption {
  const FocusAreaOption({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

const focusAreaOptions = [
  FocusAreaOption(label: 'Temptation and self-control', icon: Icons.shield_outlined),
  FocusAreaOption(label: 'Anxiety and fear', icon: Icons.air_outlined),
  FocusAreaOption(label: 'Anger and forgiveness', icon: Icons.favorite_outline),
  FocusAreaOption(label: 'Purity and relationships', icon: Icons.spa_outlined),
  FocusAreaOption(label: 'Prayer consistency', icon: Icons.wb_twilight_outlined),
  FocusAreaOption(label: 'Bible reading discipline', icon: Icons.menu_book_outlined),
  FocusAreaOption(label: 'Social media distraction', icon: Icons.phone_iphone_outlined),
  FocusAreaOption(label: 'Stress and burnout', icon: Icons.local_fire_department_outlined),
  FocusAreaOption(label: 'Loneliness', icon: Icons.person_outline),
  FocusAreaOption(label: 'Building stronger faith', icon: Icons.terrain_outlined),
];

/// A spiritual habit the user can commit to.
class GoalOption {
  const GoalOption({required this.id, required this.label, required this.icon});

  final String id;
  final String label;
  final IconData icon;
}

const goalOptions = [
  GoalOption(id: 'pray_daily', label: 'Pray daily', icon: Icons.wb_twilight_outlined),
  GoalOption(id: 'read_scripture', label: 'Read Scripture daily', icon: Icons.menu_book_outlined),
  GoalOption(id: 'journal_weekly', label: 'Journal weekly', icon: Icons.edit_note_outlined),
  GoalOption(id: 'gratitude', label: 'Practice gratitude', icon: Icons.volunteer_activism_outlined),
  GoalOption(id: 'memorise_verses', label: 'Memorise Bible verses', icon: Icons.psychology_outlined),
  GoalOption(id: 'reduce_distraction', label: 'Reduce distraction time', icon: Icons.timer_outlined),
  GoalOption(id: 'fasting', label: 'Join a fasting routine', icon: Icons.restaurant_outlined),
];
