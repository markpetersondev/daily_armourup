// Covers features the device testing log listed as "not fully exercised":
// every journal type, practices reorder/switch off, every Focus mode with
// ending early and the verse prompt off, every Rescue category, the
// "I still need help" options, and streaks across clock changes.
//
// The streak tests are most meaningful in a timezone with daylight saving:
//   TZ=America/New_York flutter test test/feature_coverage_test.dart

import 'package:daily_armourup/core/storage/local_storage_service.dart';
import 'package:daily_armourup/core/utils/dates.dart';
import 'package:daily_armourup/features/focus/data/focus_content.dart';
import 'package:daily_armourup/features/focus/presentation/focus_screen.dart';
import 'package:daily_armourup/features/focus/presentation/focus_session_screen.dart';
import 'package:daily_armourup/features/journal/presentation/journal_entry_editor_screen.dart';
import 'package:daily_armourup/features/rescue/data/rescue_content.dart';
import 'package:daily_armourup/features/rescue/presentation/rescue_flow_screen.dart';
import 'package:daily_armourup/shared/models/focus_session.dart';
import 'package:daily_armourup/shared/models/journal_entry.dart';
import 'package:daily_armourup/shared/models/rescue_session.dart';
import 'package:daily_armourup/shared/models/spiritual_habit.dart';
import 'package:daily_armourup/shared/models/user_profile.dart';
import 'package:daily_armourup/shared/providers/app_providers.dart';
import 'package:daily_armourup/shared/providers/habit_providers.dart';
import 'package:daily_armourup/shared/providers/journal_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> _container() async {
  final storage = await LocalStorageService.init();
  final container = ProviderContainer(
    overrides: [localStorageProvider.overrideWithValue(storage)],
  );
  addTearDown(container.dispose);
  return container;
}

/// Pumps [screen] pushed over a blank home, on a tall phone-sized view.
Future<ProviderContainer> _pumpScreen(WidgetTester tester, Widget screen) async {
  tester.view.physicalSize = const Size(1080, 4800);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues({});
  final storage = await LocalStorageService.init();
  Widget placeholder(String name) => Scaffold(body: Text('$name screen'));
  final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(path: '/home', builder: (_, __) => placeholder('Home')),
      GoRoute(path: '/screen', builder: (_, __) => screen),
      GoRoute(path: '/focus', builder: (_, __) => placeholder('Focus')),
      GoRoute(path: '/rescue', builder: (_, __) => placeholder('Rescue')),
      GoRoute(
          path: '/journal/new', builder: (_, __) => placeholder('New entry')),
      GoRoute(
          path: '/journal/edit/:id',
          builder: (_, state) =>
              JournalEntryEditorScreen(entryId: state.pathParameters['id'])),
    ],
  );
  // ProviderScope owns the container, so it is disposed with the widget tree
  // (cancelling the midnight timer) just like in the real app.
  await tester.pumpWidget(ProviderScope(
    overrides: [localStorageProvider.overrideWithValue(storage)],
    child: MaterialApp.router(routerConfig: router),
  ));
  await tester.pumpAndSettle();
  router.push('/screen');
  await _settle(tester);
  return ProviderScope.containerOf(tester.element(find.byType(MaterialApp)));
}

/// Lets page transitions finish without waiting on looping animations.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

Future<void> _tapText(WidgetTester tester, String text) async {
  final finder = find.text(text).last;
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await _settle(tester);
}

