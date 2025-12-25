import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF10B981); // Sanctuary Emerald
  static const Color accent = Color(0xFFD4AF37);  // Aged Gold

  // Sanctuary Dark Palette
  static const Color background = Color(0xFF202124); // Raisin Black
  static const Color cardDark = Color(0xFF35363A);   // Surface Elevation
  static const Color textPrimaryDark = Color(0xFFF1F3F4); // Anti-Flash White
  static const Color textSecondaryDark = Color(0xFF9AA0A6); // Muted Text

  // Sanctuary Light Palette
  static const Color backgroundLight = Color(0xFFF1F3F4); // Anti-Flash White
  static const Color cardLight = Color(0xFFFFFFFF);       // Pure White
  static const Color textPrimaryLight = Color(0xFF202124); // Raisin Black
  static const Color textSecondaryLight = Color(0xFF5F6368); // Muted Text

  // Helper getters for dynamic context
  static Color getBackgroundColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? background : backgroundLight;
  
  static Color getSurfaceColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? cardDark : cardLight;
      
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
      primaryColor: AppColors.primary,
      cardColor: AppColors.cardDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        surface: AppColors.cardDark,
        background: AppColors.background,
        onSurface: AppColors.textPrimaryDark,
      ),
      textTheme: _textTheme(AppColors.textPrimaryDark, AppColors.textSecondaryDark),
      iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      primaryColor: AppColors.primary,
      cardColor: AppColors.cardLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        surface: AppColors.cardLight,
        background: AppColors.backgroundLight,
        onSurface: AppColors.textPrimaryLight,
      ),
      textTheme: _textTheme(AppColors.textPrimaryLight, AppColors.textSecondaryLight),
      iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
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
      titleLarge: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w600,
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
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
    );
  }
}
