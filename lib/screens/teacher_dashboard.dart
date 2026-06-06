// Teacher dashboard: spec §4.3.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/studio_tokens.dart';
import '../theme/studio_typography.dart';
import '../widgets/studio/section_header.dart';
import '../widgets/studio/numbered_row.dart';
import '../widgets/studio/studio_button.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final today = _formatDate(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: StudioSpacing.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: StudioSpacing.s6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Classes', style: StudioTypography.pageTitle()),
                    ),
                    Text(today, style: StudioTypography.monoCaption()),
                  ],
                ),
              ),
              const SectionHeader(index: 1, label: 'TODAY'),
              for (var i = 0; i < appState.teacherTodayClasses.length; i++)
                NumberedRow(
                  index: i + 1,
                  primary: appState.teacherTodayClasses[i].subjectName,
                  secondary: appState.teacherTodayClasses[i].timeLabel,
                  trailing: Text(
                    '${appState.teacherTodayClasses[i].presentCount}/${appState.teacherTodayClasses[i].totalCount} PRESENT',
                    style: StudioTypography.monoCaption(),
                  ),
                ),
              const SectionHeader(index: 2, label: 'THIS WEEK'),
              for (var i = 0; i < appState.teacherWeekClasses.length; i++)
                NumberedRow(
                  index: i + 1,
                  primary: appState.teacherWeekClasses[i].subjectName,
                  secondary: appState.teacherWeekClasses[i].timeLabel,
                  trailing: Text(
                    '${appState.teacherWeekClasses[i].day} · ${appState.teacherWeekClasses[i].presentCount}/${appState.teacherWeekClasses[i].totalCount}',
                    style: StudioTypography.monoCaption(),
                  ),
                ),
              const SectionHeader(index: 3, label: 'REPORTS'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: StudioSpacing.s4),
                child: StudioButton(
                  label: 'Export this week as CSV',
                  variant: StudioButtonVariant.secondary,
                  onPressed: () {
                    // CSV export: actual implementation lives in services/.
                    // No-op stub for the visual rebuild.
                  },
                ),
              ),
              const SizedBox(height: StudioSpacing.s10),
            ],
          ),
        ),
      ),
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
}
