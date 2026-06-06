// Studio input: spec §3.6.
// Thin wrapper around TextField wired to the theme's inputDecoration.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/studio_tokens.dart';
import '../../theme/studio_typography.dart';

class StudioInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final String? errorText;
  final bool monospace;
  final ValueChanged<String>? onChanged;
  final bool obscureText;

  const StudioInput({
    super.key,
    this.controller,
    this.hint,
    this.errorText,
    this.monospace = false,
    this.onChanged,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            obscureText: obscureText,
            style: monospace
                ? StudioTypography.monoSmall().copyWith(
                    fontSize: 14,
                    color: StudioColors.textSecondary,
                  )
                : StudioTypography.body(),
            cursorColor: StudioColors.accentPrimary,
            decoration: InputDecoration(
              hintText: hint,
              isDense: true,
              // errorText is rendered separately below in semantic danger
              // per spec §3.6, not via InputDecoration's built-in error.
              errorText: null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: StudioSpacing.s3,
                vertical: 10,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: StudioSpacing.s1),
            child: Text(
              errorText!,
              style: StudioTypography.caption().copyWith(
                color: StudioColors.semanticDanger,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
            ),
          ),
      ],
    );
  }
}
