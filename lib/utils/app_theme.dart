import 'package:flutter/material.dart';

class AppColors {
  // Core palette
  static const Color background    = Color(0xFF0A0E1A);
  static const Color surface       = Color(0xFF131929);
  static const Color cardDark      = Color(0xFF1A2235);
  static const Color cardBorder    = Color(0xFF243050);

  // Brand accents
  static const Color gold          = Color(0xFFFFD700);
  static const Color goldLight     = Color(0xFFFFE566);
  static const Color green         = Color(0xFF00C853);
  static const Color greenDark     = Color(0xFF00952F);
  static const Color neonGreen     = Color(0xFF39FF14); // Added neon green

  // Stitch UI Colors
  static const Color stitchBackground = Color(0xFF131313);
  static const Color stitchSurface = Color(0xFF131313);
  static const Color stitchSurfaceVariant = Color(0xFF353534);
  static const Color stitchSurfaceContainerLow = Color(0xFF1C1B1B);
  static const Color stitchSurfaceContainer = Color(0xFF201F1F);
  static const Color stitchSurfaceContainerHigh = Color(0xFF2A2A2A);
  static const Color stitchSurfaceContainerHighest = Color(0xFF353534);
  static const Color stitchOnSurface = Color(0xFFE5E2E1);
  static const Color stitchOnSurfaceVariant = Color(0xFFBACCB0);
  static const Color stitchPrimary = Color(0xFFEFFFE3);
  static const Color stitchPrimaryContainer = Color(0xFF39FF14);
  static const Color stitchOnPrimaryContainer = Color(0xFF107100);
  static const Color stitchError = Color(0xFFFFB4AB);
  static const Color stitchErrorContainer = Color(0xFF93000A);
  static const Color stitchOutlineVariant = Color(0xFF3C4B35);

  // Social
  static const Color google        = Color(0xFFDB4437);
  static const Color facebook      = Color(0xFF1877F2);
  static const Color twitter       = Color(0xFF1DA1F2);

  // Text
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color textHint      = Color(0xFF546E7A);

  // Gradient stops
  static const List<Color> goldGradient = [Color(0xFFFFD700), Color(0xFFFF8C00)];
  static const List<Color> bgGradient   = [Color(0xFF0A0E1A), Color(0xFF131929), Color(0xFF0D1520)];
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Poppins',
      colorScheme: ColorScheme.dark(
        primary: AppColors.gold,
        secondary: AppColors.green,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
      ),
    );
  }
}
