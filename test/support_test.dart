import 'package:daily_armourup/core/constants/app_strings.dart';
import 'package:daily_armourup/core/router/app_router.dart';
import 'package:daily_armourup/core/storage/local_storage_service.dart';
import 'package:daily_armourup/features/support/data/faq_content.dart';
import 'package:daily_armourup/main.dart';
import 'package:daily_armourup/shared/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<GoRouter> _pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 6000);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues({
    LocalStorageService.keyUserProfile:
        '{"name":"Sam","onboardingCompleted":true}',
  });
  PackageInfo.setMockInitialValues(
    appName: 'Armour Up Daily',
    packageName: 'com.hustlebluprint.armourupdaily',
    version: '1.0.0',
    buildNumber: '2',
    buildSignature: '',
  );
  final storage = await LocalStorageService.init();
  await tester.pumpWidget(ProviderScope(
    overrides: [localStorageProvider.overrideWithValue(storage)],
    child: const ArmourAndPrayerApp(),
  ));
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
  return ProviderScope.containerOf(tester.element(find.byType(MaterialApp)))
      .read(appRouterProvider);
}

/// Whether the journal text box (the second text field) has the keyboard.
bool _bodyFieldFocused(WidgetTester tester) => tester
    .widget<EditableText>(find.byType(EditableText).at(1))
    .focusNode
    .hasFocus;

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  testWidgets('Profile shows the build version and Help & support',
      (tester) async {
    final router = await _pumpApp(tester);
    router.go(AppRoutes.profile);
    await _settle(tester);

    expect(find.text('Version 1.0.0 (2) · ${AppStrings.tagline}'),
        findsOneWidget);
    expect(find.text('Contact us'), findsOneWidget);
    expect(find.text(AppStrings.supportEmail), findsOneWidget);

    await tester.ensureVisible(find.text('Help & FAQ'));
    await tester.tap(find.text('Help & FAQ'));
    await _settle(tester);
    expect(find.widgetWithText(AppBar, 'Help & FAQ'), findsOneWidget);
  });

  testWidgets('Help lists every FAQ and expands to show the answer',
      (tester) async {
    final router = await _pumpApp(tester);
    router.go(AppRoutes.help);
    await _settle(tester);

    for (final item in faqItems) {
      expect(find.text(item.question), findsOneWidget);
    }
    final first = faqItems.first;
    expect(find.text(first.answer), findsNothing);
    await tester.tap(find.text(first.question));
    await _settle(tester);
    expect(find.text(first.answer), findsOneWidget);
    expect(find.text('Contact us'), findsOneWidget);
  });

  testWidgets('tapping outside a text field closes the keyboard',
      (tester) async {
    final router = await _pumpApp(tester);
    router.go(AppRoutes.journalNew);
    await _settle(tester);

    await tester.tap(find.byType(TextField).at(1));
    await tester.pump();
    expect(_bodyFieldFocused(tester), isTrue);

    // Tap empty space beside the heading.
    await tester.tapAt(tester.getTopRight(find.text('How is your heart?')) +
        const Offset(20, 0));
    await tester.pump();
    expect(_bodyFieldFocused(tester), isFalse);
  });

  testWidgets('scrolling closes the keyboard', (tester) async {
    final router = await _pumpApp(tester);
    // A normal phone height, so the editor actually scrolls.
    tester.view.physicalSize = const Size(1080, 2400);
    await _settle(tester);
    router.go(AppRoutes.journalNew);
    await _settle(tester);

    await tester.tap(find.byType(TextField).at(1));
    await tester.pump();
    expect(_bodyFieldFocused(tester), isTrue);

    await tester.drag(find.byType(ListView), const Offset(0, -200));
    await tester.pump();
    expect(_bodyFieldFocused(tester), isFalse);
  });
}
