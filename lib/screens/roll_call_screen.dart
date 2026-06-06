// Roll call / attendance-taking screen: spec §4.4.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/studio_tokens.dart';
import '../theme/studio_typography.dart';
import '../widgets/studio/section_header.dart';
import '../widgets/studio/segmented_control.dart';
import '../widgets/studio/studio_button.dart';

class RollCallScreen extends StatelessWidget {
  final String? classId;

  const RollCallScreen({super.key, this.classId});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final students = appState.studentsForClass(classId);
    final marked = students.where((s) => s.status != null).length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Sticky header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StudioSpacing.s4,
                vertical: StudioSpacing.s4,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    color: StudioColors.textSecondary,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  Expanded(
                    child: Text(
                      appState.classNameFor(classId) ?? 'Class',
                      style: StudioTypography.bodyEmphasis().copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    '$marked/${students.length} MARKED',
                    style: StudioTypography.monoCaption(),
                  ),
                ],
              ),
            ),

            // Student list
            const SectionHeader(index: 1, label: 'STUDENTS'),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, i) {
                  final s = students[i];
                  return _StudentRow(
                    index: i + 1,
                    rollNumber: s.rollNumber,
                    name: s.name,
                    status: s.status ?? 'Present',
                    onChanged: (v) => appState.setStudentStatus(s.id, v),
                  );
                },
              ),
            ),

            // Sticky footer
            Container(
              decoration: const BoxDecoration(
                color: StudioColors.surfaceBase,
                border: Border(
                  top: BorderSide(color: StudioColors.borderStrong, width: 1),
                ),
              ),
              padding: const EdgeInsets.all(StudioSpacing.s4),
              child: StudioButton(
                label: 'Save attendance',
                fullWidth: true,
                onPressed: marked == 0 ? null : () => appState.saveAttendance(classId),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  final int index;
  final String rollNumber;
  final String name;
  final String status;
  final ValueChanged<String> onChanged;

  const _StudentRow({
    required this.index,
    required this.rollNumber,
    required this.name,
    required this.status,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: StudioSpacing.s4,
        vertical: StudioSpacing.s4,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: StudioColors.borderSubtle, width: 1),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              index.toString().padLeft(2, '0'),
              style: StudioTypography.monoSmall(),
            ),
          ),
          const SizedBox(width: StudioSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(rollNumber, style: StudioTypography.monoCaption()),
                const SizedBox(height: 2),
                Text(name, style: StudioTypography.bodyEmphasis()),
              ],
            ),
          ),
          const SizedBox(width: StudioSpacing.s3),
          SizedBox(
            width: 220,
            child: SegmentedControl<String>(
              options: const ['Present', 'Absent', 'Cancelled'],
              selected: status,
              onChanged: onChanged,
              compact: true,
            ),
          ),
        ],
      ),
    );
  }
}
