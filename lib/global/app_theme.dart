import 'package:flutter/material.dart';

/// Centralizes the visual identity of the app so that every screen can
/// tap into consistent colors, gradients, and typography.
class AppTheme {
  AppTheme._();

  static const Color seedColor = Color(0xFFB65C45);
  static const Color secondaryColor = Color(0xFF6B4F3A);
  static const Color accentColor = Color(0xFFD39A5C);
  static const Color appBarStart = Color(0xFF251914);
  static const Color appBarEnd = Color(0xFF6A392B);
  static const Color parchment = Color(0xFFFFF9F2);
  static const Color surface = Color(0xFFFFFCF8);
  static const Color surfaceMuted = Color(0xFFF4E9DB);
  static const Color ink = Color(0xFF2B211C);
  static const Color mutedInk = Color(0xFF75685E);
  static const Color line = Color(0xFFE7D9CA);
  static const Color herb = Color(0xFF61715A);
  static const Color danger = Color(0xFFB54D42);

  static const double radiusSmall = 12;
  static const double radiusMedium = 18;
  static const double radiusLarge = 28;
  static const double contentInset = 20;

  static const List<BoxShadow> softShadow = [
    BoxShadow(color: Color(0x140F0A06), blurRadius: 22, offset: Offset(0, 12)),
  ];

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFFFF9F2), Color(0xFFFFF4E8), Color(0xFFEFE2D3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient appBarGradient = LinearGradient(
    colors: [appBarStart, appBarEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData lightTheme = () {
    final baseColorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: baseColorScheme.copyWith(
        secondary: secondaryColor,
        tertiary: accentColor,
        surfaceTint: seedColor,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: ink),
        bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: mutedInk),
        bodySmall: TextStyle(fontSize: 12, height: 1.4, color: mutedInk),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        labelMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: mutedInk,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF64748B),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        color: surface,
        shadowColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          backgroundColor: seedColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 46),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          disabledBackgroundColor: const Color(0xFFE5E7EB),
          disabledForegroundColor: const Color(0xFF9CA3AF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          minimumSize: const Size(0, 46),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          side: const BorderSide(color: line),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: seedColor,
          minimumSize: const Size(0, 42),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: const TextStyle(color: mutedInk),
        floatingLabelStyle: const TextStyle(
          color: seedColor,
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: seedColor, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: danger, width: 1.4),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF111827),
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: DividerThemeData(color: line, thickness: 1, space: 1),
      chipTheme: ChipThemeData(
        backgroundColor: secondaryColor.withValues(alpha: 0.12),
        selectedColor: seedColor,
        labelStyle: const TextStyle(color: ink, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }();
}
