import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ═══════════════════════════════════════════════════════════════════════════
///  SOFTCLAW — Neo-Claymorphism design system for Attendify.
///
///  Aesthetic direction: premium educational tech. Calm cyan + health green
///  on a near-white "paper" surface, with tactile 3D clay surfaces that feel
///  hand-pressed. The opposite of "AI slop" — every shadow is intentional,
///  every corner is a deliberate radius, every motion has a purpose.
///
///  Typography:
///    • Display  → Baloo 2 (rounded, friendly, modern, premium)
///    • Body     → Inter   (precise, legible, neutral)
/// ═══════════════════════════════════════════════════════════════════════════

class SoftClawPalette {
  SoftClawPalette._();

  // ── Core brand ────────────────────────────────────────────────────────────
  static const Color cyan900 = Color(0xFF0E4F5C);
  static const Color cyan700 = Color(0xFF0891B2);
  static const Color cyan500 = Color(0xFF22D3EE);
  static const Color cyan300 = Color(0xFF67E8F9);
  static const Color cyan100 = Color(0xFFCFFAFE);
  static const Color cyan050 = Color(0xFFECFEFF);

  // ── Health / status ───────────────────────────────────────────────────────
  static const Color green700 = Color(0xFF047857);
  static const Color green500 = Color(0xFF10B981);
  static const Color green300 = Color(0xFF6EE7B7);
  static const Color green050 = Color(0xFFD1FAE5);

  // ── Warning / danger ──────────────────────────────────────────────────────
  static const Color amber500 = Color(0xFFF59E0B);
  static const Color red500   = Color(0xFFEF4444);
  static const Color red100   = Color(0xFFFEE2E2);

  // ── Paper / surfaces ──────────────────────────────────────────────────────
  static const Color paper    = Color(0xFFF5FBFC);  // page background
  static const Color card     = Color(0xFFFFFFFF);  // raised clay
  static const Color cardSoft = Color(0xFFFAFCFD);  // subtle raise
  static const Color clayEdge = Color(0xFFE2F3F7);  // clay surface edge

  // ── Ink ───────────────────────────────────────────────────────────────────
  static const Color ink900   = Color(0xFF0B2A33);
  static const Color ink700   = Color(0xFF164E63);
  static const Color ink500   = Color(0xFF3F7C8C);
  static const Color ink300   = Color(0xFF8AA5AE);
  static const Color ink100   = Color(0xFFCBD8DC);

  // ── DARK MODE equivalents ─────────────────────────────────────────────────
  static const Color paperDark    = Color(0xFF071318);
  static const Color cardDark     = Color(0xFF0E1F25);
  static const Color cardDarkSoft = Color(0xFF142A32);
  static const Color clayEdgeDark = Color(0xFF1B3741);
  static const Color inkDark900   = Color(0xFFECFEFF);
  static const Color inkDark700   = Color(0xFFB8D8DF);
  static const Color inkDark500   = Color(0xFF7AA5AE);
  static const Color inkDark300   = Color(0xFF45646C);
}

class SoftClawShadows {
  SoftClawShadows._();

  // The signature of claymorphism: paired inner highlight + outer drop
  // that together create the illusion of a soft, hand-pressed form.
  static const List<BoxShadow> clayRaised = [
    // Top-left highlight (the "lit" edge of the clay)
    BoxShadow(
      color: Color(0x80FFFFFF),
      offset: Offset(-4, -4),
      blurRadius: 12,
    ),
    // Bottom-right shadow (the "drop" edge of the clay)
    BoxShadow(
      color: Color(0x1A0E4F5C),
      offset: Offset(6, 6),
      blurRadius: 16,
    ),
  ];

  // Tighter, for buttons and small chips
  static const List<BoxShadow> clayPressed = [
    BoxShadow(
      color: Color(0x66FFFFFF),
      offset: Offset(-2, -2),
      blurRadius: 6,
    ),
    BoxShadow(
      color: Color(0x14164455),
      offset: Offset(3, 3),
      blurRadius: 8,
    ),
  ];

