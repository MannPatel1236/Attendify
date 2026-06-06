import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:attendify/screens/teacher_dashboard.dart';
import 'package:attendify/state/app_state.dart';
import 'package:attendify/theme/studio_theme.dart';

void main() {
  testWidgets('TeacherDashboard shows the three sections', (tester) async {
    final appState = AppState();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: MaterialApp(
          theme: StudioTheme.dark(),
          home: const TeacherDashboard(),
        ),
      ),
    );

    expect(find.text('Classes'), findsOneWidget);
    expect(find.text('01 / TODAY'), findsOneWidget);
    expect(find.text('02 / THIS WEEK'), findsOneWidget);
    expect(find.text('03 / REPORTS'), findsOneWidget);
    expect(find.text('Export this week as CSV'), findsOneWidget);
  });
}
