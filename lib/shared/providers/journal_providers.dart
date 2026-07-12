import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/local_storage_service.dart';
import '../models/journal_entry.dart';
import '../models/mood_check_in.dart';
import 'app_providers.dart';

/// All journal entries, newest first.
final journalEntriesProvider =
    NotifierProvider<JournalEntriesNotifier, List<JournalEntry>>(
        JournalEntriesNotifier.new);

class JournalEntriesNotifier extends Notifier<List<JournalEntry>> {
  @override
  List<JournalEntry> build() {
    final entries = ref
        .read(localStorageProvider)
        .readJsonList(LocalStorageService.keyJournalEntries)
        .map(JournalEntry.fromJson)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  Future<void> _persist() => ref.read(localStorageProvider).writeJsonList(
        LocalStorageService.keyJournalEntries,
        state.map((e) => e.toJson()).toList(),
      );

  Future<void> add({
    required JournalEntryType type,
    required String title,
    required String content,
    Mood? mood,
    String verseReference = '',
  }) async {
    final now = DateTime.now();
    final entry = JournalEntry(
      id: '${now.microsecondsSinceEpoch}',
      type: type,
      title: title,
      content: content,
      mood: mood,
      verseReference: verseReference,
      date: now,
      isAnsweredPrayer: type == JournalEntryType.answeredPrayer,
      createdAt: now,
      updatedAt: now,
    );
    state = [entry, ...state];
    await _persist();
  }

  Future<void> update(JournalEntry updated) async {
    state = [
      for (final e in state)
        e.id == updated.id ? updated.copyWith(updatedAt: DateTime.now()) : e,
    ];
    await _persist();
  }

  Future<void> delete(String id) async {
    state = state.where((e) => e.id != id).toList();
    await _persist();
  }

  /// Converts an existing prayer into an answered prayer.
  Future<void> markAnswered(String id) async {
    state = [
      for (final e in state)
        e.id == id
            ? e.copyWith(
                type: JournalEntryType.answeredPrayer,
                isAnsweredPrayer: true,
                updatedAt: DateTime.now(),
              )
            : e,
    ];
    await _persist();
  }

  JournalEntry? byId(String id) {
    for (final e in state) {
      if (e.id == id) return e;
    }
    return null;
  }
}

/// Entries that record an answered prayer, newest first.
final answeredPrayersProvider = Provider<List<JournalEntry>>((ref) => ref
    .watch(journalEntriesProvider)
    .where((e) => e.countsAsAnswered)
    .toList());

/// Journal entries written since Monday of this week.
final journalEntriesThisWeekProvider = Provider<int>((ref) {
  final now = DateTime.now();
  final monday = DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: now.weekday - 1));
  return ref
      .watch(journalEntriesProvider)
      .where((e) => !e.date.isBefore(monday))
      .length;
});

/// Journal entries written this calendar month.
final journalEntriesThisMonthProvider = Provider<int>((ref) {
  final now = DateTime.now();
  return ref
      .watch(journalEntriesProvider)
      .where((e) => e.date.year == now.year && e.date.month == now.month)
      .length;
});
