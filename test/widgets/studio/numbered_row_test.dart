import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:attendify/widgets/studio/numbered_row.dart';
import 'package:attendify/theme/studio_tokens.dart';

void main() {
  group('NumberedRow', () {
    testWidgets('renders the number, primary text, and chevron', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: NumberedRow(
            index: 1,
            primary: 'Algorithm',
            secondary: '10:00 AM · LH-2',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
      ));

      expect(find.text('01'), findsOneWidget);
      expect(find.text('Algorithm'), findsOneWidget);
      expect(find.text('10:00 AM · LH-2'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('has zero border-radius (sharp corners)', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: NumberedRow(
            index: 1,
            primary: 'A',
            onTap: () {},
          ),
        ),
      ));

      final hasZeroRadius = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .any((d) =>
              d.decoration is BoxDecoration &&
              (d.decoration as BoxDecoration).borderRadius ==
                  BorderRadius.zero);
      expect(hasZeroRadius, isTrue);
    });

    testWidgets('selected state uses accentPrimaryDim background',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: NumberedRow(
            index: 1,
            primary: 'A',
            selected: true,
            onTap: () {},
          ),
        ),
      ));

      final hasAccentDim = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .any((d) =>
              d.decoration is BoxDecoration &&
              (d.decoration as BoxDecoration).color ==
                  StudioColors.accentPrimaryDim);
      expect(hasAccentDim, isTrue);
    });

    testWidgets('has NO BoxShadow in its decorations (spec §2.3)',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: NumberedRow(
            index: 1,
            primary: 'A',
            onTap: () {},
          ),
        ),
      ));

      final containers = tester.widgetList<DecoratedBox>(find.byType(DecoratedBox));
      for (final c in containers) {
        final dec = c.decoration;
        if (dec is BoxDecoration) {
          expect(dec.boxShadow, isNull);
        }
      }
    });
  });
}
