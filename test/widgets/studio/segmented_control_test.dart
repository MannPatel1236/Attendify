import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:attendify/widgets/studio/segmented_control.dart';
import 'package:attendify/theme/studio_tokens.dart';

void main() {
  group('SegmentedControl', () {
    testWidgets('renders one segment per option', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SegmentedControl<String>(
            options: const ['Present', 'Absent', 'Cancelled'],
            selected: 'Present',
            onChanged: (_) {},
          ),
        ),
      ));

      expect(find.text('Present'), findsOneWidget);
      expect(find.text('Absent'), findsOneWidget);
      expect(find.text('Cancelled'), findsOneWidget);
    });

    testWidgets('calls onChanged with the new value on tap', (tester) async {
      String? captured;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SegmentedControl<String>(
            options: const ['A', 'B'],
            selected: 'A',
            onChanged: (v) => captured = v,
          ),
        ),
      ));

      await tester.tap(find.text('B'));
      await tester.pump();
      expect(captured, 'B');
    });

    testWidgets('default variant is 36px tall', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SegmentedControl<String>(
            options: const ['A'],
            selected: 'A',
            onChanged: (_) {},
          ),
        ),
      ));

      // Outer container height should be 36.
      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasCorrectHeight =
          containers.any((c) => c.constraints?.minHeight == 36);
      expect(hasCorrectHeight, isTrue);
    });

    testWidgets('compact variant is 32px tall', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SegmentedControl<String>(
            options: const ['A'],
            selected: 'A',
            onChanged: (_) {},
            compact: true,
          ),
        ),
      ));

      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasCorrectHeight =
          containers.any((c) => c.constraints?.minHeight == 32);
      expect(hasCorrectHeight, isTrue);
    });

    testWidgets('active segment uses accentPrimary background', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SegmentedControl<String>(
            options: const ['A', 'B'],
            selected: 'A',
            onChanged: (_) {},
          ),
        ),
      ));

      final hasAccent = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .any((d) =>
              d.decoration is BoxDecoration &&
              (d.decoration as BoxDecoration).color ==
                  StudioColors.accentPrimary);
      expect(hasAccent, isTrue);
    });
  });
}
