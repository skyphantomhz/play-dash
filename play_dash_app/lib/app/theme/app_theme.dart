import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color _bg = Color(0xFF060816);
  static const Color _cyan = Color(0xFF37D8FF);
  static const Color _blue = Color(0xFF4DA3FF);
  static const Color _purple = Color(0xFF8B5CF6);
  static const Color _pink = Color(0xFFFF4FD8);

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: _cyan,
    ).copyWith(
      primary: _cyan,
      secondary: _blue,
      tertiary: _pink,
      surface: _bg,
      onSurface: Colors.white,
      onSurfaceVariant: Colors.white70,
      outline: const Color(0x33FFFFFF),
      outlineVariant: const Color(0x1FFFFFFF),
    );

    final base = ThemeData(
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: _bg,
      useMaterial3: true,
      fontFamily: 'Inter',
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white).copyWith(
            headlineLarge: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800, letterSpacing: -1.2),
            headlineMedium: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -0.8),
            titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.45),
            bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.4),
            labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: Color(0xB3FFFFFF), fontSize: 14),
        labelStyle: const TextStyle(color: Color(0xB3FFFFFF), fontSize: 13),
        border: _inputBorder(),
        enabledBorder: _inputBorder(),
        focusedBorder: _inputBorder(focused: true),
        prefixIconColor: Colors.white70,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, foregroundColor: Colors.white, elevation: 0),
      sliderTheme: base.sliderTheme.copyWith(
        activeTrackColor: _cyan,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.12),
        thumbColor: Colors.white,
        overlayColor: _cyan.withValues(alpha: 0.18),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: Colors.white.withValues(alpha: 0.05),
        side: const BorderSide(color: Color(0x22FFFFFF)),
        selectedColor: _cyan.withValues(alpha: 0.20),
        labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      dividerColor: Colors.white.withValues(alpha: 0.08),
      splashColor: _cyan.withValues(alpha: 0.08),
      highlightColor: _purple.withValues(alpha: 0.08),
    );
  }

  static OutlineInputBorder _inputBorder({bool focused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: focused ? _cyan.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.10),
        width: focused ? 1.4 : 1,
      ),
    );
  }
}