  // Pressed-in (concave) for input fields
  static const List<BoxShadow> clayInset = [
    BoxShadow(
      color: Color(0x330E4F5C),
      offset: Offset(3, 3),
      blurRadius: 6,
    ),
    BoxShadow(
      color: Color(0x99FFFFFF),
      offset: Offset(-2, -2),
      blurRadius: 4,
    ),
  ];

  // Glow used for the primary CTA
  static List<BoxShadow> cyanGlow = [
    BoxShadow(
      color: SoftClawPalette.cyan500.withOpacity(0.45),
      blurRadius: 28,
      spreadRadius: -4,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> greenGlow = [
    BoxShadow(
      color: SoftClawPalette.green500.withOpacity(0.40),
      blurRadius: 28,
      spreadRadius: -4,
      offset: const Offset(0, 12),
    ),
  ];
}

class SoftClawMotion {
  SoftClawMotion._();
  static const Duration fast    = Duration(milliseconds: 180);
  static const Duration medium  = Duration(milliseconds: 280);
  static const Duration slow    = Duration(milliseconds: 480);
  static const Duration spring  = Duration(milliseconds: 520);
  static const Curve   easeOut  = Cubic(0.16, 1, 0.3, 1);
  static const Curve   springC  = Cubic(0.34, 1.56, 0.64, 1);
}

class SoftClawRadii {
  SoftClawRadii._();
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 18;
  static const double lg = 24;
  static const double xl = 32;
  static const double pill = 999;
}

class SoftClawTypography {
  SoftClawTypography._();

  static TextTheme buildTextTheme(Color ink) {
    final display = GoogleFonts.baloo2TextTheme();
    final body    = GoogleFonts.interTextTheme();
    return TextTheme(
      // Display: Baloo 2 — rounded, friendly, premium
      displayLarge: display.displayLarge?.copyWith(
        fontWeight: FontWeight.w800, color: ink, letterSpacing: -1.0, height: 1.0,
      ),
      displayMedium: display.displayMedium?.copyWith(
        fontWeight: FontWeight.w800, color: ink, letterSpacing: -0.8, height: 1.05,
      ),
      displaySmall: display.displaySmall?.copyWith(
        fontWeight: FontWeight.w700, color: ink, letterSpacing: -0.5, height: 1.1,
      ),
      headlineLarge: display.headlineLarge?.copyWith(
        fontWeight: FontWeight.w700, color: ink, letterSpacing: -0.5,
      ),
      headlineMedium: display.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700, color: ink, letterSpacing: -0.3,
      ),
      headlineSmall: display.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700, color: ink,
      ),
      titleLarge: display.titleLarge?.copyWith(
        fontWeight: FontWeight.w700, color: ink,
      ),
      titleMedium: display.titleMedium?.copyWith(
        fontWeight: FontWeight.w700, color: ink, fontSize: 16,
      ),
      titleSmall: display.titleSmall?.copyWith(
        fontWeight: FontWeight.w600, color: ink, fontSize: 13,
      ),
      // Body: Inter
      bodyLarge: body.bodyLarge?.copyWith(color: ink, height: 1.5),
      bodyMedium: body.bodyMedium?.copyWith(color: ink, height: 1.45),
      bodySmall: body.bodySmall?.copyWith(color: ink.withOpacity(0.78), height: 1.4),
      labelLarge: body.labelLarge?.copyWith(
        fontWeight: FontWeight.w600, color: ink, letterSpacing: 0.1,
      ),
      labelMedium: body.labelMedium?.copyWith(
        fontWeight: FontWeight.w600, color: ink, letterSpacing: 0.3,
      ),
      labelSmall: body.labelSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: ink.withOpacity(0.6),
        letterSpacing: 1.4,
        fontSize: 10,
      ),
    );
  }
}

class SoftClawTheme {
  SoftClawTheme._();

