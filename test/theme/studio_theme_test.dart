import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:attendify/theme/studio_theme.dart';
import 'package:attendify/theme/studio_tokens.dart';

void main() {
  group('StudioTheme', () {
    test('scaffold background is surfaceBase', () {
      final theme = StudioTheme.dark();
      expect(theme.scaffoldBackgroundColor, StudioColors.surfaceBase);
    });

    test('uses MaterialColor swatch built from surfaceBase', () {
      final theme = StudioTheme.dark();
      expect(theme.primaryColor, StudioColors.accentPrimary);
      expect(theme.colorScheme.primary, StudioColors.accentPrimary);
    });

    test('colorScheme.surface is surfaceRaised (cards)', () {
      final theme = StudioTheme.dark();
      expect(theme.colorScheme.surface, StudioColors.surfaceRaised);
    });

    test('dividerColor is borderSubtle', () {
      final theme = StudioTheme.dark();
      expect(theme.dividerColor, StudioColors.borderSubtle);
    });

    test('icon theme uses textSecondary by default', () {
      final theme = StudioTheme.dark();
      expect(theme.iconTheme.color, StudioColors.textSecondary);
    });

    test('splash and highlight are transparent (no Material ripple)', () {
      final theme = StudioTheme.dark();
      expect(theme.splashColor, Colors.transparent);
      expect(theme.highlightColor, Colors.transparent);
    });

    test('input decoration theme has 8px radius and subtle border', () {
      final theme = StudioTheme.dark();
      final input = theme.inputDecorationTheme;
      final outline = input.border! as OutlineInputBorder;
      expect(outline.borderSide.color, StudioColors.borderSubtle);
      expect(outline.borderRadius,
          BorderRadius.all(Radius.circular(StudioRadii.control)));
    });
  });
}
