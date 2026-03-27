import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color _bgBottom = Color(0xFF040812);
  static const Color _panelBase = Color(0xFF11192B);
  static const Color _panelRaised = Color(0xFF17223A);
  static const Color _primary = Color(0xFF8C7BFF);
  static const Color _secondary = Color(0xFF52D1FF);
  static const Color _accent = Color(0xFFFF8BB7);

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: _primary,
    ).copyWith(
      primary: _primary,
      secondary: _secondary,
      tertiary: _accent,
      surface: isDark ? _bgBottom : Colors.white,
      surfaceContainer: isDark ? _panelBase : const Color(0xFFF3F6FB),
      surfaceContainerHigh: isDark ? _panelRaised : Colors.white,
      surfaceContainerHighest:
          isDark ? const Color(0xFF1E2942) : const Color(0xFFE8EEF8),
      onSurface: isDark ? const Color(0xFFF4F7FF) : const Color(0xFF0E1525),
      onSurfaceVariant:
          isDark ? const Color(0xFFA9B6D3) : const Color(0xFF56637D),
      outline: isDark ? const Color(0x33FFFFFF) : const Color(0x220E1525),
      outlineVariant:
          isDark ? const Color(0x22FFFFFF) : const Color(0x160E1525),
    );

    final base = ThemeData(
      brightness: brightness,
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: isDark ? _bgBottom : const Color(0xFFF7F9FD),
      fontFamily: 'SF Pro Display',
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displayLarge: base.textTheme.displayLarge
            ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1.2),
        displayMedium: base.textTheme.displayMedium
            ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.9),
        headlineLarge: base.textTheme.headlineLarge
            ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.7),
        headlineMedium: base.textTheme.headlineMedium
            ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.6),
        titleLarge: base.textTheme.titleLarge
            ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.3),
        titleMedium:
            base.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.45),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(height: 1.45),
        labelLarge:
            base.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: isDark ? 0.08 : 0.9),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        prefixIconColor: scheme.onSurfaceVariant,
        border: _inputBorder(scheme),
        enabledBorder: _inputBorder(scheme),
        focusedBorder: _inputBorder(scheme, focused: true),
      ),
      sliderTheme: base.sliderTheme.copyWith(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.10),
        thumbColor: Colors.white,
        overlayColor: scheme.primary.withValues(alpha: 0.12),
        valueIndicatorColor: scheme.primary,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 54),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.14)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: Colors.white.withValues(alpha: 0.07),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
        labelStyle:
            TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(ColorScheme scheme,
      {bool focused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(
        color: focused
            ? scheme.primary.withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.12),
        width: focused ? 1.4 : 1,
      ),
    );
  }
}
