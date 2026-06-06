// Section header: spec §3.9.

import 'package:flutter/material.dart';
import '../../theme/studio_tokens.dart';
import '../../theme/studio_typography.dart';

class SectionHeader extends StatelessWidget {
  final int index;
  final String label;
  final String? meta;

  const SectionHeader({
    super.key,
    required this.index,
    required this.label,
    this.meta,
  });

  String get _prefix => '${index.toString().padLeft(2, '0')} / ';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: StudioSpacing.s4),
          child: Row(
            children: [
              Text(_prefix + label, style: StudioTypography.sectionLabel()),
              const Spacer(),
              if (meta != null)
                Text(meta!, style: StudioTypography.monoCaption()),
            ],
          ),
        ),
        const SizedBox(height: StudioSpacing.s3),
        Container(height: 1, color: StudioColors.borderSubtle),
      ],
    );
  }
}
