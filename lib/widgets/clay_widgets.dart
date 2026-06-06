import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/softclaw_theme.dart';

/// ═══════════════════════════════════════════════════════════════════════════
///  SOFTCLAW — Claymorphic component library
///
///  Every component uses paired shadows (highlight + drop) to create the
///  "hand-pressed clay" illusion. The opposite of flat material design.
/// ═══════════════════════════════════════════════════════════════════════════

// ─── ClayCard ──────────────────────────────────────────────────────────────
class ClayCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double radius;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final bool inset;
  final double? width;
  final double? height;

  const ClayCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.radius = SoftClawRadii.lg,
    this.shadows,
    this.onTap,
    this.inset = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = color
        ?? (isDark ? SoftClawPalette.cardDark : SoftClawPalette.card);
    final baseShadows = shadows
        ?? (inset ? SoftClawShadows.clayInset : SoftClawShadows.clayRaised);

    return AnimatedContainer(
      duration: SoftClawMotion.medium,
      width: width,
      height: height,
      curve: SoftClawMotion.easeOut,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: baseShadows,
        border: isDark
            ? Border.all(color: Colors.white.withOpacity(0.04), width: 1)
            : null,
        gradient: isDark ? null : LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.85),
            baseColor,
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: onTap == null
            ? Padding(padding: padding, child: child)
            : InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(radius),
                splashColor: SoftClawPalette.cyan500.withOpacity(0.10),
                highlightColor: SoftClawPalette.cyan500.withOpacity(0.06),
                child: Padding(padding: padding, child: child),
              ),
      ),
    );
  }
}

// ─── ClayButton ───────────────────────────────────────────────────────────
class ClayButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool primary;        // cyan/green filled
  final bool loading;
  final bool fullWidth;
  final EdgeInsetsGeometry padding;

  const ClayButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.primary = false,
    this.loading = false,
    this.fullWidth = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  });

  @override
  State<ClayButton> createState() => _ClayButtonState();
}

class _ClayButtonState extends State<ClayButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disabled = widget.onPressed == null;
    final primary = widget.primary;
    final bg = primary
        ? (isDark ? SoftClawPalette.cyan500 : SoftClawPalette.cyan700)
        : (isDark ? SoftClawPalette.cardDark : SoftClawPalette.card);
    final fg = primary
        ? (isDark ? const Color(0xFF0B2A33) : Colors.white)
        : (isDark ? SoftClawPalette.inkDark900 : SoftClawPalette.ink900);
    final List<BoxShadow> glow = primary
        ? SoftClawShadows.cyanGlow
        : (isDark ? const <BoxShadow>[] : SoftClawShadows.clayPressed);

    final btn = AnimatedContainer(
      duration: SoftClawMotion.fast,
      curve: SoftClawMotion.easeOut,
      width: widget.fullWidth ? double.infinity : null,
      padding: widget.padding,
      transform: _pressed
          ? (Matrix4.identity()..scaleByDouble(0.97, 0.97, 1.0, 1.0))
          : Matrix4.identity(),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        color: disabled
            ? bg.withOpacity(0.5)
            : bg,
        borderRadius: BorderRadius.circular(SoftClawRadii.md),
        boxShadow: disabled ? const <BoxShadow>[] : glow,
        gradient: primary
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(isDark ? 0.2 : 0.18),
                  Colors.transparent,
                ],
              )
            : null,
      ),
      child: Row(
        mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.loading)
            SizedBox(
              width: 16, height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation(fg),
              ),
            )
          else if (widget.icon != null) ...[
            Icon(widget.icon, size: 18, color: fg),
            const SizedBox(width: 8),
          ],
          if (!widget.loading)
            Text(
              widget.label,
              style: GoogleFonts.baloo2(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: fg,
                letterSpacing: 0.2,
              ),
            ),
        ],
      ),
    );

    return Listener(
      onPointerDown: (_) {
        if (!disabled) setState(() => _pressed = true);
      },
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: GestureDetector(
        onTap: disabled ? null : widget.onPressed,
        child: btn,
      ),
    );
  }
}

