import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF004ac6),
      primary: const Color(0xFF004ac6),
      primaryContainer: const Color(0xFF2563eb),
      surface: const Color(0xFFf8f9fa),
      onSurface: const Color(0xFF191c1d),
      onSurfaceVariant: const Color(0xFF434655),
      outline: const Color(0xFF737686),
      outlineVariant: const Color(0xFFc3c6d7),
    ),
    fontFamily: 'Inter',
    scaffoldBackgroundColor: const Color(0xFFf8f9fa),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2563eb),
        foregroundColor: const Color(0xFFeeefff),
        minimumSize: const Size(0, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFf8f9fa),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFc3c6d7)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFc3c6d7)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF004ac6), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFba1a1a)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFba1a1a), width: 2),
      ),
      hintStyle: const TextStyle(
        color: Color(0xFFc3c6d7),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFFffffff),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}
