import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF1A237E);
  static const Color slateDark = Color(0xFF0F172A);
  static const Color vibrantCyan = Color(0xFF06B6D4);
  static const Color accentPeach = Color(0xFFFF6B6B);
  static const Color accent = Color(0xFFe8a34c);

  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFF0F172A);
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E293B);

  static const Color textPrimaryLight = Color(0xFF1F2937);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color dividerDark = Color(0xFF334155);
}

class AppTheme {
  static bool _useFraunces(Locale locale) =>
      locale.languageCode != 'am';

  static ThemeData lightTheme(Locale locale) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        brightness: Brightness.light,
        primary: AppColors.primaryBlue,
        secondary: AppColors.vibrantCyan,
        error: AppColors.error,
        surface: AppColors.surfaceLight,
      ),
      scaffoldBackgroundColor: AppColors.surfaceLight,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimaryLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.cardLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        shadowColor: Colors.black.withValues(alpha: 0.08),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardLight,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.textSecondaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      textTheme: TextTheme(
        displayLarge: _useFraunces(locale)
            ? GoogleFonts.fraunces(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
                letterSpacing: -0.5,
              )
            : const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
                letterSpacing: -0.5,
              ),
        displayMedium: _useFraunces(locale)
            ? GoogleFonts.fraunces(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
                height: 1.3,
              )
            : const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
                height: 1.3,
              ),
        headlineLarge: _useFraunces(locale)
            ? GoogleFonts.fraunces(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimaryLight,
              )
            : const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimaryLight,
              ),
        headlineMedium: _useFraunces(locale)
            ? GoogleFonts.fraunces(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimaryLight,
              )
            : const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimaryLight,
              ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryLight,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimaryLight,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: AppColors.textPrimaryLight,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textSecondaryLight,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondaryLight),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerLight,
        thickness: 1,
      ),
    );
  }

  static ThemeData darkTheme(Locale locale) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.vibrantCyan,
        brightness: Brightness.dark,
        primary: AppColors.vibrantCyan,
        secondary: AppColors.primaryBlue,
        error: AppColors.error,
        surface: AppColors.surfaceDark,
      ),
      scaffoldBackgroundColor: AppColors.surfaceDark,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardDark,
        selectedItemColor: AppColors.vibrantCyan,
        unselectedItemColor: AppColors.textSecondaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      textTheme: TextTheme(
        displayLarge: _useFraunces(locale)
            ? GoogleFonts.fraunces(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryDark,
                letterSpacing: -0.5,
              )
            : const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryDark,
                letterSpacing: -0.5,
              ),
        displayMedium: _useFraunces(locale)
            ? GoogleFonts.fraunces(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryDark,
                height: 1.3,
              )
            : const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryDark,
                height: 1.3,
              ),
        headlineLarge: _useFraunces(locale)
            ? GoogleFonts.fraunces(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimaryDark,
              )
            : const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimaryDark,
              ),
        headlineMedium: _useFraunces(locale)
            ? GoogleFonts.fraunces(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimaryDark,
              )
            : const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimaryDark,
              ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimaryDark,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: AppColors.textPrimaryDark,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textSecondaryDark,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.vibrantCyan,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondaryDark),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
      ),
    );
  }
}
