import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/attendance_provider.dart';
import '../../../services/attendance_service.dart';
import '../../../widgets/monolith_components.dart';

class SkipAdvisorTab extends StatelessWidget {
  const SkipAdvisorTab({super.key});

  @override
  Widget build(BuildContext context) {
    final attendance = context.watch<AttendanceProvider>();
    final suggestions = attendance.getSkipSuggestions();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 56),
          _buildSectionTitle("SINGLE DAY PROCEDURES"),
          const SizedBox(height: 24),
          ...suggestions.where((s) => s.dayNames.length == 1).map((s) => _SkipCard(suggestion: s)),
          const SizedBox(height: 56),
          _buildSectionTitle("RECOVERY COMBINATIONS"),
          const SizedBox(height: 24),
          ...suggestions.where((s) => s.dayNames.length > 1).map((s) => _SkipCard(suggestion: s)),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "SMART ADVISOR",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: MonolithColors.tertiary,
            letterSpacing: 2.0,
          ),
        ),
        SizedBox(height: 12),
        Text(
          "Simulated Efficiency Metrics",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: MonolithColors.onSurface,
            letterSpacing: -1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: MonolithColors.outline,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _SkipCard extends StatelessWidget {
  final SkipDaySuggestion suggestion;

  const _SkipCard({required this.suggestion});

  @override
  Widget build(BuildContext context) {
    final accent = suggestion.isSafe ? MonolithColors.primary : const Color(0xFFEF4444);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: MonolithColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  suggestion.label.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: MonolithColors.onSurface, letterSpacing: 0.5),
                ),
                const SizedBox(height: 6),
                Text(
                  "${suggestion.totalDaysOff} DAYS OFFLINE TOTAL",
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: MonolithColors.outline, letterSpacing: 0.5),
                ),
                if (!suggestion.isSafe) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: suggestion.riskySubjects.map((sub) => _RiskyChip(text: sub)).toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            suggestion.isSafe ? "READY" : "DANGER",
            style: TextStyle(
              fontWeight: FontWeight.w900, 
              fontSize: 10, 
              color: accent, 
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskyChip extends StatelessWidget {
  final String text;
  const _RiskyChip({required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: MonolithColors.high, borderRadius: BorderRadius.circular(4)),
    child: Text(text.toUpperCase(), style: const TextStyle(color: Color(0xFFEF4444), fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
  );
}
