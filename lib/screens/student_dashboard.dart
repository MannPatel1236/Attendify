// Student dashboard: spec §4.2.
// Single vertical scroll. No tabs, no FAB, no bottom nav.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/studio_tokens.dart';
import '../theme/studio_typography.dart';
import '../widgets/studio/hero_attendance_gauge.dart';
import '../widgets/studio/section_header.dart';
import '../widgets/studio/numbered_row.dart';
import '../widgets/studio/subject_progress_bar.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final firstName = appState.currentUserName?.split(' ').first ?? 'there';
    final today = _formatDate(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: StudioSpacing.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 01 / Page title
              Padding(
                padding: const EdgeInsets.only(top: StudioSpacing.s6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Hey, $firstName',
                        style: StudioTypography.pageTitle(),
                      ),
                    ),
                    Text(today, style: StudioTypography.monoCaption()),
                  ],
                ),
              ),

              // Hero gauge
              Padding(
                padding: const EdgeInsets.only(top: StudioSpacing.s7),
                child: Center(
                  child: HeroAttendanceGauge(
                    percent: appState.overallAttendancePercent,
                    caption: _heroCaption(appState.overallAttendancePercent),
                  ),
                ),
              ),

              // 02 / Today's classes
              Padding(
                padding: const EdgeInsets.only(top: StudioSpacing.s10),
                child: SectionHeader(
                  index: 2,
                  label: "TODAY'S CLASSES",
                  meta: _todayMeta(appState),
                ),
              ),
              for (var i = 0; i < appState.todayClasses.length; i++)
                NumberedRow(
                  index: i + 1,
                  primary: appState.todayClasses[i].subjectName,
                  secondary: appState.todayClasses[i].timeLabel,
                  trailing: _statusDot(appState.todayClasses[i].status),
                ),

              // 03 / By subject
              Padding(
                padding: const EdgeInsets.only(top: StudioSpacing.s10),
                child: SectionHeader(
                  index: 3,
                  label: 'BY SUBJECT',
                ),
              ),
              for (var i = 0; i < appState.subjects.length; i++)
                _SubjectRow(
                  index: i + 1,
                  name: appState.subjects[i].name,
                  percent: appState.subjects[i].attendancePercent,
                ),

              // 04 / Recovery (only if overall < 85%)
              if (appState.overallAttendancePercent < 85) ...[
                Padding(
                  padding: const EdgeInsets.only(top: StudioSpacing.s10),
                  child: SectionHeader(index: 4, label: 'RECOVERY'),
                ),
                for (var i = 0; i < appState.recoverySuggestions.length; i++)
                  NumberedRow(
                    index: i + 1,
                    primary: appState.recoverySuggestions[i].action,
                    secondary:
                        '+${appState.recoverySuggestions[i].impact.toStringAsFixed(1)}% to overall',
                  ),
              ],

              const SizedBox(height: StudioSpacing.s10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusDot(String status) {
    Color color;
    switch (status) {
      case 'safe':
        color = StudioColors.semanticSafe;
        break;
      case 'warning':
        color = StudioColors.semanticWarning;
        break;
      case 'danger':
        color = StudioColors.semanticDanger;
        break;
      default:
        color = StudioColors.textMuted;
    }
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  String _formatDate(DateTime d) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    return '${days[d.weekday - 1]} · ${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]}';
  }

  String _heroCaption(double percent) {
    if (percent >= 75) {
      return '${(percent - 75).toStringAsFixed(1)}% above safe line';
    }
    return '${(75 - percent).toStringAsFixed(1)}% below — recovery needed';
  }

  String _todayMeta(AppState s) {
    final attended = s.todayClasses.where((c) => c.status == 'safe').length;
    return '$attended OF ${s.todayClasses.length} ATTENDED';
  }
}

class _SubjectRow extends StatelessWidget {
  final int index;
  final String name;
  final double percent;

  const _SubjectRow({
    required this.index,
    required this.name,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: StudioSpacing.s4,
        vertical: StudioSpacing.s5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                index.toString().padLeft(2, '0'),
                style: StudioTypography.monoSmall(),
              ),
              const SizedBox(width: StudioSpacing.s3),
              Expanded(
                child: Text(name, style: StudioTypography.bodyEmphasis()),
              ),
              Text(
                '${percent.toStringAsFixed(1)}%',
                style: StudioTypography.monoSmall().copyWith(
                  color: StudioColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: StudioSpacing.s2),
          SubjectProgressBar(percent: percent),
        ],
      ),
    );
  }
}
