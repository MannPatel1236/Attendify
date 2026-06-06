import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:attendify/screens/login_screen.dart';
import 'package:attendify/state/app_state.dart';
import 'package:attendify/theme/studio_theme.dart';

void main() {
  testWidgets('LoginScreen renders the editorial headline and two portal rows',
      (tester) async {
    final appState = AppState();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: MaterialApp(
          theme: StudioTheme.dark(),
          home: const LoginScreen(),
        ),
      ),
    );

    expect(find.text('Track your attendance, calmly.'), findsOneWidget);
    expect(find.text('Student Portal'), findsOneWidget);
    expect(find.text('Teacher Portal'), findsOneWidget);
    expect(find.text('01 / WELCOME'), findsOneWidget);
  });

  testWidgets('tapping Student Portal sets role to student', (tester) async {
    final appState = AppState();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: MaterialApp(
          theme: StudioTheme.dark(),
          home: const LoginScreen(),
        ),
      ),
    );

    await tester.tap(find.text('Student Portal'));
    await tester.pumpAndSettle();
    expect(appState.currentUserRole, UserRole.student);
  });

  testWidgets('tapping Teacher Portal sets role to teacher', (tester) async {
    final appState = AppState();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: MaterialApp(
          theme: StudioTheme.dark(),
          home: const LoginScreen(),
        ),
      ),
    );

    await tester.tap(find.text('Teacher Portal'));
    await tester.pumpAndSettle();
    expect(appState.currentUserRole, UserRole.teacher);
  });
}
