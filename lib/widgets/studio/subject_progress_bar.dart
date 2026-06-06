// Subject progress bar: spec §3.5.

import 'package:flutter/material.dart';
import '../../theme/studio_tokens.dart';

class SubjectProgressBar extends StatelessWidget {
  final double percent; // 0..100
  final Duration animationDuration;
  final bool animate;

  const SubjectProgressBar({
    super.key,
    required this.percent,
    this.animationDuration = StudioMotion.progressFill,
    this.animate = true,
  });

  Color _color() {
    if (percent >= 80) return StudioColors.semanticSafe;
    if (percent >= 75) return StudioColors.semanticWarning;
    return StudioColors.semanticDanger;
  }

  @override
  Widget build(BuildContext context) {
    final clamped = percent.clamp(0.0, 100.0) / 100.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        return SizedBox(
          height: 2,
          width: trackWidth,
          child: Stack(
            children: [
              Container(color: StudioColors.borderSubtle),
              if (animate)
                TweenAnimationBuilder<double>(
                  duration: animationDuration,
                  curve: StudioMotion.easing,
                  tween: Tween(begin: 0, end: clamped),
                  builder: (context, value, _) {
                    return SizedBox(
                      width: trackWidth * value,
                      height: 2,
                      child: Container(color: _color()),
                    );
                  },
                )
              else
                SizedBox(
                  width: trackWidth * clamped,
                  height: 2,
                  child: Container(color: _color()),
                ),
            ],
          ),
        );
      },
    );
  }
}
