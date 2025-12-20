import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF10B981); // Emerald Green
  
  // Sanctuary Dark Palette
  static const Color background = Color(0xFF0D1310); // Sanctuary Off-Black
  static const Color cardDark = Color(0xFF1A1F1D);
  static const Color textPrimaryDark = Color(0xFFF8F9FA); // Soft Paper
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Sanctuary Light Palette
  static const Color backgroundLight = Color(0xFFFDFBF7); // Soft Parchment
  static const Color cardLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF1A1A1A); // Deep Charcoal
  static const Color textSecondaryLight = Color(0xFF64748B);

  // Helper getters for dynamic context
  static Color getBackgroundColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? background : backgroundLight;
      
  static Color getTextPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textPrimaryDark : textPrimaryLight;

  static Color getTextSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textSecondaryDark : textSecondaryLight;
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        background: AppColors.background,
      ),
      textTheme: _textTheme(AppColors.textPrimaryDark, AppColors.textSecondaryDark),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        background: AppColors.backgroundLight,
      ),
      textTheme: _textTheme(AppColors.textPrimaryLight, AppColors.textSecondaryLight),
    );
  }

  static TextTheme _textTheme(Color textColor, Color secondaryColor) {
    return TextTheme(
      displayLarge: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        color: secondaryColor,
      ),
      labelLarge: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }
}
