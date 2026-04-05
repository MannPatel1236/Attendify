import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'roll_call_screen.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E2C) : Colors.white;

    final subjects = ["ML-I (TH)", "DS (TH)", "SDS (TH)", "EFM (TH)", "CMPM (TH)", "WE (PR)", "PBC (TUT)", "DS (PR)", "ML-I (PR)", "SDS (PR)", "CMPM (PR)"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Portal"),
        actions: [
          IconButton(
            icon: Icon(appState.themeIcon),
            onPressed: () => appState.toggleTheme(),
            tooltip: "Theme: ${appState.themeLabel}",
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: () => appState.logout()),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Subject to Take Roll Call",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  final typeColor = _typeColor(subject);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      leading: Container(
                        width: 4,
                        height: 36,
                        decoration: BoxDecoration(color: typeColor, borderRadius: BorderRadius.circular(2)),
                      ),
                      title: Text(
                        subject,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16,
                        color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => RollCallScreen(subjectName: subject)),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _typeColor(String subject) {
    if (subject.contains('(PR)')) return const Color(0xFF00B4D8);
    if (subject.contains('(TUT)')) return const Color(0xFFFF9F43);
    return const Color(0xFF6C63FF);
  }
}
