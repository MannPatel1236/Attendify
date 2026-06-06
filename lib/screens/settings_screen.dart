// Settings screen: spec §4.5.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/studio_tokens.dart';
import '../theme/studio_typography.dart';
import '../widgets/studio/section_header.dart';
import '../widgets/studio/numbered_row.dart';
import '../widgets/studio/segmented_control.dart';
import '../widgets/studio/studio_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: StudioSpacing.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: StudioSpacing.s6),
                child: Text('Settings', style: StudioTypography.pageTitle()),
              ),
              const SectionHeader(index: 1, label: 'PROFILE'),
              NumberedRow(
                index: 1,
                primary: appState.currentUserName ?? '—',
                secondary: appState.currentUserEmail ?? '—',
              ),
              NumberedRow(
                index: 2,
                primary: 'Roll number',
                secondary: appState.currentUserRollNumber ?? '—',
                trailing: const SizedBox.shrink(),
              ),
              const SectionHeader(index: 2, label: 'PREFERENCES'),
              NumberedRow(
                index: 1,
                primary: 'Theme',
                secondary: 'Dark',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: StudioSpacing.s4,
                  vertical: StudioSpacing.s4,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text('Notifications', style: TextStyle(color: StudioColors.textSecondary, fontSize: 14)),
                    ),
                    SizedBox(
                      width: 120,
                      child: SegmentedControl<String>(
                        options: const ['On', 'Off'],
                        selected: appState.notificationsEnabled ? 'On' : 'Off',
                        onChanged: (v) => appState.setNotificationsEnabled(v == 'On'),
                      ),
                    ),
                  ],
                ),
              ),
              const SectionHeader(index: 3, label: 'ABOUT'),
              NumberedRow(
                index: 1,
                primary: 'Version',
                secondary: '1.0.0',
              ),
              NumberedRow(
                index: 2,
                primary: 'Open source',
                secondary: 'github.com/...',
                trailing: const Text('→', style: TextStyle(color: StudioColors.textMuted, fontSize: 13)),
              ),
              NumberedRow(
                index: 3,
                primary: 'Privacy',
                trailing: const Text('→', style: TextStyle(color: StudioColors.textMuted, fontSize: 13)),
              ),
              const SectionHeader(index: 4, label: 'DANGER ZONE'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: StudioSpacing.s3),
                child: StudioButton(
                  label: 'Sign out',
                  variant: StudioButtonVariant.secondary,
                  onPressed: () => appState.setRole(UserRole.none),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: StudioSpacing.s3),
                child: StudioButton(
                  label: 'Delete account',
                  variant: StudioButtonVariant.destructive,
                  onPressed: () => _confirmDelete(context),
                ),
              ),
              const SizedBox(height: StudioSpacing.s10),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: StudioColors.surfaceOverlay,
        title: const Text('Delete account?', style: TextStyle(color: StudioColors.textPrimary)),
        content: const Text(
          'This cannot be undone.',
          style: TextStyle(color: StudioColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AppState>().deleteAccount();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: StudioColors.semanticDanger),
            ),
          ),
        ],
      ),
    );
  }
}
