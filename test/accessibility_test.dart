// Accessibility checks on every screen, using Flutter's built-in guidelines:
// - labeledTapTargetGuideline: everything tappable has a label TalkBack and
//   VoiceOver can read out.
// - androidTapTargetGuideline: tap targets are at least 48x48.
// - textContrastGuideline: text meets WCAG contrast against its background.

import 'package:daily_armourup/core/router/app_router.dart';
import 'package:daily_armourup/core/storage/local_storage_service.dart';
import 'package:daily_armourup/main.dart';
import 'package:daily_armourup/shared/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _onboarded = '{"name":"Sam","onboardingCompleted":true}';

Future<GoRouter> _pumpApp(WidgetTester tester, {bool onboarded = true}) async {
  // Tall enough that the checks see whole screens rather than sampling text
  // that is partly scrolled out of view.
  tester.view.physicalSize = const Size(1080, 6000);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues({
    if (onboarded) LocalStorageService.keyUserProfile: _onboarded,
  });
  final storage = await LocalStorageService.init();
  await tester.pumpWidget(ProviderScope(
    overrides: [localStorageProvider.overrideWithValue(storage)],
    child: const ArmourAndPrayerApp(),
  ));
  await _settle(tester);
  return ProviderScope.containerOf(tester.element(find.byType(MaterialApp)))
      .read(appRouterProvider);
}

/// Some screens animate forever (breathing, timers), so pump a fixed time.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

Future<void> _checkGuidelines(WidgetTester tester,
    {bool tapTargets = true}) async {
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  if (tapTargets) {
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  }
  await expectLater(tester, meetsGuideline(textContrastGuideline));
}

void main() {
  const routes = [
    AppRoutes.home,
    AppRoutes.scripture,
    AppRoutes.rescue,
    AppRoutes.journal,
    AppRoutes.profile,
    AppRoutes.focus,
    AppRoutes.focusSession,
    AppRoutes.rescueRecovery,
    AppRoutes.prayers,
    '${AppRoutes.prayers}/anxiety',
    AppRoutes.journalNew,
    AppRoutes.disciplinesNew,
    AppRoutes.progress,
    AppRoutes.profileEdit,
    AppRoutes.armour,
  ];

  for (final route in routes) {
    testWidgets('$route meets accessibility guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      final router = await _pumpApp(tester);
      router.go(route);
      await _settle(tester);
      await _checkGuidelines(tester);
      handle.dispose();
    });
  }

  testWidgets('Rescue flow meets accessibility guidelines', (tester) async {
    final handle = tester.ensureSemantics();
    final router = await _pumpApp(tester);
    router.go(AppRoutes.rescueFlow);
    await _settle(tester);
    // "Continue" is disabled until breathing finishes. WCAG 1.4.3 exempts
    // inactive controls from contrast, so check from the Scripture step on.
    await tester.tap(find.text('Skip for now'));
    await _settle(tester);
    await _checkGuidelines(tester);
    handle.dispose();
  });

  testWidgets('Practices meets accessibility guidelines', (tester) async {
    final handle = tester.ensureSemantics();
    final router = await _pumpApp(tester);
    router.go(AppRoutes.disciplines);
    await _settle(tester);
    // Known exception: seven week-day cells can't each be 48 wide on a 360dp
    // phone. They only show a summary that their label already reads out.
    await _checkGuidelines(tester, tapTargets: false);
    final tickButtons = tester
        .widgetList<Semantics>(find.byWidgetPredicate((w) =>
            w is Semantics && (w.properties.label ?? '').startsWith('Mark ')))
        .toList();
    expect(tickButtons, isNotEmpty);
    for (final button in tickButtons) {
      final size = tester.getSize(find.byWidget(button));
      expect(size.width, greaterThanOrEqualTo(48), reason: button.properties.label);
      expect(size.height, greaterThanOrEqualTo(48), reason: button.properties.label);
    }
    handle.dispose();
  });

  testWidgets('Manage Practices meets accessibility guidelines',
      (tester) async {
    final handle = tester.ensureSemantics();
    final router = await _pumpApp(tester);
    router.go(AppRoutes.disciplines);
    await _settle(tester);
    await tester.tap(find.byTooltip('Manage practices'));
    await _settle(tester);
    await _checkGuidelines(tester);
    handle.dispose();
  });

  testWidgets('Onboarding meets accessibility guidelines', (tester) async {
    final handle = tester.ensureSemantics();
    await _pumpApp(tester, onboarded: false);
    await _checkGuidelines(tester);
    handle.dispose();
  });
}
