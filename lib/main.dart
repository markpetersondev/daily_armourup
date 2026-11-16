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

  // Layouts are designed for portrait; iOS is already locked in Info.plist.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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

class ArmourAndPrayerApp extends ConsumerStatefulWidget {
  const ArmourAndPrayerApp({super.key});

  @override
  ConsumerState<ArmourAndPrayerApp> createState() => _ArmourAndPrayerAppState();
}

class _ArmourAndPrayerAppState extends ConsumerState<ArmourAndPrayerApp> {
  // The midnight timer may not fire while the app is suspended, so re-check
  // the date whenever the app comes back to the foreground.
  late final AppLifecycleListener _lifecycle = AppLifecycleListener(
    onResume: () => ref.read(todayProvider.notifier).refresh(),
  );

  @override
  void initState() {
    super.initState();
    _lifecycle; // Start listening.
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
