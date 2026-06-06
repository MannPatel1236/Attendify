import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:attendify/screens/settings_screen.dart';
import 'package:attendify/state/app_state.dart';
import 'package:attendify/theme/studio_theme.dart';

void main() {
  testWidgets('SettingsScreen shows the four sections', (tester) async {
    final appState = AppState();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: MaterialApp(
          theme: StudioTheme.dark(),
          home: const SettingsScreen(),
        ),
      ),
    );

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('01 / PROFILE'), findsOneWidget);
    expect(find.text('02 / PREFERENCES'), findsOneWidget);
    expect(find.text('03 / ABOUT'), findsOneWidget);
    expect(find.text('04 / DANGER ZONE'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
    expect(find.text('Delete account'), findsOneWidget);
  });
}
