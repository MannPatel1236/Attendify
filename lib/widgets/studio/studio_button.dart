// Studio button: 3 variants per spec §3.3.

import 'package:flutter/material.dart';
import '../../theme/studio_tokens.dart';
import '../../theme/studio_typography.dart';

enum StudioButtonVariant { primary, secondary, destructive }

class StudioButton extends StatelessWidget {
  final String label;
  final StudioButtonVariant variant;
  final VoidCallback? onPressed;
  // Test-only hook: if onPressed is null, this is called instead so
  // the disabled-state test can verify taps don't fire.
  final VoidCallback? onPressedWhenDisabled;
  final Widget? leadingIcon;
  final bool fullWidth;

  const StudioButton({
    super.key,
    required this.label,
    this.variant = StudioButtonVariant.primary,
    this.onPressed,
    this.onPressedWhenDisabled,
    this.leadingIcon,
    this.fullWidth = false,
  });

  Color get _bg {
    if (onPressed == null) return StudioColors.surfaceRaised;
    switch (variant) {
      case StudioButtonVariant.primary:
        return StudioColors.accentPrimary;
      case StudioButtonVariant.secondary:
        return Colors.transparent;
      case StudioButtonVariant.destructive:
        return StudioColors.semanticDanger;
    }
  }

  Color get _fg {
    if (onPressed == null) return StudioColors.textMuted;
    return StudioColors.textPrimary;
  }

  Border? get _border {
    if (variant == StudioButtonVariant.secondary) {
      return Border.all(color: StudioColors.borderSubtle, width: 1);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed ?? onPressedWhenDisabled,
        borderRadius: BorderRadius.circular(StudioRadii.control),
        child: Container(
          height: 40,
          width: fullWidth ? double.infinity : null,
          decoration: BoxDecoration(
            color: _bg,
            border: _border,
            borderRadius: BorderRadius.circular(StudioRadii.control),
          ),
          padding: const EdgeInsets.symmetric(horizontal: StudioSpacing.s4),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                leadingIcon!,
                const SizedBox(width: StudioSpacing.s2),
              ],
              Flexible(
                child: Text(
                  label,
                  style: StudioTypography.button().copyWith(color: _fg),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
