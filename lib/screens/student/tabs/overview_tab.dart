import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/schedule_provider.dart';
import '../../../models/subject_model.dart';
import '../../../widgets/monolith_components.dart';

class OverviewTab extends StatelessWidget {
  final TabController tabController;

  const OverviewTab({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final student = context.watch<AuthProvider>().currentStudent;
    final schedule = context.watch<ScheduleProvider>();

    if (student == null) return const Center(child: CircularProgressIndicator());

    final pct = student.overallAttendance;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (schedule.isTodayHoliday) _buildHolidayBanner(schedule),

          const Text(
            "CURRENT STATUS",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: MonolithColors.tertiary,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 12),
          DataMonolith(
            value: "${pct.toStringAsFixed(1)}%",
            label: pct >= 75.0 ? "Operational / Safe" : "Action Required / Warning",
            valueColor: pct >= 75.0 ? MonolithColors.primary : const Color(0xFFEF4444),
          ),
          
          const SizedBox(height: 56), // Large vertical whitespace
          
          Row(
            children: [
              _buildMiniMetric("SUBJECTS", "${student.subjects.length}"),
              const SizedBox(width: 48), // Mathematical spacing
              _buildMiniMetric("SKIPPABLE", "${_calculateTotalCanSkip(student.subjects.values)}"),
              const SizedBox(width: 48),
              _buildMiniMetric("RECOVERY", "${_calculateTotalNeedAttend(student.subjects.values)}"),
            ],
          ),
          
          const SizedBox(height: 64),
          
          const Text(
            "ANALYTICS",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: MonolithColors.outline,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          
          ...student.subjects.values.map((sub) => _AttendanceRow(subject: sub)),
          
          const SizedBox(height: 48),
          
          Row(
            children: [
              Expanded(
                child: MonolithButton(
                  label: "MARK ATTENDANCE",
                  onTap: () => tabController.animateTo(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: MonolithColors.onSurface)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: MonolithColors.outline, letterSpacing: 1.0)),
      ],
    );
  }

  Widget _buildHolidayBanner(ScheduleProvider schedule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MonolithColors.high,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: MonolithColors.tertiary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.beach_access, color: MonolithColors.tertiary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("SYSTEM PAUSED", style: TextStyle(color: MonolithColors.onSurface, fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 1.0)),
                SizedBox(height: 4),
                Text("Today is marked as a holiday.", style: TextStyle(color: MonolithColors.outline, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: MonolithColors.outline, size: 16),
            onPressed: () => schedule.unmarkTodayAsHoliday(),
          ),
        ],
      ),
    );
  }

  int _calculateTotalCanSkip(Iterable<Subject> subjects) {
    return subjects.fold(0, (sum, sub) => sum + sub.canSkip);
  }

  int _calculateTotalNeedAttend(Iterable<Subject> subjects) {
    return subjects.fold(0, (sum, sub) => sum + sub.classesToAttend);
  }
}

class _AttendanceRow extends StatelessWidget {
  final Subject subject;

  const _AttendanceRow({required this.subject});

  @override
  Widget build(BuildContext context) {
    final pct = subject.percentage;
    final isSafe = pct >= 75.0;
    final accent = isSafe ? MonolithColors.primary : const Color(0xFFEF4444);

    return Padding(
      padding: const EdgeInsets.only(bottom: 32), // High whitespace separation
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject.name.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: MonolithColors.onSurface, letterSpacing: 0.5),
              ),
              Text(
                "${pct.toInt()}%",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: accent),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 2,
                width: double.infinity,
                color: MonolithColors.high,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                height: 2,
                width: MediaQuery.of(context).size.width * (pct / 100),
                color: accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
