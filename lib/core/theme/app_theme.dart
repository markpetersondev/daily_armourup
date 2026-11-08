import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

/// Light and dark themes for Armour Up Daily.
///
/// Headings use Playfair Display; body text uses Inter. Both themes are
/// designed independently — dark mode is warm charcoal/green, not inverted.
abstract final class AppTheme {
  static const double radiusCard = 24;
  static const double radiusButton = 16;

  static TextTheme _textTheme(Color body, Color heading) {
    final base = GoogleFonts.interTextTheme();
    // Request the weight here, not via copyWith: google_fonts picks the font
    // file at creation time, so copyWith would keep the Regular file.
    final serif =
        GoogleFonts.playfairDisplay(color: heading, fontWeight: FontWeight.w600);
    return base
        .apply(bodyColor: body, displayColor: heading)
        .copyWith(
          displayLarge: serif.copyWith(fontSize: 44, fontWeight: FontWeight.w600, height: 1.15),
          displayMedium: serif.copyWith(fontSize: 36, fontWeight: FontWeight.w600, height: 1.15),
          displaySmall: serif.copyWith(fontSize: 30, fontWeight: FontWeight.w600, height: 1.2),
          headlineLarge: serif.copyWith(fontSize: 28, fontWeight: FontWeight.w600, height: 1.2),
          headlineMedium: serif.copyWith(fontSize: 24, fontWeight: FontWeight.w600, height: 1.25),
          headlineSmall: serif.copyWith(fontSize: 21, fontWeight: FontWeight.w600, height: 1.25),
          titleLarge: GoogleFonts.inter(
              color: heading, fontSize: 18, fontWeight: FontWeight.w600, height: 1.3),
          titleMedium: GoogleFonts.inter(
              color: heading, fontSize: 16, fontWeight: FontWeight.w600, height: 1.35),
          titleSmall: GoogleFonts.inter(
              color: heading, fontSize: 14, fontWeight: FontWeight.w600, height: 1.35),
          bodyLarge: GoogleFonts.inter(color: body, fontSize: 16, height: 1.5),
          bodyMedium: GoogleFonts.inter(color: body, fontSize: 14, height: 1.5),
          bodySmall: GoogleFonts.inter(color: body, fontSize: 12, height: 1.45),
          labelLarge: GoogleFonts.inter(
              color: heading, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.2),
        );
  }

  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.forestGreen,
      onPrimary: AppColors.warmWhite,
      primaryContainer: AppColors.softSage,
      onPrimaryContainer: AppColors.forestGreen,
      secondary: AppColors.warmGold,
      onSecondary: AppColors.deepCharcoal,
      secondaryContainer: AppColors.softGold,
      onSecondaryContainer: Color(0xFF5C4515),
      tertiary: AppColors.deepOlive,
      onTertiary: AppColors.warmWhite,
      error: AppColors.gentleRed,
      onError: AppColors.warmWhite,
      surface: AppColors.cream,
      onSurface: AppColors.deepCharcoal,
      onSurfaceVariant: AppColors.mutedGray,
      outline: Color(0xFFCBCFC6),
      outlineVariant: Color(0xFFE4E7DF),
      surfaceContainerHighest: AppColors.softSage,
      surfaceContainerHigh: Color(0xFFF3EFE4),
      surfaceContainer: AppColors.warmWhite,
      inverseSurface: AppColors.deepCharcoal,
      onInverseSurface: AppColors.cream,
      shadow: Color(0x14254A3D),
      scrim: Colors.black54,
    );
    return _base(scheme, cardColor: AppColors.warmWhite);
  }

  static ThemeData get dark {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.softGreen,
      onPrimary: AppColors.warmWhite,
      primaryContainer: AppColors.forestGreen,
      onPrimaryContainer: AppColors.softSage,
      secondary: AppColors.warmGold,
      onSecondary: AppColors.deepCharcoal,
      secondaryContainer: Color(0xFF4A3B1D),
      onSecondaryContainer: AppColors.softGold,
      tertiary: AppColors.deepOlive,
      onTertiary: AppColors.warmWhite,
      error: Color(0xFFD97D7D),
      onError: AppColors.deepCharcoal,
      surface: AppColors.deepCharcoal,
      onSurface: Color(0xFFEDEBE3),
      onSurfaceVariant: Color(0xFFA9B0A7),
      outline: Color(0xFF49524B),
      outlineVariant: Color(0xFF333B35),
      surfaceContainerHighest: AppColors.darkElevated,
      surfaceContainerHigh: AppColors.darkCard,
      surfaceContainer: AppColors.darkSurface,
      inverseSurface: AppColors.cream,
      onInverseSurface: AppColors.deepCharcoal,
      shadow: Color(0x33000000),
      scrim: Colors.black54,
    );
    return _base(scheme, cardColor: AppColors.darkCard);
  }

  static ThemeData _base(ColorScheme scheme, {required Color cardColor}) {
    final isDark = scheme.brightness == Brightness.dark;
    final textTheme = _textTheme(
      isDark ? const Color(0xFFD7D9CF) : const Color(0xFF3A403B),
      scheme.onSurface,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusCard)),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(64, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusButton)),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(64, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusButton)),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(48, 44),
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainer,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(color: scheme.outlineVariant),
        backgroundColor: scheme.surfaceContainer,
        selectedColor: scheme.primaryContainer,
        labelStyle: textTheme.bodyMedium,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? scheme.onPrimary : scheme.outline),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? scheme.primary : scheme.surfaceContainerHigh),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: scheme.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
