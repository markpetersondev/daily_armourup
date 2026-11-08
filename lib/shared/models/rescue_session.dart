/// How a rescue moment concluded.
enum RescueOutcome {
  feltStronger('Yes, I feel stronger'),
  stillNeedHelp('I still need help'),
  slipped('I slipped, help me restart'),

  /// Left before the check-in. Reaching for help still counts (PRD 7.3).
  leftEarly('Left early');

  const RescueOutcome(this.label);
  final String label;
}

/// One completed (or concluded) Rescue journey, stored locally.
class RescueSession {
  const RescueSession({
    required this.id,
    required this.category,
    required this.dateTime,
    required this.outcome,
    this.selectedAction,
    this.note,
    this.feltStronger = false,
  });

  final String id;

  /// RescueCategory name (stored as string for stable persistence).
  final String category;
  final DateTime dateTime;
  final RescueOutcome outcome;
  final String? selectedAction;
  final String? note;
  final bool feltStronger;

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'dateTime': dateTime.toIso8601String(),
        'outcome': outcome.name,
        'selectedAction': selectedAction,
        'note': note,
        'feltStronger': feltStronger,
      };

  factory RescueSession.fromJson(Map<String, dynamic> json) => RescueSession(
        id: json['id'] as String? ?? '',
        category: json['category'] as String? ?? 'other',
        dateTime:
            DateTime.tryParse(json['dateTime'] as String? ?? '') ?? DateTime.now(),
        outcome: RescueOutcome.values.firstWhere(
          (o) => o.name == json['outcome'],
          orElse: () => RescueOutcome.feltStronger,
        ),
        selectedAction: json['selectedAction'] as String?,
        note: json['note'] as String?,
        feltStronger: json['feltStronger'] as bool? ?? false,
      );
}
