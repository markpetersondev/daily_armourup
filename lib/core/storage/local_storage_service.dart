import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around [SharedPreferences] providing JSON-friendly access.
///
/// Initialised once in `main()` and injected through Riverpod so it can be
/// replaced in tests.
class LocalStorageService {
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  static const keyUserProfile = 'user_profile';
  static const keyMoodCheckIns = 'mood_check_ins';
  static const keySavedVerses = 'saved_verses';
  static const keyDisciplineStats = 'discipline_stats';
  static const keyRescueSessions = 'rescue_sessions';
  static const keyFocusSessions = 'focus_sessions';
  static const keySavedPrayers = 'saved_prayers';
  static const keyJournalEntries = 'journal_entries';
  static const keySpiritualHabits = 'spiritual_habits';

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  Map<String, dynamic>? readJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } on FormatException {
      return null;
    }
  }

  Future<void> writeJson(String key, Map<String, dynamic> value) =>
      _prefs.setString(key, jsonEncode(value));

  List<Map<String, dynamic>> readJsonList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded.whereType<Map<String, dynamic>>().toList();
    } on FormatException {
      return const [];
    }
  }

  Future<void> writeJsonList(String key, List<Map<String, dynamic>> value) =>
      _prefs.setString(key, jsonEncode(value));

  Future<void> remove(String key) => _prefs.remove(key);

  /// Deletes everything — profile, habits, journal, verses, and progress.
  Future<void> clearAll() => _prefs.clear();
}
