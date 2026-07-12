import 'package:daily_armourup/core/storage/local_storage_service.dart';
import 'package:daily_armourup/shared/models/rescue_session.dart';
import 'package:daily_armourup/shared/models/saved_verse.dart';
import 'package:daily_armourup/shared/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> _container() async {
  final storage = await LocalStorageService.init();
  return ProviderContainer(
    overrides: [localStorageProvider.overrideWithValue(storage)],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('rescue session with feltStronger increments resisted count', () async {
    SharedPreferences.setMockInitialValues({});
    final container = await _container();

    final before = container.read(disciplineStatsProvider).temptationsResisted;
    await container.read(rescueSessionsProvider.notifier).add(RescueSession(
          id: '1',
          category: 'lust',
          dateTime: DateTime.now(),
          outcome: RescueOutcome.feltStronger,
          feltStronger: true,
        ));

    expect(container.read(rescueSessionsProvider).length, 1);
    expect(container.read(disciplineStatsProvider).temptationsResisted,
        before + 1);

    // A fresh container (simulating an app restart) reads the same data.
    final restarted = await _container();
    expect(restarted.read(rescueSessionsProvider).length, 1);
    expect(restarted.read(disciplineStatsProvider).temptationsResisted,
        before + 1);
  });

  test('saved verses persist notes and memory status', () async {
    SharedPreferences.setMockInitialValues({});
    final container = await _container();
    final notifier = container.read(savedVersesProvider.notifier);

    await notifier.toggle(
        text: 'Be still, and know that I am God.',
        reference: 'Psalm 46:10',
        category: 'Stress');
    final saved = container.read(savedVersesProvider).single;
    await notifier.updateNotes(saved.id, 'My anchor verse');
    await notifier.updateMemoryStatus(saved.id, MemoryStatus.learning);

    final restarted = await _container();
    final restored = restarted.read(savedVersesProvider).single;
    expect(restored.reference, 'Psalm 46:10');
    expect(restored.notes, 'My anchor verse');
    expect(restored.memoryStatus, MemoryStatus.learning);
  });

  test('legacy saved verse references migrate to the new format', () async {
    SharedPreferences.setMockInitialValues({
      LocalStorageService.keySavedVerses: '{"references":["Psalm 28:7"]}',
    });
    final container = await _container();
    final migrated = container.read(savedVersesProvider);
    expect(migrated.single.reference, 'Psalm 28:7');
    expect(migrated.single.text, isNotEmpty);
  });
}
