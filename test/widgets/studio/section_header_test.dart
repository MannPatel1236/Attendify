import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:attendify/widgets/studio/section_header.dart';
import 'package:attendify/theme/studio_tokens.dart';

void main() {
  group('SectionHeader', () {
    testWidgets('renders the label, optional meta, and a 1px divider',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SectionHeader(
            index: 2,
            label: "TODAY'S CLASSES",
            meta: '4 OF 5 ATTENDED',
          ),
        ),
      ));

      expect(find.text("02 / TODAY'S CLASSES"), findsOneWidget);
      expect(find.text('4 OF 5 ATTENDED'), findsOneWidget);
      // Divider is a 1px tall widget with borderSubtle color.
      // Container.color produces a ColoredBox; check via widget predicate.
      final hasSubtleColor = tester
          .widgetList<ColoredBox>(find.byType(ColoredBox))
          .any((c) => c.color == StudioColors.borderSubtle);
      expect(hasSubtleColor, isTrue);
    });

    testWidgets('label uses JetBrains Mono per spec §2.2', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SectionHeader(index: 1, label: 'TEST'),
        ),
      ));

      final text = tester.widget<Text>(find.text('01 / TEST'));
      expect(text.style?.fontFamily, contains('JetBrains'));
      expect(text.style?.letterSpacing, 2);
    });
  });
}
