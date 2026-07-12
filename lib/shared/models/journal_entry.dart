import 'package:flutter/material.dart';

import 'mood_check_in.dart';

/// The kinds of entries a user can write in their private journal.
enum JournalEntryType {
  prayer('Prayer', Icons.wb_twilight_outlined),
  gratitude('Gratitude', Icons.volunteer_activism_outlined),
  reflection('Reflection', Icons.self_improvement_outlined),
  temptationTrigger('Temptation Trigger', Icons.shield_outlined),
  answeredPrayer('Answered Prayer', Icons.auto_awesome_outlined),
  personalNote('Personal Note', Icons.edit_note_outlined);

  const JournalEntryType(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// One private journal entry, stored locally.
class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    this.mood,
    this.verseReference = '',
    required this.date,
    this.isAnsweredPrayer = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final JournalEntryType type;
  final String title;
  final String content;
  final Mood? mood;
  final String verseReference;
  final DateTime date;
  final bool isAnsweredPrayer;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get countsAsAnswered =>
      isAnsweredPrayer || type == JournalEntryType.answeredPrayer;

  JournalEntry copyWith({
    JournalEntryType? type,
    String? title,
    String? content,
    Mood? mood,
    bool clearMood = false,
    String? verseReference,
    DateTime? date,
    bool? isAnsweredPrayer,
    DateTime? updatedAt,
  }) =>
      JournalEntry(
        id: id,
        type: type ?? this.type,
        title: title ?? this.title,
        content: content ?? this.content,
        mood: clearMood ? null : (mood ?? this.mood),
        verseReference: verseReference ?? this.verseReference,
        date: date ?? this.date,
        isAnsweredPrayer: isAnsweredPrayer ?? this.isAnsweredPrayer,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'title': title,
        'content': content,
        'mood': mood?.name,
        'verseReference': verseReference,
        'date': date.toIso8601String(),
        'isAnsweredPrayer': isAnsweredPrayer,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return JournalEntry(
      id: json['id'] as String? ?? '',
      type: JournalEntryType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => JournalEntryType.personalNote,
      ),
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      mood: json['mood'] == null
          ? null
          : Mood.values.cast<Mood?>().firstWhere(
                (m) => m?.name == json['mood'],
                orElse: () => null,
              ),
      verseReference: json['verseReference'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? now,
      isAnsweredPrayer: json['isAnsweredPrayer'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? now,
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? now,
    );
  }
}
