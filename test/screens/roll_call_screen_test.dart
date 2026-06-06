import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:attendify/screens/roll_call_screen.dart';
import 'package:attendify/state/app_state.dart';
import 'package:attendify/theme/studio_theme.dart';

void main() {
  testWidgets('RollCallScreen shows the sticky header and student list',
      (tester) async {
    final appState = AppState();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: MaterialApp(
          theme: StudioTheme.dark(),
          home: const RollCallScreen(),
        ),
      ),
    );

    expect(find.text('01 / STUDENTS'), findsOneWidget);
    expect(find.text('Save attendance'), findsOneWidget);
  });
}
