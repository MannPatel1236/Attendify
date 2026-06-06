import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:attendify/widgets/studio/subject_progress_bar.dart';
import 'package:attendify/theme/studio_tokens.dart';

void main() {
  group('SubjectProgressBar', () {
    testWidgets('renders a 2px-tall bar', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            child: SubjectProgressBar(percent: 50, animate: false),
          ),
        ),
      ));

      // Find the outer SizedBox that holds the bar.
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      // Outer SizedBox is height 2.
      final hasOuter = sizedBoxes.any((s) => s.height == 2.0);
      expect(hasOuter, isTrue);
    });

    testWidgets('uses semanticSafe color when percent >= 80', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            child: SubjectProgressBar(percent: 85, animate: false),
          ),
        ),
      ));

      final hasSafe = tester
          .widgetList<ColoredBox>(find.byType(ColoredBox))
          .any((c) => c.color == StudioColors.semanticSafe);
      expect(hasSafe, isTrue);
    });

    testWidgets('uses semanticWarning color when 75 <= percent < 80',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            child: SubjectProgressBar(percent: 77, animate: false),
          ),
        ),
      ));

      final hasWarn = tester
          .widgetList<ColoredBox>(find.byType(ColoredBox))
          .any((c) => c.color == StudioColors.semanticWarning);
      expect(hasWarn, isTrue);
    });

    testWidgets('uses semanticDanger color when percent < 75', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            child: SubjectProgressBar(percent: 60, animate: false),
          ),
        ),
      ));

      final hasDanger = tester
          .widgetList<ColoredBox>(find.byType(ColoredBox))
          .any((c) => c.color == StudioColors.semanticDanger);
      expect(hasDanger, isTrue);
    });
  });
}
