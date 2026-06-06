import 'package:flutter/material.dart';
import 'dart:ui';

class MonolithColors {
  // Richer, slate-tinted darks for depth instead of flat black
  static const Color lowest = Color(0xFF0A0C10);
  static const Color surface = Color(0xFF13151A);
  static const Color low = Color(0xFF1C1F26);
  static const Color high = Color(0xFF282C37);
  
  // Softer, sophisticated primary blue
  static const Color primary = Color(0xFF4361EE);
  static const Color onPrimary = Color(0xFFFFFFFF);
  
  // Vibrant but slightly softer cyan for accents
  static const Color tertiary = Color(0xFF00E5FF);
  
  // Softer text colors to prevent harsh high contrast
  static const Color onSurface = Color(0xFFCDD0DB);
  static const Color outline = Color(0xFF62687F);
}

class MonolithCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final bool asymmetric;

  const MonolithCard({
    super.key,
    required this.child,
    this.color,
    this.padding,
    this.asymmetric = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? (asymmetric 
          ? const EdgeInsets.fromLTRB(24, 24, 48, 24) 
          : const EdgeInsets.all(24)),
      decoration: BoxDecoration(
        color: color ?? MonolithColors.surface,
        borderRadius: BorderRadius.circular(12), // 0.75rem (xl)
      ),
      child: child,
    );
  }
}

class MonolithButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const MonolithButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6), // 0.375rem (md)
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          gradient: isPrimary ? const LinearGradient(
            colors: [Color(0xFF4361EE), Color(0xFF3F37C9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ) : null,
          color: isPrimary ? null : MonolithColors.high,
          borderRadius: BorderRadius.circular(6),
          border: isPrimary ? null : Border.all(color: MonolithColors.outline.withOpacity(0.15)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isPrimary ? MonolithColors.onPrimary : MonolithColors.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}

class MonolithGlass extends StatelessWidget {
  final Widget child;
  const MonolithGlass({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: MonolithColors.low.withOpacity(0.7),
          child: child,
        ),
      ),
    );
  }
}

class DataMonolith extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;

  const DataMonolith({
    super.key,
    required this.value,
    required this.label,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 48, // display-sm
            fontWeight: FontWeight.w800,
            color: valueColor ?? MonolithColors.primary,
            letterSpacing: -1.0,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12, // label-sm
            fontWeight: FontWeight.w600,
            color: MonolithColors.outline,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
