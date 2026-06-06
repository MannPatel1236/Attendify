// Hero attendance gauge: spec §3.4.
// 270° thin progress arc + 75% threshold tick + centered number.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/studio_tokens.dart';
import '../../theme/studio_typography.dart';

class HeroAttendanceGauge extends StatelessWidget {
  final double percent; // 0..100
  final String? caption;
  final double size;
  final Duration animationDuration;

  const HeroAttendanceGauge({
    super.key,
    required this.percent,
    this.caption,
    this.size = 240,
    this.animationDuration = StudioMotion.gaugeFill,
  });

  double get _clamped => percent.clamp(0.0, 100.0);

  String get _label => '${_clamped.toStringAsFixed(1)}%';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        duration: animationDuration,
        curve: StudioMotion.easing,
        tween: Tween(begin: 0, end: _clamped / 100.0),
        builder: (context, value, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _GaugePainter(progress: value),
              ),
              // Center widget ensures the Column shrinks to its content
              // size rather than filling the Stack.
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _label,
                      style: StudioTypography.heroNumber().copyWith(height: 1.0),
                    ),
                    if (caption != null) ...[
                      const SizedBox(height: StudioSpacing.s1),
                      Text(caption!, style: StudioTypography.caption()),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress; // 0..1
  static const double _startAngle = math.pi * 0.75; // 135° → opens at top
  static const double _sweep = math.pi * 1.5; // 270°

  _GaugePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track
    final trackPaint = Paint()
      ..color = StudioColors.borderSubtle
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, _startAngle, _sweep, false, trackPaint);

    // Fill
    final fillPaint = Paint()
      ..color = StudioColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, _startAngle, _sweep * progress, false, fillPaint);

    // Threshold tick at 75% (spec §3.4).
    final thresholdAngle = _startAngle + _sweep * 0.75;
    final thresholdOuter = Offset(
      center.dx + (radius + 6) * math.cos(thresholdAngle),
      center.dy + (radius + 6) * math.sin(thresholdAngle),
    );
    final thresholdInner = Offset(
      center.dx + (radius - 6) * math.cos(thresholdAngle),
      center.dy + (radius - 6) * math.sin(thresholdAngle),
    );
    final tickPaint = Paint()
      ..color = StudioColors.semanticWarning
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.butt;
    canvas.drawLine(thresholdOuter, thresholdInner, tickPaint);
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.progress != progress;
}
