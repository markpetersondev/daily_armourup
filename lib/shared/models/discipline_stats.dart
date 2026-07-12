/// Locally tracked discipline metrics shown on the Home dashboard.
///
/// Seeded with gentle starter values on first launch; later features
/// (prayer, scripture, journal, rescue) will update these through the
/// discipline provider.
class DisciplineStats {
  const DisciplineStats({
    this.prayerStreak = 0,
    this.scriptureStreak = 0,
    this.journalEntriesThisWeek = 0,
    this.temptationsResisted = 0,
    this.weeklyProgress = 0.0,
  });

  final int prayerStreak;
  final int scriptureStreak;
  final int journalEntriesThisWeek;
  final int temptationsResisted;

  /// 0.0–1.0 completion of this week's spiritual goals.
  final double weeklyProgress;

  DisciplineStats copyWith({
    int? prayerStreak,
    int? scriptureStreak,
    int? journalEntriesThisWeek,
    int? temptationsResisted,
    double? weeklyProgress,
  }) =>
      DisciplineStats(
        prayerStreak: prayerStreak ?? this.prayerStreak,
        scriptureStreak: scriptureStreak ?? this.scriptureStreak,
        journalEntriesThisWeek:
            journalEntriesThisWeek ?? this.journalEntriesThisWeek,
        temptationsResisted: temptationsResisted ?? this.temptationsResisted,
        weeklyProgress: weeklyProgress ?? this.weeklyProgress,
      );

  Map<String, dynamic> toJson() => {
        'prayerStreak': prayerStreak,
        'scriptureStreak': scriptureStreak,
        'journalEntriesThisWeek': journalEntriesThisWeek,
        'temptationsResisted': temptationsResisted,
        'weeklyProgress': weeklyProgress,
      };

  factory DisciplineStats.fromJson(Map<String, dynamic> json) =>
      DisciplineStats(
        prayerStreak: json['prayerStreak'] as int? ?? 0,
        scriptureStreak: json['scriptureStreak'] as int? ?? 0,
        journalEntriesThisWeek: json['journalEntriesThisWeek'] as int? ?? 0,
        temptationsResisted: json['temptationsResisted'] as int? ?? 0,
        weeklyProgress: (json['weeklyProgress'] as num?)?.toDouble() ?? 0.0,
      );

  /// A brand-new journey starts honestly at zero; the dashboard derives its
  /// live numbers from real habit, journal, and rescue data.
  factory DisciplineStats.starter() => const DisciplineStats();
}
