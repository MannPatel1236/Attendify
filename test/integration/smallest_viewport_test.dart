// Smallest-viewport verification: spec §8.
// Pumps each screen at 360×640 and asserts no overflow.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:attendify/screens/login_screen.dart';
import 'package:attendify/screens/student_dashboard.dart';
import 'package:attendify/screens/teacher_dashboard.dart';
import 'package:attendify/screens/roll_call_screen.dart';
import 'package:attendify/screens/settings_screen.dart';
import 'package:attendify/state/app_state.dart';
import 'package:attendify/theme/studio_theme.dart';

Future<void> _pumpAt(WidgetTester tester, Widget child) async {
  await tester.binding.setSurfaceSize(const Size(360, 640));
  final appState = AppState();
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: appState,
      child: MaterialApp(theme: StudioTheme.dark(), home: child),
    ),
  );
}

void main() {
  testWidgets('LoginScreen fits in 360x640', (tester) async {
    await _pumpAt(tester, const LoginScreen());
    expect(tester.takeException(), isNull);
  });
  testWidgets('StudentDashboard fits in 360x640', (tester) async {
    await _pumpAt(tester, const StudentDashboard());
    expect(tester.takeException(), isNull);
  });
  testWidgets('TeacherDashboard fits in 360x640', (tester) async {
    await _pumpAt(tester, const TeacherDashboard());
    expect(tester.takeException(), isNull);
  });
  testWidgets('RollCallScreen fits in 360x640', (tester) async {
    await _pumpAt(tester, const RollCallScreen());
    expect(tester.takeException(), isNull);
  });
  testWidgets('SettingsScreen fits in 360x640', (tester) async {
    await _pumpAt(tester, const SettingsScreen());
    expect(tester.takeException(), isNull);
  });
}
