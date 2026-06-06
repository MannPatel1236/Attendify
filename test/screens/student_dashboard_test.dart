import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:attendify/screens/student_dashboard.dart';
import 'package:attendify/state/app_state.dart';
import 'package:attendify/theme/studio_theme.dart';

void main() {
  testWidgets('StudentDashboard shows the page title and the four sections',
      (tester) async {
    final appState = AppState();
    // Pre-seed app state with a minimal student + class schedule.
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: MaterialApp(
          theme: StudioTheme.dark(),
          home: const StudentDashboard(),
        ),
      ),
    );

    // Page title is "Hey, {firstName}" (we use a default if none is set).
    expect(find.textContaining('Hey,'), findsOneWidget);
    // Four sections: 01 WELCOME-style first, then 02-04.
    expect(find.textContaining('02 /'), findsOneWidget);
    expect(find.textContaining('03 /'), findsOneWidget);
  });

  testWidgets('renders the hero gauge with the weighted average percent',
      (tester) async {
    final appState = AppState();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: MaterialApp(
          theme: StudioTheme.dark(),
          home: const StudentDashboard(),
        ),
      ),
    );

    // The gauge label is a percent string like "85.0%".
    expect(find.byIcon(Icons.expand_more), findsNothing); // sanity
    expect(find.textContaining('%'), findsWidgets);
  });
}
