// Segmented control: replaces switches, radio buttons, and the
// three-state attendance toggle (spec §3.2).

import 'package:flutter/material.dart';
import '../../theme/studio_tokens.dart';
import '../../theme/studio_typography.dart';

class SegmentedControl<T> extends StatelessWidget {
  final List<T> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final bool compact;

  const SegmentedControl({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final height = compact ? 32.0 : 36.0;
    final outerRadius = compact
        ? StudioRadii.controlInnerCompact + 2
        : StudioRadii.control;
    final innerRadius =
        compact ? StudioRadii.controlInnerCompact : StudioRadii.controlInner;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: StudioColors.surfaceRaised,
        border: Border.all(color: StudioColors.borderSubtle, width: 1),
        borderRadius: BorderRadius.circular(outerRadius),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((opt) {
          final isActive = opt == selected;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(opt),
              child: AnimatedContainer(
                duration: StudioMotion.defaultDuration,
                curve: StudioMotion.easing,
                decoration: BoxDecoration(
                  color: isActive
                      ? StudioColors.accentPrimary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(innerRadius),
                ),
                alignment: Alignment.center,
                child: Text(
                  opt.toString(),
                  style: StudioTypography.button().copyWith(
                    fontSize: compact ? 12 : 13,
                    color: isActive
                        ? StudioColors.textPrimary
                        : StudioColors.textTertiary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