  static ThemeData light() {
    final palette = SoftClawPalette.paper;
    final textTheme = SoftClawTypography.buildTextTheme(SoftClawPalette.ink900);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: palette,
      colorScheme: const ColorScheme.light(
        primary: SoftClawPalette.cyan700,
        onPrimary: Colors.white,
        secondary: SoftClawPalette.green500,
        onSecondary: Colors.white,
        tertiary: SoftClawPalette.cyan500,
        surface: SoftClawPalette.card,
        onSurface: SoftClawPalette.ink900,
        error: SoftClawPalette.red500,
        onError: Colors.white,
        outline: SoftClawPalette.ink300,
      ),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      splashColor: SoftClawPalette.cyan500.withOpacity(0.12),
      highlightColor: SoftClawPalette.cyan500.withOpacity(0.08),
      appBarTheme: AppBarTheme(
        backgroundColor: SoftClawPalette.paper,
        foregroundColor: SoftClawPalette.ink900,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.baloo2(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: SoftClawPalette.ink900,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: SoftClawPalette.ink700),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: SoftClawPalette.cyan700,
        unselectedLabelColor: SoftClawPalette.ink500,
        indicator: BoxDecoration(
          color: SoftClawPalette.cyan500.withOpacity(0.18),
          borderRadius: BorderRadius.circular(SoftClawRadii.pill),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.baloo2(
          fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: -0.2,
        ),
        unselectedLabelStyle: GoogleFonts.baloo2(
          fontWeight: FontWeight.w500, fontSize: 14, letterSpacing: -0.2,
        ),
        dividerColor: Colors.transparent,
      ),
      dividerTheme: const DividerThemeData(
        color: SoftClawPalette.clayEdge,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: SoftClawPalette.ink700),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: SoftClawPalette.ink900,
        contentTextStyle: GoogleFonts.inter(
          color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SoftClawRadii.md),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final textTheme = SoftClawTypography.buildTextTheme(SoftClawPalette.inkDark900);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: SoftClawPalette.paperDark,
      colorScheme: const ColorScheme.dark(
        primary: SoftClawPalette.cyan500,
        onPrimary: Color(0xFF0B2A33),
        secondary: SoftClawPalette.green300,
        onSecondary: Color(0xFF052E1B),
        tertiary: SoftClawPalette.cyan300,
        surface: SoftClawPalette.cardDark,
        onSurface: SoftClawPalette.inkDark900,
        error: Color(0xFFF87171),
        onError: Color(0xFF330000),
        outline: SoftClawPalette.inkDark300,
      ),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      splashColor: SoftClawPalette.cyan500.withOpacity(0.15),
      highlightColor: SoftClawPalette.cyan500.withOpacity(0.10),
      appBarTheme: AppBarTheme(
        backgroundColor: SoftClawPalette.paperDark,
        foregroundColor: SoftClawPalette.inkDark900,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.baloo2(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: SoftClawPalette.inkDark900,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: SoftClawPalette.inkDark700),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: SoftClawPalette.cyan300,
        unselectedLabelColor: SoftClawPalette.inkDark500,
        indicator: BoxDecoration(
          color: SoftClawPalette.cyan500.withOpacity(0.22),
          borderRadius: BorderRadius.circular(SoftClawRadii.pill),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.baloo2(
          fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: -0.2,
        ),
        unselectedLabelStyle: GoogleFonts.baloo2(
          fontWeight: FontWeight.w500, fontSize: 14, letterSpacing: -0.2,
        ),
        dividerColor: Colors.transparent,
      ),
      dividerTheme: const DividerThemeData(
        color: SoftClawPalette.clayEdgeDark,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: SoftClawPalette.inkDark700),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: SoftClawPalette.cardDarkSoft,
        contentTextStyle: GoogleFonts.inter(
          color: SoftClawPalette.inkDark900, fontWeight: FontWeight.w500, fontSize: 14,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SoftClawRadii.md),
        ),
      ),
    );
  }
}
