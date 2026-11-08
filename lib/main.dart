import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/app_strings.dart';
import 'core/router/app_router.dart';
import 'core/storage/local_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'shared/providers/app_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fonts are bundled in assets/fonts/google_fonts/ so the app stays fully
  // offline — never fall back to fetching them over the network.
  GoogleFonts.config.allowRuntimeFetching = false;
  _registerFontLicenses();

  final storage = await LocalStorageService.init();
  runApp(
    ProviderScope(
      overrides: [localStorageProvider.overrideWithValue(storage)],
      child: const ArmourAndPrayerApp(),
    ),
  );
}

/// The bundled fonts are under the SIL Open Font License, which must ship with
/// them; registering makes them appear on the Open-source licences page.
void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (family, file) in [
      ('Inter', 'Inter-OFL.txt'),
      ('Playfair Display', 'PlayfairDisplay-OFL.txt'),
    ]) {
      final text =
          await rootBundle.loadString('assets/fonts/google_fonts/$file');
      yield LicenseEntryWithLineBreaks([family], text);
    }
  });
}

class ArmourAndPrayerApp extends ConsumerWidget {
  const ArmourAndPrayerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
