import 'package:flutter/material.dart';

/// Centralizes the visual identity of the app so that every screen can
/// tap into consistent colors, gradients, and typography.
class AppTheme {
  AppTheme._();

  static const Color seedColor = Color(0xFFF97316);
  static const Color secondaryColor = Color(0xFF4F46E5);
  static const Color accentColor = Color(0xFFEC4899);
  static const Color appBarStart = Color(0xFFEA580C);
  static const Color appBarEnd = Color(0xFFDB2777);

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFFFF7ED), Color(0xFFFFFBF0), Color(0xFFF1F5F9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient appBarGradient = LinearGradient(
    colors: [appBarStart, appBarEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData lightTheme = () {
    final baseColorScheme = ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.light);
    return ThemeData(
      useMaterial3: true,
      colorScheme: baseColorScheme.copyWith(secondary: secondaryColor, tertiary: accentColor, surfaceTint: seedColor),
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
        bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: Color(0xFF1F2937)),
        bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF4B5563)),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      cardTheme: CardThemeData(
        elevation: 8,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white.withValues(alpha: 0.92),
        shadowColor: Colors.black12,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          backgroundColor: seedColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: secondaryColor.withValues(alpha: 0.12),
        selectedColor: seedColor,
        labelStyle: const TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }();
}
