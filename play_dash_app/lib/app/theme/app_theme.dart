import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color _bg = Color(0xFF050913);
  static const Color _panelBase = Color(0xFF121C30);
  static const Color _panelRaised = Color(0xFF192743);
  static const Color _primary = Color(0xFF8C80FF);
  static const Color _secondary = Color(0xFF5AD4FF);
  static const Color _accent = Color(0xFFFF8AB8);

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
      surface: isDark ? _bg : Colors.white,
      surfaceContainer: isDark ? _panelBase : const Color(0xFFF2F5FB),
      surfaceContainerHigh: isDark ? _panelRaised : Colors.white,
      surfaceContainerHighest:
          isDark ? const Color(0xFF223250) : const Color(0xFFE7EDF8),
      onSurface: isDark ? const Color(0xFFF6F8FF) : const Color(0xFF0D1524),
      onSurfaceVariant:
          isDark ? const Color(0xFF9BA8C6) : const Color(0xFF55627D),
      outline: isDark ? const Color(0x33FFFFFF) : const Color(0x220D1524),
      outlineVariant: isDark ? const Color(0x1FFFFFFF) : const Color(0x160D1524),
    );

    final base = ThemeData(
      brightness: brightness,
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: isDark ? _bg : const Color(0xFFF7F9FD),
      fontFamily: 'SF Pro Display',
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displayLarge: base.textTheme.displayLarge
            ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1.3),
        displayMedium: base.textTheme.displayMedium
            ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1.0),
        displaySmall: base.textTheme.displaySmall
            ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.9),
        headlineLarge: base.textTheme.headlineLarge
            ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.7),
        headlineMedium: base.textTheme.headlineMedium
            ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.5),
        headlineSmall: base.textTheme.headlineSmall
            ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.3),
        titleLarge: base.textTheme.titleLarge
            ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.2),
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
        fillColor: Colors.white.withValues(alpha: isDark ? 0.06 : 0.94),
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
        overlayColor: scheme.primary.withValues(alpha: 0.10),
        valueIndicatorColor: scheme.primary,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.14)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.06),
          foregroundColor: scheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: Colors.white.withValues(alpha: 0.06),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
        labelStyle:
            TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600),
      ),
      dividerColor: Colors.white.withValues(alpha: 0.08),
    );
  }

  static OutlineInputBorder _inputBorder(ColorScheme scheme,
      {bool focused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(
        color: focused
            ? scheme.primary.withValues(alpha: 0.72)
            : Colors.white.withValues(alpha: 0.12),
        width: focused ? 1.3 : 1,
      ),
    );
  }
}
