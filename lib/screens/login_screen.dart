import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/softclaw_theme.dart';
import '../widgets/clay_widgets.dart';

/// ═══════════════════════════════════════════════════════════════════════════
///  Login Screen — SoftClaw design system
///
///  Composition:
///    • Background: layered gradient + decorative clay orbs (atmospheric depth)
///    • Hero: large app wordmark, 3D clay logo, animated entrance
///    • Role selector: two clay cards (Student / Teacher) with hover-press
///    • Footer: theme toggle, version stamp
///
///  Differentiator: a soft drifting orb behind the logo, with the logo
///  appearing to push through the surface (offset shadow + glass blur).
/// ═══════════════════════════════════════════════════════════════════════════

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late final AnimationController _intro;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final AnimationController _orbFloat;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1100),
    )..forward();
    _fade = CurvedAnimation(parent: _intro, curve: SoftClawMotion.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _intro, curve: SoftClawMotion.easeOut),
    );
    _orbFloat = AnimationController(
      vsync: this, duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _intro.dispose();
    _orbFloat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? SoftClawPalette.paperDark : SoftClawPalette.paper;
    final ink = Theme.of(context).colorScheme.onSurface;
    final muted = ink.withOpacity(0.6);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // ── Drifting background orbs ───────────────────────────────────
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _orbFloat,
              builder: (_, __) => Stack(
                children: [
                  Positioned(
                    top: -60 + (_orbFloat.value * 20),
                    left: -50 + (_orbFloat.value * 15),
                    child: _GlowOrb(
                      size: 280, color: SoftClawPalette.cyan500,
                      opacity: isDark ? 0.16 : 0.22,
                    ),
                  ),
                  Positioned(
                    bottom: -80 - (_orbFloat.value * 25),
                    right: -60 + (_orbFloat.value * 20),
                    child: _GlowOrb(
                      size: 320, color: SoftClawPalette.green500,
                      opacity: isDark ? 0.10 : 0.16,
                    ),
                  ),
                  Positioned(
                    top: 200 + (_orbFloat.value * 30),
                    right: 80 - (_orbFloat.value * 20),
                    child: _GlowOrb(
                      size: 140, color: SoftClawPalette.cyan300,
                      opacity: isDark ? 0.10 : 0.18,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Foreground content ─────────────────────────────────────────
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(
                    position: _slide,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 24),
                          _buildHero(ink, muted),
                          const SizedBox(height: 48),
                          _buildRoleHeader(ink, muted),
                          const SizedBox(height: 16),
                          _RoleCard(
                            title: "Student Portal",
                            subtitle: "Track your attendance, recovery targets & safe skips",
                            icon: Icons.school_rounded,
                            accent: SoftClawPalette.cyan700,
                            accentGlow: SoftClawPalette.cyan500,
                            onTap: () => context.read<AppState>().loginAsStudent(),
                          ),
                          const SizedBox(height: 14),
                          _RoleCard(
                            title: "Teacher Portal",
                            subtitle: "Take roll call, upload proxy letters & view reports",
                            icon: Icons.admin_panel_settings_rounded,
                            accent: SoftClawPalette.green500,
                            accentGlow: SoftClawPalette.green300,
                            onTap: () => context.read<AppState>().loginAsTeacher(),
                          ),
                          const SizedBox(height: 40),
                          _buildFooter(ink, muted),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero ────────────────────────────────────────────────────────────────
  Widget _buildHero(Color ink, Color muted) {
    return Column(
      children: [
        // 3D clay logo mark
        Container(
          width: 96, height: 96,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [
                Color(0xFF22D3EE),
                Color(0xFF0891B2),
                Color(0xFF0E7490),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: SoftClawPalette.cyan500.withOpacity(0.55),
                blurRadius: 32, spreadRadius: -4, offset: const Offset(0, 16),
              ),
              const BoxShadow(
                color: Color(0x88FFFFFF),
                offset: Offset(-3, -3), blurRadius: 8,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Glassy highlight
              Positioned(
                top: 8, left: 12, right: 12,
                child: Container(
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              // Check mark — the universal "present" symbol
              const Center(
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 52,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        // Wordmark
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Attend",
                style: GoogleFonts.baloo2(
                  fontSize: 44, fontWeight: FontWeight.w800,
                  color: ink, letterSpacing: -1.5, height: 1.0,
                ),
              ),
              TextSpan(
                text: "ify",
                style: GoogleFonts.baloo2(
                  fontSize: 44, fontWeight: FontWeight.w800,
                  color: SoftClawPalette.cyan700,
                  letterSpacing: -1.5, height: 1.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Smart attendance, beautifully tracked.",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14, color: muted, fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleHeader(Color ink, Color muted) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Container(
            width: 24, height: 2,
            decoration: BoxDecoration(
              color: SoftClawPalette.cyan500,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "CHOOSE YOUR PORTAL",
            style: GoogleFonts.inter(
              fontSize: 11, fontWeight: FontWeight.w700,
              color: muted, letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(Color ink, Color muted) {
    final appState = context.watch<AppState>();
    return Column(
      children: [
        // Theme pill
        GestureDetector(
          onTap: () => appState.toggleTheme(),
          child: ClayCard(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            radius: SoftClawRadii.pill,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(appState.themeIcon, size: 16, color: SoftClawPalette.cyan700),
                const SizedBox(width: 8),
                Text(
                  "Theme  ·  ${appState.themeLabel}",
                  style: GoogleFonts.baloo2(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: ink, letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          "Built with care · v1.0.0",
          style: GoogleFonts.inter(
            fontSize: 11, color: muted.withOpacity(0.6),
            fontWeight: FontWeight.w500, letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// ── Role card ─────────────────────────────────────────────────────────────
class _RoleCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final Color accentGlow;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.accentGlow,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    final muted = ink.withOpacity(0.65);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: SoftClawMotion.medium,
        curve: SoftClawMotion.easeOut,
        transform: _hovered
            ? (Matrix4.identity()..translate(0, -3, 0))
            : Matrix4.identity(),
        child: ClayCard(
          onTap: widget.onTap,
          padding: const EdgeInsets.all(20),
          radius: SoftClawRadii.lg,
          child: Row(
            children: [
              ClayIconBadge(
                icon: widget.icon,
                color: widget.accent,
                size: 56, iconSize: 26,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.baloo2(
                        fontSize: 18, fontWeight: FontWeight.w800,
                        color: ink, letterSpacing: -0.3, height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12, color: muted,
                        fontWeight: FontWeight.w500, height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: SoftClawMotion.medium,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.accent.withOpacity(_hovered ? 0.18 : 0.0),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color: widget.accent.withOpacity(_hovered ? 1.0 : 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Decorative glow orb ───────────────────────────────────────────────────
class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _GlowOrb({required this.size, required this.color, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withOpacity(opacity),
              color.withOpacity(0),
            ],
          ),
        ),
      ),
    );
  }
}
