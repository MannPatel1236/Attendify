import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:attendify/widgets/studio/hero_attendance_gauge.dart';

void main() {
  group('HeroAttendanceGauge', () {
    testWidgets('renders the percent in 64px mono', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: HeroAttendanceGauge(percent: 82.5),
        ),
      ));

      // Tween animation runs, let it complete.
      await tester.pumpAndSettle();
      expect(find.text('82.5%'), findsOneWidget);
      final text = tester.widget<Text>(find.text('82.5%'));
      expect(text.style?.fontSize, 64);
      expect(text.style?.fontFamily, contains('JetBrains'));
    });

    testWidgets('renders the caption when provided', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: HeroAttendanceGauge(
            percent: 82.5,
            caption: '4.2% above safe line',
          ),
        ),
      ));

      await tester.pumpAndSettle();
      expect(find.text('4.2% above safe line'), findsOneWidget);
    });

    testWidgets('paints a CustomPaint with no shadow', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: HeroAttendanceGauge(percent: 60),
        ),
      ));

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
      // No PhysicalShape (which would imply shadow) in the gauge subtree.
      expect(find.byType(PhysicalShape), findsNothing);
    });

    testWidgets('clamps percent to [0, 100]', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: HeroAttendanceGauge(percent: 150),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('100.0%'), findsOneWidget);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: HeroAttendanceGauge(percent: -10),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('0.0%'), findsOneWidget);
    });
  });
}
