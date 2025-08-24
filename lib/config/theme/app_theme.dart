import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme Colors
  static const _lightColorScheme = ColorScheme.light(
    primary: Color(0xFF6C63FF), // Primary purple
    secondary: Color(0xFF4CAF50), // Green for clean indicators
    tertiary: Color(0xFFFF7043), // Orange for warnings
    surface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Color(0xFF1A1A1A),
    error: Color(0xFFE53935),
  );

  // Dark Theme Colors
  static const _darkColorScheme = ColorScheme.dark(
    primary: Color(0xFF7C4DFF), // Lighter purple for dark theme
    secondary: Color(0xFF66BB6A), // Lighter green for dark theme
    tertiary: Color(0xFFFF8A65), // Lighter orange for dark theme
    surface: Color(0xFF1E1E1E),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    error: Color(0xFFEF5350),
  );

  // Text Themes
  static final TextTheme _textTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
    bodyLarge: GoogleFonts.roboto(fontSize: 16),
    bodyMedium: GoogleFonts.roboto(fontSize: 14),
    bodySmall: GoogleFonts.roboto(fontSize: 12),
    labelLarge: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
    labelMedium: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
    labelSmall: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w500),
  );

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme,
    textTheme: _textTheme,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: _lightColorScheme.surface,
      titleTextStyle: _textTheme.titleLarge?.copyWith(
        color: _lightColorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: _lightColorScheme.onSurface.withValues(alpha: 0.2),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: _lightColorScheme.onSurface.withValues(alpha: 0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _lightColorScheme.primary, width: 2),
      ),
      filled: true,
      fillColor: _lightColorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightColorScheme.primary,
        foregroundColor: _lightColorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: _textTheme.labelLarge?.copyWith(
          color: _lightColorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _darkColorScheme,
    textTheme: _textTheme,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: _darkColorScheme.surface,
      titleTextStyle: _textTheme.titleLarge?.copyWith(
        color: _darkColorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: _darkColorScheme.surface,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: _darkColorScheme.onSurface.withValues(alpha: 0.2),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: _darkColorScheme.onSurface.withValues(alpha: 0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _darkColorScheme.primary, width: 2),
      ),
      filled: true,
      fillColor: _darkColorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: TextStyle(
        color: _darkColorScheme.onSurface.withValues(alpha: 0.6),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkColorScheme.primary,
        foregroundColor: _darkColorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: _textTheme.labelLarge?.copyWith(
          color: _darkColorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
