// Studio Linear-Soft design tokens.
// All values are from docs/superpowers/specs/2026-06-06-attendify-design-direction.md
// Do not add a value that is not in the spec.

import 'package:flutter/material.dart';

class StudioColors {
  StudioColors._();

  // Surfaces (spec §2.1)
  static const Color surfaceBase = Color(0xFF0B0F1A);
  static const Color surfaceRaised = Color(0xFF0F1320);
  static const Color surfaceOverlay = Color(0xFF161B2A);

  // Borders (spec §2.1)
  static const Color borderSubtle = Color(0xFF1E2330);
  static const Color borderStrong = Color(0xFF2A3142);

  // Text (spec §2.1)
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFE4E7EB);
  static const Color textTertiary = Color(0xFF8A94A6);
  static const Color textMuted = Color(0xFF6B7280);

  // Accent (spec §2.1)
  static const Color accentPrimary = Color(0xFF5E6AD2);
  static const Color accentPrimaryHover = Color(0xFF7180E0);
  static const Color accentPrimaryDim = Color(0x1F5E6AD2); // rgba(94,106,210,0.12)

  // Semantic (spec §2.1)
  static const Color semanticSafe = Color(0xFF10B981);
  static const Color semanticWarning = Color(0xFFF59E0B);
  static const Color semanticDanger = Color(0xFFEF4444);
}

class StudioRadii {
  StudioRadii._();

  // Spec §2.3: 0 for cards, 8 for buttons/inputs.
  static const double card = 0;
  static const double control = 8;
  static const double controlInner = 6; // segmented control inner segments
  static const double controlInnerCompact = 4; // compact variant
}

class StudioMotion {
  StudioMotion._();

  // Spec §2.4: default duration + named exceptions.
  static const Duration defaultDuration = Duration(milliseconds: 180);
  static const Duration pageTransition = Duration(milliseconds: 240);
  static const Duration gaugeFill = Duration(milliseconds: 320);
  static const Duration progressFill = Duration(milliseconds: 320);

  // Spec §2.4: Material standard easing.
  static const Curve easing = Curves.easeInOutCubic;
}

class StudioSpacing {
  StudioSpacing._();

  // Spec §2.6: 4px scale.
  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s5 = 20;
  static const double s6 = 24;
  static const double s7 = 32;
  static const double s8 = 40;
  static const double s9 = 48;
  static const double s10 = 56;
  static const double s11 = 64;
}