// ─── ClayTextField ─────────────────────────────────────────────────────────
class ClayTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final void Function(String)? onChanged;

  const ClayTextField({
    super.key,
    this.label,
    this.hint,
    this.prefixIcon,
    this.controller,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? SoftClawPalette.inkDark500 : SoftClawPalette.ink500;
    final iconColor  = isDark ? SoftClawPalette.inkDark500 : SoftClawPalette.ink500;
    final textColor  = isDark ? SoftClawPalette.inkDark900 : SoftClawPalette.ink900;
    final fieldBg    = isDark ? SoftClawPalette.paperDark : SoftClawPalette.paper;
    final fieldEdge  = isDark ? SoftClawPalette.clayEdgeDark : SoftClawPalette.clayEdge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 8),
            child: Text(
              label!,
              style: GoogleFonts.baloo2(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: labelColor,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: fieldBg,
            borderRadius: BorderRadius.circular(SoftClawRadii.md),
            boxShadow: SoftClawShadows.clayInset,
            border: Border.all(color: fieldEdge, width: 1),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            obscureText: obscureText,
            onChanged: onChanged,
            style: GoogleFonts.inter(
              fontSize: 15, color: textColor, fontWeight: FontWeight.w500,
            ),
            cursorColor: SoftClawPalette.cyan700,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                color: labelColor.withOpacity(0.6),
                fontSize: 14,
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: iconColor, size: 20)
                  : null,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── ClayChip ──────────────────────────────────────────────────────────────
class ClayChip extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? background;
  final IconData? icon;
  final bool small;

  const ClayChip({
    super.key,
    required this.label,
    this.color,
    this.background,
    this.icon,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? SoftClawPalette.cyan700;
    final bg = background ?? c.withOpacity(0.12);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(SoftClawRadii.xs),
        border: Border.all(color: c.withOpacity(0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: small ? 10 : 12, color: c),
            SizedBox(width: small ? 3 : 4),
          ],
          Text(
            label,
            style: GoogleFonts.baloo2(
              color: c,
              fontWeight: FontWeight.w800,
              fontSize: small ? 10 : 11,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── ClayIconBadge ────────────────────────────────────────────────────────
class ClayIconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final List<BoxShadow>? shadows;

  const ClayIconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 48,
    this.iconSize = 22,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.95), color.withOpacity(0.75)],
        ),
        borderRadius: BorderRadius.circular(size * 0.32),
        boxShadow: shadows ?? [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
          const BoxShadow(
            color: Color(0x55FFFFFF),
            offset: Offset(-2, -2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glossy highlight
          Positioned(
            top: 4, left: 6, right: 6,
            child: Container(
              height: size * 0.18,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.35),
                borderRadius: BorderRadius.circular(size),
              ),
            ),
          ),
          Icon(icon, color: Colors.white, size: iconSize),
        ],
      ),
    );
  }
}

// ─── ClayProgressBar ──────────────────────────────────────────────────────
class ClayProgressBar extends StatelessWidget {
  final double value; // 0..1
  final Color color;
  final double height;
  final String? trailingLabel;

  const ClayProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.height = 10,
    this.trailingLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackColor = isDark
        ? Colors.white.withOpacity(0.06)
        : SoftClawPalette.clayEdge;
    return Stack(
      children: [
        // Track (inset)
        Container(
          height: height,
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(height),
            boxShadow: SoftClawShadows.clayInset,
          ),
        ),
        // Filled (raised)
        LayoutBuilder(builder: (ctx, c) {
          return AnimatedContainer(
            duration: SoftClawMotion.slow,
            curve: SoftClawMotion.easeOut,
            height: height,
            width: (c.maxWidth * value.clamp(0, 1)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.95), color.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(height),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

// ─── ClaySectionHeader ────────────────────────────────────────────────────
class ClaySectionHeader extends StatelessWidget {
  final String title;
  final String? eyebrow;
  final IconData? icon;
  final Widget? trailing;

  const ClaySectionHeader({
    super.key,
    required this.title,
    this.eyebrow,
    this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? SoftClawPalette.cyan300 : SoftClawPalette.cyan700;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          ClayIconBadge(
            icon: icon!,
            color: accent,
            size: 36, iconSize: 16,
            shadows: [
              BoxShadow(
                color: accent.withOpacity(0.35),
                blurRadius: 12, offset: const Offset(0, 4),
              ),
            ],
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eyebrow != null)
                Text(
                  eyebrow!.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: accent,
                    letterSpacing: 1.6,
                  ),
                ),
              Text(
                title,
                style: GoogleFonts.baloo2(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -0.5,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
