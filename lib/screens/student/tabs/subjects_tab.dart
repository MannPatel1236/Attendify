import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/attendance_provider.dart';
import '../../../models/subject_model.dart';
import '../../../widgets/monolith_components.dart';

class SubjectsTab extends StatelessWidget {
  const SubjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final student = context.watch<AuthProvider>().currentStudent;

    if (student == null) return const Center(child: CircularProgressIndicator());

    final subjects = student.subjects.entries.toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final key = subjects[index].key;
        final sub = subjects[index].value;
        return _SubjectListItem(subjectKey: key, subject: sub);
      },
    );
  }
}

class _SubjectListItem extends StatelessWidget {
  final String subjectKey;
  final Subject subject;

  const _SubjectListItem({required this.subjectKey, required this.subject});

  @override
  Widget build(BuildContext context) {
    final attendance = context.read<AttendanceProvider>();
    final pct = subject.percentage;
    final isSafe = pct >= 75.0;
    final accent = isSafe ? MonolithColors.primary : const Color(0xFFEF4444);

    return GestureDetector(
      onTap: () => _showEditDialog(context, attendance),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.fromLTRB(24, 24, 48, 24), // Asymmetrical padding
        decoration: BoxDecoration(
          color: MonolithColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${pct.toInt()}%",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: accent, letterSpacing: -0.5),
                ),
                const SizedBox(height: 2),
                Text(
                  isSafe ? "SAFE" : "RISK",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 10, color: MonolithColors.outline, letterSpacing: 1.0),
                ),
              ],
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.name.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: MonolithColors.onSurface),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${subject.attended} / ${subject.total} COLLECTED",
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: MonolithColors.outline, letterSpacing: 0.5),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: MonolithColors.outline.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, AttendanceProvider attendance) {
    final attendedController = TextEditingController(text: subject.attended.toString());
    final totalController = TextEditingController(text: subject.total.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("CALIBRATE ${subject.name.toUpperCase()}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildField(attendedController, "ATTENDED CLASSES"),
            const SizedBox(height: 20),
            _buildField(totalController, "TOTAL CONDUCTED"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("DISMISS", style: TextStyle(color: MonolithColors.outline))),
          MonolithButton(
            label: "UPDATE",
            onTap: () {
              final a = int.tryParse(attendedController.text);
              final t = int.tryParse(totalController.text);
              if (a != null && t != null && a <= t) {
                attendance.updateAttendance(subjectKey, a, t);
                Navigator.pop(ctx);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: MonolithColors.outline, letterSpacing: 1.0)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: MonolithColors.onSurface, fontWeight: FontWeight.w700),
          decoration: InputDecoration(
            filled: true,
            fillColor: MonolithColors.lowest,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
