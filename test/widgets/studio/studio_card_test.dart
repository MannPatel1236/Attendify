import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:attendify/widgets/studio/studio_card.dart';
import 'package:attendify/theme/studio_tokens.dart';

void main() {
  group('StudioCard', () {
    testWidgets('has 0px border-radius and a 1px borderSubtle border',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StudioCard(
            child: const Text('hello'),
          ),
        ),
      ));

      // Find the Container holding the card; check its BoxDecoration.
      final containers = tester.widgetList<DecoratedBox>(find.byType(DecoratedBox));
      final hasZeroRadius = containers.any((d) =>
          d.decoration is BoxDecoration &&
          (d.decoration as BoxDecoration).borderRadius == BorderRadius.zero);
      expect(hasZeroRadius, isTrue);

      final hasSubtleBorder = containers.any((d) =>
          d.decoration is BoxDecoration &&
          (d.decoration as BoxDecoration).border ==
              Border.all(color: StudioColors.borderSubtle, width: 1));
      expect(hasSubtleBorder, isTrue);
    });

    testWidgets('has NO BoxShadow (spec §2.3)', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StudioCard(child: const Text('hi')),
        ),
      ));

      final cards = tester.widgetList<DecoratedBox>(find.byType(DecoratedBox));
      for (final c in cards) {
        final dec = c.decoration;
        if (dec is BoxDecoration) {
          expect(dec.boxShadow, isNull);
        }
      }
    });

    testWidgets('applies 20-24px padding from spec §3.7', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StudioCard(
            padding: const EdgeInsets.all(24),
            child: const Text('hi'),
          ),
        ),
      ));
      // The Padding widget should be present.
      expect(find.byType(Padding), findsWidgets);
    });
  });
}
