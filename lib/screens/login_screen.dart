import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardBg = isDark ? const Color(0xFF1E1E2C) : Colors.white;
    final headingColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subtitleColor = isDark ? Colors.grey.shade400 : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App icon with glow
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.indigo.shade400,
                        Colors.deepPurple.shade600,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.school_rounded, size: 48, color: Colors.white),
                ),
                const SizedBox(height: 28),
                Text(
                  "Attendify",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: headingColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Smart Attendance Management",
                  style: TextStyle(
                    fontSize: 16,
                    color: subtitleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 56),
                _buildLoginCard(
                  context,
                  title: "Student Portal",
                  subtitle: "Track attendance & upload documents",
                  icon: Icons.person_outline,
                  gradient: [Colors.blue.shade400, Colors.indigo.shade600],
                  cardBg: cardBg,
                  isDark: isDark,
                  onTap: () => context.read<AppState>().loginAsStudent(),
                ),
                const SizedBox(height: 16),
                _buildLoginCard(
                  context,
                  title: "Teacher Portal",
                  subtitle: "Take roll call & view proxy letters",
                  icon: Icons.admin_panel_settings_outlined,
                  gradient: [Colors.deepPurple.shade400, Colors.indigo.shade700],
                  cardBg: cardBg,
                  isDark: isDark,
                  onTap: () => context.read<AppState>().loginAsTeacher(),
                ),
                const SizedBox(height: 32),
                // Theme toggle
                TextButton.icon(
                  onPressed: () => context.read<AppState>().toggleTheme(),
                  icon: Icon(context.watch<AppState>().themeIcon, size: 18, color: subtitleColor),
                  label: Text(
                    "Theme: ${context.watch<AppState>().themeLabel}",
                    style: TextStyle(color: subtitleColor, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required Color cardBg,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final borderColor = isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade200;
    final titleColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final arrowColor = isDark ? Colors.grey.shade500 : Colors.grey.shade400;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(colors: gradient),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: titleColor)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: subColor)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: arrowColor),
          ],
        ),
      ),
    );
  }
}
