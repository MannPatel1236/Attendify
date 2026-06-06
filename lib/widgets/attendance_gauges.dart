import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/softclaw_theme.dart';

/// ═══════════════════════════════════════════════════════════════════════════
///  Hero Attendance Ring — the centerpiece gauge of the student dashboard.
///
///  Visual approach: a 3D-feel ring that "fills" the safety threshold (75%)
///  as a soft inner halo, and a 1.5x thicker outer ring for the actual %.
///  Three concentric layers — a track, a halo, and a fill — give the gauge
///  real depth, not the typical single-stroke progress ring.
/// ═══════════════════════════════════════════════════════════════════════════

class HeroAttendanceGauge extends StatefulWidget {
  final double percent;       // 0..100
  final bool isSafe;          // >= 75
  final double size;
  final String? subtitle;     // e.g. "Overall Attendance"

  const HeroAttendanceGauge({
    super.key,
    required this.percent,
    required this.isSafe,
    this.size = 180,
    this.subtitle,
  });

  @override
  State<HeroAttendanceGauge> createState() => _HeroAttendanceGaugeState();
}

class _HeroAttendanceGaugeState extends State<HeroAttendanceGauge>
    with TickerProviderStateMixin {
  late final AnimationController _intro;
  late final AnimationController _pulse;
  late Animation<double> _fill;
  double _from = 0;
  double _to = 0;

  @override
  void initState() {
    super.initState();
    _to = widget.percent / 100.0;
    _intro = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1400),
    );
    _pulse = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _fill = Tween<double>(begin: 0, end: _to).animate(
      CurvedAnimation(parent: _intro, curve: const Cubic(0.16, 1, 0.3, 1)),
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _intro.forward();
    });
  }

  @override
  void didUpdateWidget(covariant HeroAttendanceGauge old) {
    super.didUpdateWidget(old);
    if (old.percent != widget.percent) {
      _from = _fill.value;
      _to = widget.percent / 100.0;
      _fill = Tween<double>(begin: _from, end: _to).animate(
        CurvedAnimation(parent: _intro, curve: const Cubic(0.16, 1, 0.3, 1)),
      );
      _intro
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _intro.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSafe = widget.isSafe;
    final ringColor = isSafe
        ? (isDark ? SoftClawPalette.green300 : SoftClawPalette.green500)
        : (isDark ? const Color(0xFFFBBF24) : SoftClawPalette.amber500);
    final trackColor = isDark
        ? Colors.white.withOpacity(0.06)
        : SoftClawPalette.clayEdge;

    return SizedBox(
      width: widget.size, height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_fill, _pulse]),
        builder: (context, _) {
          final pulseVal = 0.92 + (_pulse.value * 0.08);
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulse halo
              Transform.scale(
                scale: pulseVal,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ringColor.withOpacity(
                      isSafe ? 0.10 : 0.10,
                    ),
                  ),
                ),
              ),
              // Inner clay disc (gives the gauge a "pressed in" feel)
              Container(
                width: widget.size - 32,
                height: widget.size - 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? SoftClawPalette.cardDarkSoft
                      : Colors.white,
                  boxShadow: SoftClawShadows.clayInset,
                ),
              ),
              // Progress ring
              SizedBox(
                width: widget.size, height: widget.size,
                child: CustomPaint(
                  painter: _GaugePainter(
                    value: _fill.value,
                    isSafe: isSafe,
                    ringColor: ringColor,
                    trackColor: trackColor,
                    safetyThreshold: 0.75,
                    isDark: isDark,
                  ),
                ),
              ),
              // Center text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${widget.percent.toStringAsFixed(1)}",
                    style: GoogleFonts.baloo2(
                      fontSize: widget.size * 0.22,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: -1.5,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    "%",
                    style: GoogleFonts.baloo2(
                      fontSize: widget.size * 0.08,
                      fontWeight: FontWeight.w700,
                      color: ringColor,
                      letterSpacing: 0.5,
                      height: 0.8,
                    ),
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle!.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface
                            .withOpacity(0.55),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;       // 0..1
  final bool isSafe;
  final Color ringColor;
  final Color trackColor;
  final double safetyThreshold;
  final bool isDark;

  _GaugePainter({
    required this.value,
    required this.isSafe,
    required this.ringColor,
    required this.trackColor,
    required this.safetyThreshold,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 14;

    // ── Track (full ring) ──────────────────────────────────────────────
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 14;
    canvas.drawCircle(center, radius, trackPaint);

    // ── Safety threshold marker (75%) ──────────────────────────────────
    final safetyAngle = -math.pi / 2 + (2 * math.pi * safetyThreshold);
    final safetyPaint = Paint()
      ..color = isSafe
          ? ringColor.withOpacity(0.4)
          : SoftClawPalette.amber500.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;
    final safetyInner = radius - 18;
    final safetyOuter = radius + 12;
    canvas.drawLine(
      Offset(
        center.dx + math.cos(safetyAngle) * safetyInner,
        center.dy + math.sin(safetyAngle) * safetyInner,
      ),
      Offset(
        center.dx + math.cos(safetyAngle) * safetyOuter,
        center.dy + math.sin(safetyAngle) * safetyOuter,
      ),
      safetyPaint,
    );

    // ── Fill arc ───────────────────────────────────────────────────────
    if (value > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final fillPaint = Paint()
        ..shader = SweepGradient(
          startAngle: -math.pi / 2,
          endAngle: 3 * math.pi / 2,
          colors: [
            ringColor.withOpacity(0.95),
            ringColor.withOpacity(0.75),
            ringColor.withOpacity(0.95),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 14;
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * value.clamp(0.0, 1.0),
        false,
        fillPaint,
      );

      // ── Glow at tip ─────────────────────────────────────────────────
      final tipAngle = -math.pi / 2 + (2 * math.pi * value.clamp(0.0, 1.0));
      final tipX = center.dx + math.cos(tipAngle) * radius;
      final tipY = center.dy + math.sin(tipAngle) * radius;
      final glowPaint = Paint()
        ..color = ringColor.withOpacity(0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(Offset(tipX, tipY), 14, glowPaint);
      final tipPaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(tipX, tipY), 6, tipPaint);
      final tipCore = Paint()..color = ringColor;
      canvas.drawCircle(Offset(tipX, tipY), 4, tipCore);
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter old) =>
      old.value != value ||
      old.ringColor != ringColor ||
      old.trackColor != trackColor ||
      old.isSafe != isSafe;
}

// ─── CompactSubjectRing ────────────────────────────────────────────────────
class CompactSubjectRing extends StatelessWidget {
  final double percent;
  final bool isSafe;
  final double size;

  const CompactSubjectRing({
    super.key,
    required this.percent,
    required this.isSafe,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isSafe
        ? (isDark ? SoftClawPalette.green300 : SoftClawPalette.green500)
        : (isDark ? const Color(0xFFFBBF24) : SoftClawPalette.amber500);
    final track = isDark ? Colors.white.withOpacity(0.06) : SoftClawPalette.clayEdge;
    return SizedBox(
      width: size, height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Inset disc
          Container(
            width: size - 10, height: size - 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? SoftClawPalette.cardDarkSoft : Colors.white,
              boxShadow: SoftClawShadows.clayInset,
            ),
          ),
          SizedBox(
            width: size, height: size,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1100),
              curve: const Cubic(0.16, 1, 0.3, 1),
              tween: Tween(begin: 0, end: percent / 100.0),
              builder: (context, v, _) => CustomPaint(
                painter: _CompactRingPainter(
                  value: v, color: accent, track: track,
                ),
              ),
            ),
          ),
          Text(
            "${percent.toInt()}",
            style: GoogleFonts.baloo2(
              fontSize: size * 0.22,
              fontWeight: FontWeight.w800,
              color: accent,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactRingPainter extends CustomPainter {
  final double value;
  final Color color;
  final Color track;
  _CompactRingPainter({required this.value, required this.color, required this.track});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = (size.width / 2) - 6;
    final trackP = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(c, r, trackP);
    if (value > 0) {
      final fillP = Paint()
        ..shader = SweepGradient(
          colors: [color.withOpacity(0.95), color.withOpacity(0.7), color.withOpacity(0.95)],
        ).createShader(Rect.fromCircle(center: c, radius: r))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        -math.pi / 2, 2 * math.pi * value.clamp(0.0, 1.0), false, fillP,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CompactRingPainter old) =>
      old.value != value || old.color != color || old.track != track;
}
