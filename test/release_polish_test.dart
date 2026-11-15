import 'package:daily_armourup/core/storage/local_storage_service.dart';
import 'package:daily_armourup/features/scripture/presentation/scripture_screen.dart';
import 'package:daily_armourup/main.dart';
import 'package:daily_armourup/shared/providers/app_providers.dart';
import 'package:daily_armourup/shared/widgets/verse_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Reflect on the Home verse opens a new entry with the verse',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      LocalStorageService.keyUserProfile:
          '{"name":"Sam","onboardingCompleted":true}',
    });
    final storage = await LocalStorageService.init();
    await tester.pumpWidget(ProviderScope(
      overrides: [localStorageProvider.overrideWithValue(storage)],
      child: const ArmourAndPrayerApp(),
    ));
    await tester.pumpAndSettle();

    final reference =
        tester.widget<VerseCard>(find.byType(VerseCard)).verse.reference;
    await tester.tap(find.text('Reflect'));
    await tester.pumpAndSettle();

    expect(find.text('New Entry'), findsOneWidget);
    final verseField = find.widgetWithText(TextField, reference);
    await tester.scrollUntilVisible(verseField, 200,
        scrollable: find.byType(Scrollable).last);
    expect(verseField, findsOneWidget);
  });

  for (final (scale, scrollable) in [(1.0, false), (2.0, true)]) {
    testWidgets('Scripture tabs scrollable=$scrollable at ${scale}x text',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storage = await LocalStorageService.init();
      await tester.pumpWidget(ProviderScope(
        overrides: [localStorageProvider.overrideWithValue(storage)],
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: const ScriptureScreen(),
        ),
      ));
      await tester.pumpAndSettle();

      expect(tester.widget<TabBar>(find.byType(TabBar)).isScrollable,
          scrollable);
    });
  }
}
