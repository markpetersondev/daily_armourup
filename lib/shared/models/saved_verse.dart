/// Where a verse sits on the memorisation journey.
enum MemoryStatus {
  none('Not started'),
  learning('Learning'),
  practising('Practising'),
  memorised('Memorised');

  const MemoryStatus(this.label);
  final String label;
}

/// A verse the user has saved, with notes and memory progress.
class SavedVerse {
  const SavedVerse({
    required this.id,
    required this.text,
    required this.reference,
    this.category = '',
    this.notes = '',
    this.memoryStatus = MemoryStatus.none,
    required this.savedAt,
  });

  final String id;
  final String text;
  final String reference;
  final String category;
  final String notes;
  final MemoryStatus memoryStatus;
  final DateTime savedAt;

  SavedVerse copyWith({
    String? notes,
    MemoryStatus? memoryStatus,
  }) =>
      SavedVerse(
        id: id,
        text: text,
        reference: reference,
        category: category,
        notes: notes ?? this.notes,
        memoryStatus: memoryStatus ?? this.memoryStatus,
        savedAt: savedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'reference': reference,
        'category': category,
        'notes': notes,
        'memoryStatus': memoryStatus.name,
        'savedAt': savedAt.toIso8601String(),
      };

  factory SavedVerse.fromJson(Map<String, dynamic> json) => SavedVerse(
        id: json['id'] as String? ?? '',
        text: json['text'] as String? ?? '',
        reference: json['reference'] as String? ?? '',
        category: json['category'] as String? ?? '',
        notes: json['notes'] as String? ?? '',
        memoryStatus: MemoryStatus.values.firstWhere(
          (s) => s.name == json['memoryStatus'],
          orElse: () => MemoryStatus.none,
        ),
        savedAt:
            DateTime.tryParse(json['savedAt'] as String? ?? '') ?? DateTime.now(),
      );
}
