import 'package:flutter/material.dart';

/// Brand palette for Armour Up Daily.
abstract final class AppColors {
  static const deepCharcoal = Color(0xFF151816);
  static const forestGreen = Color(0xFF254A3D);
  static const deepOlive = Color(0xFF3F5F45);
  static const warmGold = Color(0xFFD7A957);
  static const softGold = Color(0xFFF4D68A);
  static const cream = Color(0xFFFBF8F1);
  static const warmWhite = Color(0xFFFFFDF8);
  static const softSage = Color(0xFFDDE8D8);
  /// Secondary text. Dark enough for WCAG AA (5.3:1) on cream.
  static const mutedGray = Color(0xFF626A62);
  static const gentleRed = Color(0xFFB94B4B);
  static const softGreen = Color(0xFF4E8C62);

  /// Gold for text on light surfaces. [warmGold] is only 2:1 on cream, so
  /// text uses this deeper gold (5.1:1) in light mode.
  static const deepGold = Color(0xFF87641F);

  /// The readable gold for text in the current theme. On dark surfaces
  /// (dark mode and the green hero cards) [warmGold] already reads well.
  static Color goldText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light ? deepGold : warmGold;

  // Dark-mode surfaces (designed, not inverted).
  static const darkSurface = Color(0xFF1C211E);
  static const darkCard = Color(0xFF232A26);
  static const darkElevated = Color(0xFF2B342F);
}
