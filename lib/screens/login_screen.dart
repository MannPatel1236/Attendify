// Login screen: spec §4.1.
// Editorial layout: wordmark row, headline, two numbered portal rows, footer.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/studio_tokens.dart';
import '../theme/studio_typography.dart';
import '../widgets/studio/numbered_row.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: StudioSpacing.s5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wordmark row
              Padding(
                padding: const EdgeInsets.only(top: StudioSpacing.s6),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: StudioColors.accentPrimary,
                        shape: BoxShape.circle,
                        // Spec §4.1: single accent dot with subtle glow.
                        // This is the only BoxShadow allowed in the app
                        // (compliance test carves it out for login_screen.dart).
                        boxShadow: [
                          BoxShadow(
                            color: StudioColors.accentPrimary,
                            blurRadius: 12,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: StudioSpacing.s3 - 2),
                    Text(
                      'Attendify',
                      style: StudioTypography.bodyEmphasis()
                          .copyWith(fontSize: 14),
                    ),
                    const Spacer(),
                    Text('v1.0', style: StudioTypography.monoCaption()),
                  ],
                ),
              ),

              // Editorial headline block
              Padding(
                padding: const EdgeInsets.only(top: StudioSpacing.s10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('01 / WELCOME', style: StudioTypography.sectionLabel()),
                    const SizedBox(height: StudioSpacing.s3),
                    Text(
                      'Track your attendance, calmly.',
                      style: StudioTypography.editorialHeadline(),
                    ),
                    const SizedBox(height: StudioSpacing.s4),
                    SizedBox(
                      width: 320,
                      child: Text(
                        'A precision tool for students who care about the 75% line. No noise, no clutter.',
                        style: StudioTypography.body().copyWith(
                          color: StudioColors.textTertiary,
                          height: 1.55,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Portal selector
              Padding(
                padding: const EdgeInsets.only(top: StudioSpacing.s7),
                child: Column(
                  children: [
                    NumberedRow(
                      index: 1,
                      primary: 'Student Portal',
                      trailing: const Text(
                        '→',
                        style: TextStyle(
                          color: StudioColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                      onTap: () {
                        context.read<AppState>().setRole(UserRole.student);
                      },
                    ),
                    NumberedRow(
                      index: 2,
                      primary: 'Teacher Portal',
                      trailing: const Text(
                        '→',
                        style: TextStyle(
                          color: StudioColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                      onTap: () {
                        context.read<AppState>().setRole(UserRole.teacher);
                      },
                    ),
                  ],
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.only(top: StudioSpacing.s9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'OFFLINE-FIRST · OPEN SOURCE',
                      style: StudioTypography.monoCaption().copyWith(
                        letterSpacing: 1.5,
                      ),
                    ),
                    Row(
                      children: [
                        _swatch(StudioColors.accentPrimary),
                        const SizedBox(width: StudioSpacing.s1),
                        _swatch(StudioColors.surfaceRaised),
                        const SizedBox(width: StudioSpacing.s1),
                        _swatch(StudioColors.borderSubtle),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _swatch(Color c) => Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: c,
          // spec §2.3: sharp corners. The palette swatch is a pure color
          // block; a 4px radius adds nothing.
          borderRadius: BorderRadius.zero,
        ),
      );
}
