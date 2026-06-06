// Studio Linear-Soft typography.
// All roles are from spec §2.2. Inter handles body; JetBrains Mono handles data.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudioTypography {
  StudioTypography._();

  // Inter (loaded via google_fonts; spec §2.2).
  static TextStyle editorialHeadline() => GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.5,
        height: 1.05,
        color: const Color(0xFFFFFFFF),
      );

  static TextStyle pageTitle() => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: const Color(0xFFE4E7EB),
      );

  static TextStyle body() => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFE4E7EB),
      );

  static TextStyle bodyEmphasis() => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color(0xFFE4E7EB),
      );

  static TextStyle strongBody() => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFE4E7EB),
      );

  static TextStyle caption() => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF8A94A6),
      );

  static TextStyle button() => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFFFFFFF),
      );

  // JetBrains Mono (spec §2.2). Tabular-nums enabled globally.
  static TextStyle sectionLabel() => GoogleFonts.jetBrainsMono(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
        color: const Color(0xFF8A94A6),
      ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

  static TextStyle monoSmall() => GoogleFonts.jetBrainsMono(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF8A94A6),
      ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

  static TextStyle monoCaption() => GoogleFonts.jetBrainsMono(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF6B7280),
      ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

  static TextStyle heroNumber() => GoogleFonts.jetBrainsMono(
        fontSize: 64,
        fontWeight: FontWeight.w600,
        letterSpacing: -2,
        color: const Color(0xFFFFFFFF),
      ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}
