import 'package:daily_armourup/core/storage/local_storage_service.dart';
import 'package:daily_armourup/features/focus/presentation/focus_screen.dart';
import 'package:daily_armourup/features/focus/presentation/focus_session_screen.dart';
import 'package:daily_armourup/features/rescue/data/rescue_content.dart';
import 'package:daily_armourup/features/rescue/presentation/recovery_screen.dart';
import 'package:daily_armourup/features/rescue/presentation/rescue_flow_screen.dart';
import 'package:daily_armourup/shared/models/focus_session.dart';
import 'package:daily_armourup/shared/models/journal_entry.dart';
import 'package:daily_armourup/shared/models/rescue_session.dart';
import 'package:daily_armourup/shared/providers/app_providers.dart';
import 'package:daily_armourup/shared/providers/journal_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pumps [screen] pushed over a blank home, and returns the provider container.
Future<ProviderContainer> pumpScreen(WidgetTester tester, Widget screen) async {
  SharedPreferences.setMockInitialValues({});
  final storage = await LocalStorageService.init();
  final container = ProviderContainer(
    overrides: [localStorageProvider.overrideWithValue(storage)],
  );
  addTearDown(container.dispose);
  final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (_, __) => const Scaffold(body: Text('Home')),
      ),
      GoRoute(path: '/screen', builder: (_, __) => screen),
      GoRoute(
        path: '/rescue',
        builder: (_, __) => const Scaffold(body: Text('Rescue')),
      ),
    ],
  );
  await tester.pumpWidget(UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(routerConfig: router),
  ));
  await tester.pumpAndSettle();
  router.push('/screen');
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
  return container;
}

void main() {
  group('leaving Rescue still counts as reaching for help', () {
    testWidgets('close button during the flow', (tester) async {
      final container = await pumpScreen(
          tester, const RescueFlowScreen(category: RescueCategory.anxiety));

      await tester.tap(find.byTooltip('Leave rescue'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      final sessions = container.read(rescueSessionsProvider);
      expect(sessions, hasLength(1));
      expect(sessions.single.outcome, RescueOutcome.leftEarly);
      expect(sessions.single.feltStronger, isFalse);
    });

    testWidgets('close button on Recovery saves once', (tester) async {
      final container = await pumpScreen(
          tester, const RecoveryScreen(category: RescueCategory.anxiety));

      await tester.tap(find.byTooltip('Back to Rescue'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      final sessions = container.read(rescueSessionsProvider);
      expect(sessions, hasLength(1));
      expect(sessions.single.outcome, RescueOutcome.slipped);
    });
  });

  testWidgets('Focus reflection is saved to the Journal', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final container = await pumpScreen(
      tester,
      const FocusSessionScreen(
        config: FocusSessionConfig(
          mode: FocusMode.prayer,
          duration: Duration(minutes: 1),
          showVerse: false,
        ),
      ),
    );

    for (var i = 0; i < 62; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    expect(find.textContaining('for 1 minute of'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'He was near');
    await tester.tap(find.text('Finish'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final entries = container.read(journalEntriesProvider);
    expect(entries, hasLength(1));
    expect(entries.single.type, JournalEntryType.reflection);
    expect(entries.single.content, 'He was near');
    expect(container.read(focusSessionsProvider), hasLength(1));
  });
}
