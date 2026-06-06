// Studio Linear-Soft ThemeData.
// Wires spec §2 tokens into Material widgets.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'studio_tokens.dart';
import 'studio_typography.dart';

class StudioTheme {
  StudioTheme._();

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: StudioColors.surfaceBase,
      primaryColor: StudioColors.accentPrimary,
      primaryColorDark: StudioColors.accentPrimaryHover,
      colorScheme: const ColorScheme.dark(
        primary: StudioColors.accentPrimary,
        onPrimary: StudioColors.textPrimary,
        secondary: StudioColors.accentPrimary,
        onSecondary: StudioColors.textPrimary,
        surface: StudioColors.surfaceRaised,
        onSurface: StudioColors.textSecondary,
        error: StudioColors.semanticDanger,
        onError: StudioColors.textPrimary,
      ),
      dividerColor: StudioColors.borderSubtle,
      iconTheme: const IconThemeData(
        color: StudioColors.textSecondary,
        size: 20, // spec §2.3 default
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: StudioColors.accentPrimaryDim,

      // AppBar: spec §4 screens do not use a Material AppBar. The theme
      // makes one available for places that need it (e.g. attendance
      // header), styled to the spec.
      appBarTheme: const AppBarTheme(
        backgroundColor: StudioColors.surfaceBase,
        foregroundColor: StudioColors.textSecondary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: StudioColors.textSecondary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Inputs (spec §2.3 / §3.6).
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: StudioColors.surfaceRaised,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: StudioSpacing.s3, vertical: 0),
        hintStyle: const TextStyle(color: StudioColors.textMuted),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(StudioRadii.control),
          borderSide: const BorderSide(color: StudioColors.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(StudioRadii.control),
          borderSide: const BorderSide(color: StudioColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(StudioRadii.control),
          borderSide:
              const BorderSide(color: StudioColors.borderStrong, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(StudioRadii.control),
          borderSide:
              const BorderSide(color: StudioColors.semanticDanger, width: 1),
        ),
      ),

      // Dividers (spec §2.3).
      dividerTheme: const DividerThemeData(
        color: StudioColors.borderSubtle,
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// The system UI overlay style used by `SystemChrome.setSystemUIOverlayStyle`
  /// at app start. Status bar is transparent with light icons.
  static SystemUiOverlayStyle get systemUiOverlay => const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: StudioColors.surfaceBase,
        systemNavigationBarIconBrightness: Brightness.light,
      );
}
