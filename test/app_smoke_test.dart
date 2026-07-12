import 'package:daily_armourup/core/storage/local_storage_service.dart';
import 'package:daily_armourup/main.dart';
import 'package:daily_armourup/shared/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Widget> _buildApp() async {
  final storage = await LocalStorageService.init();
  return ProviderScope(
    overrides: [localStorageProvider.overrideWithValue(storage)],
    child: const ArmourAndPrayerApp(),
  );
}

void main() {
  testWidgets('shows onboarding on first launch', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(await _buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Armour & Prayer'), findsOneWidget);
    expect(find.text('Begin My Journey'), findsOneWidget);
  });

  testWidgets('shows home dashboard when onboarding is complete',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      LocalStorageService.keyUserProfile:
          '{"name":"Sam","onboardingCompleted":true}',
    });
    await tester.pumpWidget(await _buildApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Sam'), findsWidgets);
    expect(find.text('How is your heart today?'), findsOneWidget);
  });
}