void main() {
  group('Journal', () {
    for (final type in JournalEntryType.values) {
      testWidgets('saves a ${type.label} entry', (tester) async {
        final container =
            await _pumpScreen(tester, const JournalEntryEditorScreen());

        await _tapText(tester, type.label);
        await tester.enterText(find.byType(TextField).at(1), 'Entry text');
        await _tapText(tester, 'Save Entry');

        final entry = container.read(journalEntriesProvider).single;
        expect(entry.type, type);
        expect(entry.content, 'Entry text');
        expect(entry.countsAsAnswered, type == JournalEntryType.answeredPrayer);
      });
    }

    testWidgets('editing keeps the type and saves changes', (tester) async {
      final container =
          await _pumpScreen(tester, const Scaffold(body: Text('blank')));
      await container.read(journalEntriesProvider.notifier).add(
          type: JournalEntryType.temptationTrigger,
          title: 'Late night',
          content: 'Scrolling');
      final id = container.read(journalEntriesProvider).single.id;

      // Open the editor for the existing entry, as the Journal list does.
      final context = tester.element(find.text('blank'));
      GoRouter.of(context).push('/journal/edit/$id');
      await _settle(tester);

      expect(find.text('Edit Entry'), findsOneWidget);
      final chip = tester.widget<ChoiceChip>(
          find.widgetWithText(ChoiceChip, 'Temptation Trigger'));
      expect(chip.selected, isTrue);

      await tester.enterText(find.byType(TextField).at(1), 'Put the phone away');
      await _tapText(tester, 'Save Changes');

      final entry = container.read(journalEntriesProvider).single;
      expect(entry.type, JournalEntryType.temptationTrigger);
      expect(entry.content, 'Put the phone away');
      expect(find.text('blank'), findsOneWidget);
    });
  });

  group('Practices', () {
    test('reordering and switching off persist across restarts', () async {
      SharedPreferences.setMockInitialValues({});
      final first = await _container();
      final habits = first.read(spiritualHabitsProvider);
      final firstId = habits[0].id;
      final secondId = habits[1].id;

      // Drag the first practice below the second.
      await first.read(spiritualHabitsProvider.notifier).reorder(0, 2);
      await first
          .read(spiritualHabitsProvider.notifier)
          .setEnabled('bible_reading', false);

      // A fresh container reads back from storage, like reopening the app.
      final second = await _container();
      final reloaded = second.read(spiritualHabitsProvider);
      expect(reloaded[0].id, secondId);
      expect(reloaded[1].id, firstId);
      expect(
          second.read(enabledHabitsProvider).map((h) => h.id),
          isNot(contains('bible_reading')));
      expect(
          reloaded.firstWhere((h) => h.id == 'bible_reading').isEnabled, isFalse);
    });

    test('a switched-off practice keeps its history', () async {
      SharedPreferences.setMockInitialValues({});
      final container = await _container();
      final notifier = container.read(spiritualHabitsProvider.notifier);
      await notifier.toggleCompleted('gratitude');
      await notifier.setEnabled('gratitude', false);
      await notifier.setEnabled('gratitude', true);
      expect(notifier.byId('gratitude')!.isCompletedToday, isTrue);
    });
  });

  group('Streaks across daylight-saving changes', () {
    SpiritualHabit habit(List<DateTime> days,
            [GoalFrequency frequency = GoalFrequency.daily]) =>
        SpiritualHabit(
          id: 'h',
          title: 'Habit',
          iconName: 'star',
          frequency: frequency,
          createdAt: DateTime(2026),
          completedDates: [for (final d in days) SpiritualHabit.dateKey(d)],
        );

    test('daily streak counts every day around clocks going forward', () {
      // US clocks went forward on 8 March 2026; Europe on 29 March.
      for (final change in [DateTime(2026, 3, 8), DateTime(2026, 3, 29)]) {
        final days = [for (var i = -2; i <= 2; i++) addDays(change, i)];
        expect(habit(days).streakOn(days.last), 5, reason: '$change');
      }
    });

    test('daily streak counts every day around clocks going back', () {
      for (final change in [DateTime(2026, 11, 1), DateTime(2026, 10, 25)]) {
        final days = [for (var i = -2; i <= 2; i++) addDays(change, i)];
        expect(habit(days).streakOn(days.last), 5, reason: '$change');
      }
    });

    test('weekly streak spans a week with a clock change', () {
      final days = [DateTime(2026, 3, 2), DateTime(2026, 3, 9)];
      expect(
          habit(days, GoalFrequency.weekly).streakOn(DateTime(2026, 3, 10)), 2);
    });

    test('dates step by calendar day', () {
      expect(addDays(DateTime(2026, 3, 9), -1), DateTime(2026, 3, 8));
      expect(startOfWeek(DateTime(2026, 3, 11)), DateTime(2026, 3, 9));
      expect(dayOfYear(DateTime(2026, 3, 9)), 67);
      expect(dayOfYear(DateTime(2026, 3, 10)), 68);
    });
  });

  group('Sacred Focus', () {
    for (final mode in FocusMode.values) {
      for (final showVerse in [true, false]) {
        testWidgets('${mode.label}, verse ${showVerse ? 'on' : 'off'}, ends early',
            (tester) async {
          final container = await _pumpScreen(
            tester,
            FocusSessionScreen(
              config: FocusSessionConfig(
                mode: mode,
                duration: const Duration(minutes: 5),
                showVerse: showVerse,
              ),
            ),
          );
          final verse = focusModeContent[mode]!.verse;

          expect(find.text(mode.label), findsOneWidget);
          expect(find.text('— ${verse.reference}'),
              showVerse ? findsOneWidget : findsNothing);

          for (var i = 0; i < 3; i++) {
            await tester.pump(const Duration(seconds: 1));
          }
          await tester.tap(find.byTooltip('End session'));
          await _settle(tester);
          expect(find.text('Every quiet minute counts.'), findsOneWidget);

          await _tapText(tester, 'Finish');
          final session = container.read(focusSessionsProvider).single;
          expect(session.mode, mode);
          expect(session.completed, isFalse);
          expect(session.duration.inSeconds, inInclusiveRange(2, 5));
          // Ended early, so it doesn't count as a completed session.
          expect(container.read(focusSessionsThisWeekProvider), 0);
          expect(find.text('Home screen'), findsOneWidget);
        });
      }
    }
  });

  group('Rescue', () {
    test('every category has verses and a prayer', () {
      for (final category in RescueCategory.values) {
        expect(rescueVerses[category], isNotEmpty, reason: category.label);
        expect(rescuePrayers[category], isNotEmpty, reason: category.label);
      }
    });

    /// Walks the steps to the check-in and chooses "I still need help".
    Future<ProviderContainer> reachNeedHelp(
        WidgetTester tester, RescueCategory category) async {
      final container =
          await _pumpScreen(tester, RescueFlowScreen(category: category));
      await _tapText(tester, 'Skip for now'); // Breathe
      await _tapText(tester, 'Continue'); // Scripture
      await _tapText(tester, 'Continue'); // Prayer
      await _tapText(tester, 'Drink water'); // Action
      await _tapText(tester, 'Continue');
      await _tapText(tester, RescueOutcome.stillNeedHelp.label);
      expect(find.text('Stay here a little longer.'), findsOneWidget);
      return container;
    }

    for (final category in RescueCategory.values) {
      testWidgets('${category.label}: full flow, then begin again',
          (tester) async {
        final container = await reachNeedHelp(tester, category);
        final session = container.read(rescueSessionsProvider).single;
        expect(session.category, category.name);
        expect(session.outcome, RescueOutcome.stillNeedHelp);
        expect(session.selectedAction, 'Drink water');

        await _tapText(tester, 'Begin the rescue flow again');
        expect(find.text('Skip for now'), findsOneWidget);
        // The first attempt stays recorded once.
        expect(container.read(rescueSessionsProvider), hasLength(1));
      });
    }

    testWidgets('"I still need help" can start a focus session',
        (tester) async {
      final container = await reachNeedHelp(tester, RescueCategory.lust);
      await _tapText(tester, 'Start a focus session');
      expect(find.text('Focus screen'), findsOneWidget);
      expect(container.read(rescueSessionsProvider), hasLength(1));
    });
  });
}
