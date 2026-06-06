import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:attendify/widgets/studio/studio_input.dart';
import 'package:attendify/theme/studio_tokens.dart';

void main() {
  group('StudioInput', () {
    testWidgets('renders with the value, hint, and 40px height', (tester) async {
      final controller = TextEditingController(text: 'aarav@uni.edu');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StudioInput(
            controller: controller,
            hint: 'Email',
          ),
        ),
      ));

      expect(find.text('aarav@uni.edu'), findsOneWidget);
      final box = tester.renderObject<RenderBox>(find.byType(TextField));
      expect(box.size.height, 40);
    });

    testWidgets('error state shows danger-colored helper text', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StudioInput(
            hint: 'Email',
            errorText: 'Invalid email',
          ),
        ),
      ));

      expect(find.text('Invalid email'), findsOneWidget);
      final helper = tester.widget<Text>(find.text('Invalid email'));
      expect(helper.style?.color, StudioColors.semanticDanger);
    });

    testWidgets('monospace mode uses a monospace font family', (tester) async {
      final controller = TextEditingController(text: '2026-CS-042');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StudioInput(
            controller: controller,
            monospace: true,
          ),
        ),
      ));

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.style?.fontFamily, isNotNull);
      expect(tf.style!.fontFamily!.toLowerCase(), contains('mono'));
    });
  });
}
