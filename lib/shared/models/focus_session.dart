/// The kinds of Sacred Focus sessions.
enum FocusMode {
  prayer('Prayer'),
  bibleReading('Bible Reading'),
  worship('Worship'),
  quietReflection('Quiet Reflection'),
  resistDistraction('Resist Distraction');

  const FocusMode(this.label);
  final String label;
}

/// One Sacred Focus session, stored locally.
class FocusSession {
  const FocusSession({
    required this.id,
    required this.mode,
    required this.duration,
    required this.completedAt,
    this.reflection,
    this.completed = true,
  });

  final String id;
  final FocusMode mode;
  final Duration duration;
  final DateTime completedAt;
  final String? reflection;
  final bool completed;

  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    return !completedAt.isBefore(startOfWeek);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'mode': mode.name,
        'durationSeconds': duration.inSeconds,
        'completedAt': completedAt.toIso8601String(),
        'reflection': reflection,
        'completed': completed,
      };

  factory FocusSession.fromJson(Map<String, dynamic> json) => FocusSession(
        id: json['id'] as String? ?? '',
        mode: FocusMode.values.firstWhere(
          (m) => m.name == json['mode'],
          orElse: () => FocusMode.prayer,
        ),
        duration: Duration(seconds: json['durationSeconds'] as int? ?? 0),
        completedAt: DateTime.tryParse(json['completedAt'] as String? ?? '') ??
            DateTime.now(),
        reflection: json['reflection'] as String?,
        completed: json['completed'] as bool? ?? true,
      );
}
