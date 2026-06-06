// App entry point. Wires StudioTheme (spec §2) and the AuthWrapper router.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'screens/login_screen.dart';
import 'screens/student_dashboard.dart';
import 'screens/teacher_dashboard.dart';
import 'theme/studio_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Spec §2.4: dark surface, light icons.
  SystemChrome.setSystemUIOverlayStyle(StudioTheme.systemUiOverlay);
  final appState = AppState();
  await appState.loadFromDisk();
  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const AttendanceApp(),
    ),
  );
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendify',
      debugShowCheckedModeBanner: false,
      // Spec §6: dark mode only.
      theme: StudioTheme.dark(),
      darkTheme: StudioTheme.dark(),
      themeMode: ThemeMode.dark,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AppState>().currentUserRole;
    switch (role) {
      case UserRole.student:
        return const StudentDashboard();
      case UserRole.teacher:
        return const TeacherDashboard();
      case UserRole.none:
        return const LoginScreen();
    }
  }
}
