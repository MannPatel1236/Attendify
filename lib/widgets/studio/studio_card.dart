// Studio card: spec §3.7. Used sparingly.

import 'package:flutter/material.dart';
import '../../theme/studio_tokens.dart';

class StudioCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const StudioCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: StudioColors.accentPrimaryDim,
      hoverColor: StudioColors.accentPrimaryDim,
      child: Container(
        decoration: BoxDecoration(
          color: StudioColors.surfaceRaised,
          border: Border.all(color: StudioColors.borderSubtle, width: 1),
          borderRadius: BorderRadius.zero, // spec §2.3: sharp corners
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}
