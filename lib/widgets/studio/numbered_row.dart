// Numbered row: the fundamental list unit (spec §3.1).
// Replaces ClayCard and MonolithCard in row/list contexts.

import 'package:flutter/material.dart';
import '../../theme/studio_tokens.dart';
import '../../theme/studio_typography.dart';

class NumberedRow extends StatelessWidget {
  final int index;
  final String primary;
  final String? secondary;
  final Widget? trailing;
  final bool selected;
  final VoidCallback? onTap;

  const NumberedRow({
    super.key,
    required this.index,
    required this.primary,
    this.secondary,
    this.trailing,
    this.selected = false,
    this.onTap,
  });

  String get _paddedIndex => index.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final numberColor = selected
        ? StudioColors.accentPrimary
        : StudioColors.textTertiary;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: StudioColors.accentPrimaryDim,
      hoverColor: StudioColors.accentPrimaryDim,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? StudioColors.accentPrimaryDim : Colors.transparent,
          borderRadius: BorderRadius.zero, // spec §2.3: sharp corners
          border: const Border(
            bottom: BorderSide(color: StudioColors.borderSubtle, width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: StudioSpacing.s4,
          vertical: StudioSpacing.s5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              child: Text(
                _paddedIndex,
                style: StudioTypography.monoSmall().copyWith(color: numberColor),
              ),
            ),
            const SizedBox(width: StudioSpacing.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(primary, style: StudioTypography.bodyEmphasis()),
                  if (secondary != null) ...[
                    const SizedBox(height: 2),
                    Text(secondary!, style: StudioTypography.caption()),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
