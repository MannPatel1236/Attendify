import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../models/timetable_model.dart';
import '../models/student_model.dart';
import '../models/subject_model.dart' as model;
import '../theme/softclaw_theme.dart';
import '../widgets/clay_widgets.dart';
import '../widgets/attendance_gauges.dart';
import 'manual_timetable_screen.dart';

/// ═══════════════════════════════════════════════════════════════════════════
///  Student Dashboard — SoftClaw
///
///  Four tabs:
///    1. Overview       — hero gauge, mini stats, action cards, breakdown
///    2. Subjects       — clay subject cards with circular gauges
///    3. Timetable      — daily grid with self-mark buttons
///    4. Skip Advisor   — smart skip-day suggestions with safety badges
///
///  All tabs use shared SoftClaw components for visual consistency.
/// ═══════════════════════════════════════════════════════════════════════════

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final Map<String, bool?> _todayMarks = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadTodayMarks();
  }

  Future<void> _loadTodayMarks() async {
    final appState = context.read<AppState>();
    final marks = await appState.loadTodayMarks();
    if (mounted && marks.isNotEmpty) {
      setState(() => _todayMarks.addAll(marks));
    }
  }

  void _persistMarks() {
    context.read<AppState>().saveTodayMarks(_todayMarks);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final student = appState.currentStudent;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).scaffoldBackgroundColor;

    if (student == null) {
      return Scaffold(
        backgroundColor: bg,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(student, appState),
            const SizedBox(height: 12),
            _buildPillTabs(),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  _OverviewTab(student: student, appState: appState, goToTimetable: () => _tabController.animateTo(2)),
                  _SubjectsTab(student: student, appState: appState),
                  _TimetableTab(appState: appState, todayMarks: _todayMarks, onMarksChanged: () => setState(() {}), persistMarks: _persistMarks),
                  _SkipAdvisorTab(appState: appState),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(Student student, AppState appState) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ink = Theme.of(context).colorScheme.onSurface;
    final muted = ink.withOpacity(0.6);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          // Mini clay logo
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFF22D3EE), Color(0xFF0891B2)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: SoftClawPalette.cyan500.withOpacity(0.35),
                  blurRadius: 12, offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting(),
                  style: GoogleFonts.inter(
                    fontSize: 11, fontWeight: FontWeight.w600,
                    color: muted, letterSpacing: 0.5,
                  ),
                ),
                Text(
                  student.name,
                  style: GoogleFonts.baloo2(
                    fontSize: 22, fontWeight: FontWeight.w800,
                    color: ink, letterSpacing: -0.5, height: 1.0,
                  ),
                ),
              ],
            ),
          ),
          // Theme toggle
          _IconPill(
            icon: appState.themeIcon,
            onTap: () => appState.toggleTheme(),
            tooltip: "Theme: ${appState.themeLabel}",
          ),
          const SizedBox(width: 8),
          _IconPill(
            icon: Icons.logout_rounded,
            onTap: () => appState.logout(),
            tooltip: "Sign out",
            danger: true,
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "GOOD MORNING";
    if (hour < 17) return "GOOD AFTERNOON";
    return "GOOD EVENING";
  }

  Widget _buildPillTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(SoftClawRadii.pill),
          boxShadow: SoftClawShadows.clayInset,
        ),
        child: TabBar(
          controller: _tabController,
          isScrollable: false,
          labelColor: Colors.white,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          indicator: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFF22D3EE), Color(0xFF0891B2)],
            ),
            borderRadius: BorderRadius.circular(SoftClawRadii.pill),
            boxShadow: [
              BoxShadow(
                color: SoftClawPalette.cyan500.withOpacity(0.4),
                blurRadius: 10, offset: const Offset(0, 4),
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelStyle: GoogleFonts.baloo2(
            fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.1,
          ),
          unselectedLabelStyle: GoogleFonts.baloo2(
            fontWeight: FontWeight.w600, fontSize: 12, letterSpacing: 0.1,
          ),
          tabs: const [
            Tab(text: "Overview", height: 36),
            Tab(text: "Subjects", height: 36),
            Tab(text: "Timetable", height: 36),
            Tab(text: "Skip Advisor", height: 36),
          ],
        ),
      ),
    );
  }
}

// ── Top bar icon button ──────────────────────────────────────────────────
class _IconPill extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final bool danger;
  const _IconPill({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = danger
        ? SoftClawPalette.red500
        : (isDark ? SoftClawPalette.inkDark700 : SoftClawPalette.ink500);
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: SoftClawShadows.clayPressed,
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  TAB 1 — OVERVIEW
// ═══════════════════════════════════════════════════════════════════════════
class _OverviewTab extends StatefulWidget {
  final Student student;
  final AppState appState;
  final VoidCallback goToTimetable;
  const _OverviewTab({
    required this.student,
    required this.appState,
    required this.goToTimetable,
  });

  @override
  State<_OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<_OverviewTab> {
  bool _isUploadingTimetable = false;
  bool _isUploadingHod = false;

  @override
  Widget build(BuildContext context) {
    final student = widget.student;
    final appState = widget.appState;
    final pct = student.overallAttendance;
    final isSafe = pct >= 75.0;
    final totalCanSkip = student.subjects.values.fold<int>(0, (s, sub) => s + sub.canSkip);
    final totalNeed = student.subjects.values
        .where((s) => s.percentage < 75)
        .fold<int>(0, (s, sub) => s + sub.classesToAttend);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (appState.isTodayHoliday) const SizedBox(height: 12),
          if (appState.isTodayHoliday) _HolidayBanner(appState: appState),
          if (appState.isTodayHoliday) const SizedBox(height: 16),
          _buildHeroCard(pct, isSafe),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _MiniStat(label: "Subjects", value: "${student.subjects.length}", icon: Icons.menu_book_rounded, accent: SoftClawPalette.cyan700)),
              const SizedBox(width: 12),
              Expanded(child: _MiniStat(label: "Can Skip", value: "$totalCanSkip", icon: Icons.beach_access_rounded, accent: SoftClawPalette.green500)),
              const SizedBox(width: 12),
              Expanded(child: _MiniStat(label: "Need", value: "$totalNeed", icon: Icons.priority_high_rounded, accent: SoftClawPalette.amber500)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _ActionCard(
                title: "Mark Today",
                subtitle: "Self-mark attendance",
                icon: Icons.touch_app_rounded,
                gradient: const [Color(0xFF22D3EE), Color(0xFF0891B2)],
                onTap: widget.goToTimetable,
              )),
              const SizedBox(width: 12),
              _HolidayToggle(appState: appState),
            ],
          ),
          const SizedBox(height: 20),
          ClaySectionHeader(
            eyebrow: "BREAKDOWN",
            title: "Subject Attendance",
            icon: Icons.insights_rounded,
          ),
          const SizedBox(height: 12),
          _BreakdownCard(student: student),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _ActionCard(
                title: _isUploadingTimetable ? "Uploading…" : "Scan Timetable",
                subtitle: _isUploadingTimetable ? "Please wait" : "Upload photo",
                icon: _isUploadingTimetable ? Icons.hourglass_top_rounded : Icons.document_scanner_rounded,
                gradient: const [Color(0xFF06B6D4), Color(0xFF0E7490)],
                compact: true,
                onTap: _isUploadingTimetable ? () {} : _uploadTimetable,
              )),
              const SizedBox(width: 12),
              Expanded(child: _ActionCard(
                title: _isUploadingHod ? "Uploading…" : "HOD Letter",
                subtitle: _isUploadingHod ? "Please wait" : "Proxy doc",
                icon: _isUploadingHod ? Icons.hourglass_top_rounded : Icons.verified_user_rounded,
                gradient: const [Color(0xFF10B981), Color(0xFF047857)],
                compact: true,
                onTap: _isUploadingHod ? () {} : _uploadHod,
              )),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _uploadTimetable() async {
    setState(() => _isUploadingTimetable = true);
    final success = await widget.appState.uploadAndExtractTimetable();
    if (!mounted) return;
    setState(() => _isUploadingTimetable = false);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Timetable uploaded!")),
      );
    } else {
      Navigator.push(
        context, MaterialPageRoute(builder: (_) => const ManualTimetableScreen()),
      );
    }
  }

  Future<void> _uploadHod() async {
    setState(() => _isUploadingHod = true);
    await widget.appState.uploadHodLetter();
    if (!mounted) return;
    setState(() => _isUploadingHod = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("HOD Letter uploaded!")),
    );
  }

  Widget _buildHeroCard(double pct, bool isSafe) {
    return ClayCard(
      padding: const EdgeInsets.all(24),
      radius: SoftClawRadii.xl,
      child: Row(
        children: [
          HeroAttendanceGauge(
            percent: pct, isSafe: isSafe, size: 160,
            subtitle: "OVERALL",
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isSafe ? "On Track" : "Needs Care",
                  style: GoogleFonts.baloo2(
                    fontSize: 26, fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: -0.6, height: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isSafe
                      ? "Keep showing up. You're safely above the 75% line."
                      : "Below the 75% line. Attend the next few classes to recover.",
                  style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                _StatusPill(safe: isSafe),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool safe;
  const _StatusPill({required this.safe});
  @override
  Widget build(BuildContext context) {
    final c = safe
        ? (Theme.of(context).brightness == Brightness.dark
            ? SoftClawPalette.green300
            : SoftClawPalette.green500)
        : SoftClawPalette.amber500;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.16),
        borderRadius: BorderRadius.circular(SoftClawRadii.xs),
        border: Border.all(color: c.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(safe ? Icons.bolt_rounded : Icons.warning_rounded, color: c, size: 14),
          const SizedBox(width: 4),
          Text(
            safe ? "Safe zone" : "Recovery needed",
            style: GoogleFonts.baloo2(
              color: c, fontWeight: FontWeight.w800,
              fontSize: 11, letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color accent;
  const _MiniStat({
    required this.label, required this.value,
    required this.icon, required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    return ClayCard(
      padding: const EdgeInsets.all(14),
      radius: SoftClawRadii.md,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.baloo2(
              fontSize: 24, fontWeight: FontWeight.w800,
              color: ink, height: 1.0, letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11, fontWeight: FontWeight.w600,
              color: ink.withOpacity(0.6), letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;
  final bool compact;
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SoftClawRadii.lg),
        child: Container(
          padding: EdgeInsets.all(compact ? 16 : 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(SoftClawRadii.lg),
            boxShadow: [
              BoxShadow(
                color: gradient.last.withOpacity(0.4),
                blurRadius: 16, offset: const Offset(0, 8),
              ),
              const BoxShadow(
                color: Color(0x66FFFFFF),
                offset: Offset(-2, -2), blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: compact ? 20 : 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.baloo2(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: compact ? 14 : 16,
                        height: 1.1, letterSpacing: -0.2,
                      ),
                    ),
                    if (!compact) const SizedBox(height: 2),
                    if (!compact) Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 11, fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded, size: 18,
                color: Colors.white.withOpacity(0.85),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HolidayBanner extends StatelessWidget {
  final AppState appState;
  const _HolidayBanner({required this.appState});
  @override
  Widget build(BuildContext context) {
    return ClayCard(
      color: SoftClawPalette.amber500.withOpacity(0.16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      radius: SoftClawRadii.md,
      child: Row(
        children: [
          ClayIconBadge(
            icon: Icons.beach_access_rounded,
            color: SoftClawPalette.amber500,
            size: 40, iconSize: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today is a Holiday!",
                  style: GoogleFonts.baloo2(
                    fontWeight: FontWeight.w800, fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  "No lectures will be counted today.",
                  style: GoogleFonts.inter(
                    fontSize: 11, fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.65),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
            onPressed: () => appState.unmarkTodayAsHoliday(),
          ),
        ],
      ),
    );
  }
}

class _HolidayToggle extends StatefulWidget {
  final AppState appState;
  const _HolidayToggle({required this.appState});

  @override
  State<_HolidayToggle> createState() => _HolidayToggleState();
}

class _HolidayToggleState extends State<_HolidayToggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300),
    )..value = widget.appState.isTodayHoliday ? 1.0 : 0.0;
  }

  @override
  void didUpdateWidget(covariant _HolidayToggle old) {
    super.didUpdateWidget(old);
    if (widget.appState.isTodayHoliday) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isHoliday = widget.appState.isTodayHoliday;
    final c = isHoliday ? SoftClawPalette.amber500 : SoftClawPalette.ink300;
    return GestureDetector(
      onTap: () => widget.appState.toggleTodayHoliday(),
      child: AnimatedContainer(
        duration: SoftClawMotion.medium,
        curve: SoftClawMotion.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isHoliday
              ? SoftClawPalette.amber500.withOpacity(0.18)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(SoftClawRadii.lg),
          boxShadow: isHoliday
              ? [
                  BoxShadow(
                    color: SoftClawPalette.amber500.withOpacity(0.30),
                    blurRadius: 14, offset: const Offset(0, 6),
                  ),
                ]
              : SoftClawShadows.clayPressed,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isHoliday ? Icons.celebration_rounded : Icons.beach_access_rounded,
              color: c, size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              isHoliday ? "Holiday" : "Off Day",
              style: GoogleFonts.baloo2(
                color: c, fontWeight: FontWeight.w800,
                fontSize: 11, letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  final Student student;
  const _BreakdownCard({required this.student});

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    final subjects = student.subjects.values.toList()
      ..sort((a, b) => b.percentage.compareTo(a.percentage));
    return ClayCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          for (int i = 0; i < subjects.length; i++) ...[
            _BreakdownRow(subject: subjects[i]),
            if (i != subjects.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  height: 1,
                  color: ink.withOpacity(0.06),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final model.Subject subject;
  const _BreakdownRow({required this.subject});

  @override
  Widget build(BuildContext context) {
    final pct = subject.percentage;
    final isSafe = pct >= 75.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isSafe
        ? (isDark ? SoftClawPalette.green300 : SoftClawPalette.green500)
        : (isDark ? const Color(0xFFFBBF24) : SoftClawPalette.amber500);
    final ink = Theme.of(context).colorScheme.onSurface;
    final muted = ink.withOpacity(0.6);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject.name,
                style: GoogleFonts.baloo2(
                  fontWeight: FontWeight.w700, fontSize: 14,
                  color: ink, letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 6),
              ClayProgressBar(value: (pct / 100).clamp(0.0, 1.0), color: accent, height: 6),
              const SizedBox(height: 4),
              Text(
                "${subject.attended} of ${subject.total} attended",
                style: GoogleFonts.inter(
                  fontSize: 10, fontWeight: FontWeight.w500,
                  color: muted, letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${pct.toStringAsFixed(0)}%",
              style: GoogleFonts.baloo2(
                fontWeight: FontWeight.w800, fontSize: 20,
                color: accent, height: 1.0, letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            if (isSafe)
              ClayChip(
                label: "Skip ${subject.canSkip}",
                color: accent, small: true, icon: Icons.beach_access_rounded,
              )
            else
              ClayChip(
                label: "Need ${subject.classesToAttend}",
                color: SoftClawPalette.amber500, small: true,
                icon: Icons.priority_high_rounded,
              ),
          ],
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  TAB 2 — SUBJECTS
// ═══════════════════════════════════════════════════════════════════════════
class _SubjectsTab extends StatelessWidget {
  final Student student;
  final AppState appState;
  const _SubjectsTab({required this.student, required this.appState});

  @override
  Widget build(BuildContext context) {
    final subjects = student.subjects.entries.toList()
      ..sort((a, b) => b.value.percentage.compareTo(a.value.percentage));

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      itemCount: subjects.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ClaySectionHeader(
              eyebrow: "ALL SUBJECTS",
              title: "${subjects.length} Active",
              icon: Icons.menu_book_rounded,
            ),
          );
        }
        final entry = subjects[i - 1];
        return _SubjectCard(
          subjectKey: entry.key,
          subject: entry.value,
          onTap: () => _showEditDialog(context, entry.key, entry.value),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, String key, model.Subject sub) {
    final attendedCtrl = TextEditingController(text: sub.attended.toString());
    final totalCtrl = TextEditingController(text: sub.total.toString());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SoftClawRadii.lg)),
        title: Row(
          children: [
            ClayIconBadge(
              icon: Icons.edit_rounded,
              color: SoftClawPalette.cyan700,
              size: 32, iconSize: 14,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Edit ${sub.name}",
                style: GoogleFonts.baloo2(
                  fontWeight: FontWeight.w800, fontSize: 17,
                  color: Theme.of(ctx).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Match your official records.",
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Theme.of(ctx).colorScheme.onSurface.withOpacity(0.65),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(child: ClayTextField(
                  label: "Attended",
                  controller: attendedCtrl,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.check_circle_outline_rounded,
                )),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("/", style: TextStyle(fontSize: 22)),
                ),
                Expanded(child: ClayTextField(
                  label: "Total",
                  controller: totalCtrl,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.format_list_numbered_rounded,
                )),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: GoogleFonts.baloo2(
              fontWeight: FontWeight.w700,
              color: Theme.of(ctx).colorScheme.onSurface.withOpacity(0.6),
            )),
          ),
          ClayButton(
            label: "Save",
            primary: true,
            icon: Icons.check_rounded,
            onPressed: () {
              final a = int.tryParse(attendedCtrl.text);
              final t = int.tryParse(totalCtrl.text);
              if (a == null || t == null || a < 0 || t < 0) {
                _err(context, "Please enter valid numbers");
                return;
              }
              if (a > t) {
                _err(context, "Attended can't exceed total");
                return;
              }
              appState.updateAttendance(key, a, t);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${sub.name} updated to $a/$t")),
              );
            },
          ),
        ],
      ),
    );
  }

  void _err(BuildContext c, String m) {
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(m)));
  }
}

class _SubjectCard extends StatelessWidget {
  final String subjectKey;
  final model.Subject subject;
  final VoidCallback onTap;
  const _SubjectCard({
    required this.subjectKey,
    required this.subject,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pct = subject.percentage;
    final isSafe = pct >= 75.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isSafe
        ? (isDark ? SoftClawPalette.green300 : SoftClawPalette.green500)
        : (isDark ? const Color(0xFFFBBF24) : SoftClawPalette.amber500);
    final ink = Theme.of(context).colorScheme.onSurface;
    return ClayCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CompactSubjectRing(percent: pct, isSafe: isSafe, size: 58),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  style: GoogleFonts.baloo2(
                    fontWeight: FontWeight.w800, fontSize: 15,
                    color: ink, letterSpacing: -0.3, height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${subject.attended} / ${subject.total} classes attended",
                  style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w500,
                    color: ink.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (isSafe)
                      ClayChip(
                        label: "Skip ${subject.canSkip}",
                        color: accent, small: true,
                        icon: Icons.beach_access_rounded,
                      )
                    else
                      ClayChip(
                        label: "Need ${subject.classesToAttend}",
                        color: SoftClawPalette.amber500, small: true,
                        icon: Icons.priority_high_rounded,
                      ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.edit_rounded, size: 16,
            color: ink.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  TAB 3 — TIMETABLE
// ═══════════════════════════════════════════════════════════════════════════
class _TimetableTab extends StatefulWidget {
  final AppState appState;
  final Map<String, bool?> todayMarks;
  final VoidCallback onMarksChanged;
  final VoidCallback persistMarks;
  const _TimetableTab({
    required this.appState,
    required this.todayMarks,
    required this.onMarksChanged,
    required this.persistMarks,
  });

  @override
  State<_TimetableTab> createState() => _TimetableTabState();
}

class _TimetableTabState extends State<_TimetableTab>
    with SingleTickerProviderStateMixin {
  late final TabController _dayCtrl;
  @override
  void initState() {
    super.initState();
    final todayIdx = (DateTime.now().weekday - 1).clamp(0, 4);
    _dayCtrl = TabController(length: weeklyTimetable.length, vsync: this, initialIndex: todayIdx);
  }

  @override
  void dispose() { _dayCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final todayIdx = DateTime.now().weekday - 1;
    final isTodayHoliday = widget.appState.isTodayHoliday;
    final ink = Theme.of(context).colorScheme.onSurface;
    final muted = ink.withOpacity(0.65);

    return Column(
      children: [
        if (isTodayHoliday)
          Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: SoftClawPalette.amber500.withOpacity(0.16),
              borderRadius: BorderRadius.circular(SoftClawRadii.md),
              border: Border.all(color: SoftClawPalette.amber500.withOpacity(0.35)),
            ),
            child: Row(
              children: [
                Icon(Icons.beach_access_rounded, color: SoftClawPalette.amber500, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Holiday — attendance marking disabled.",
                    style: GoogleFonts.baloo2(
                      fontWeight: FontWeight.w700, fontSize: 12,
                      color: ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        // Day strip
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Row(
            children: List.generate(weeklyTimetable.length, (i) {
              final day = weeklyTimetable[i];
              final isToday = i == todayIdx;
              final selected = _dayCtrl.index == i;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: GestureDetector(
                    onTap: () => _dayCtrl.animateTo(i),
                    child: AnimatedContainer(
                      duration: SoftClawMotion.fast,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: selected
                            ? SoftClawPalette.cyan500.withOpacity(isDark ? 0.22 : 0.18)
                            : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(SoftClawRadii.sm),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: SoftClawPalette.cyan500.withOpacity(0.3),
                                  blurRadius: 10, offset: const Offset(0, 4),
                                ),
                              ]
                            : SoftClawShadows.clayInset,
                      ),
                      child: Column(
                        children: [
                          Text(
                            day.dayName.substring(0, 3).toUpperCase(),
                            style: GoogleFonts.baloo2(
                              fontWeight: FontWeight.w800,
                              fontSize: 12, letterSpacing: 0.5,
                              color: selected
                                  ? SoftClawPalette.cyan700
                                  : muted,
                            ),
                          ),
                          if (isToday) ...[
                            const SizedBox(height: 4),
                            Container(
                              width: 5, height: 5,
                              decoration: const BoxDecoration(
                                color: SoftClawPalette.cyan500,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _dayCtrl,
            physics: const BouncingScrollPhysics(),
            children: weeklyTimetable.asMap().entries.map((entry) {
              final dayIdx = entry.key;
              final day = entry.value;
              final isToday = dayIdx == todayIdx;
              return _buildDay(context, day, isToday, isTodayHoliday);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDay(BuildContext context, TimetableDay day, bool isToday, bool isHoliday) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      itemCount: day.slots.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final slot = day.slots[i];
        if (slot.isBreak) {
          return Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "BREAK",
                  style: GoogleFonts.inter(
                    fontSize: 9, fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          );
        }
        final markKey = "${day.dayName}_${slot.subjectKey}_$i";
        final mark = widget.todayMarks[markKey];
        final cancelled = isToday && widget.appState.isLectureCancelledToday(slot.subjectKey, i);
        final disabled = isHoliday || cancelled;
        return _LectureCard(
          slot: slot,
          mark: mark,
          isToday: isToday,
          isCancelled: cancelled,
          isDisabled: disabled,
          onMark: (present) {
            setState(() {
              if (mark == present) {
                widget.todayMarks.remove(markKey);
                widget.appState.undoMark(slot.subjectKey, wasPresent: present);
              } else {
                if (mark != null) widget.appState.undoMark(slot.subjectKey, wasPresent: mark!);
                widget.todayMarks[markKey] = present;
                if (present) widget.appState.markSelfPresent(slot.subjectKey);
                else widget.appState.markSelfAbsent(slot.subjectKey);
              }
            });
            widget.persistMarks();
            HapticFeedback.lightImpact();
          },
          onLongPress: isToday && !isHoliday ? () => _showCancelDialog(context, slot, i, cancelled) : null,
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, TimetableSlot slot, int idx, bool cancelled) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SoftClawRadii.lg)),
        title: Text(
          cancelled ? "Restore Lecture?" : "Cancel Lecture?",
          style: GoogleFonts.baloo2(
            fontWeight: FontWeight.w800, fontSize: 17,
            color: Theme.of(ctx).colorScheme.onSurface,
          ),
        ),
        content: Text(
          cancelled
              ? 'Mark "${slot.subject}" as conducted today?'
              : 'Mark "${slot.subject}" as not conducted today?\nIt won\'t count toward your total.',
          style: GoogleFonts.inter(
            fontSize: 13, fontWeight: FontWeight.w500,
            color: Theme.of(ctx).colorScheme.onSurface.withOpacity(0.7), height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Dismiss", style: GoogleFonts.baloo2(
              fontWeight: FontWeight.w700,
              color: Theme.of(ctx).colorScheme.onSurface.withOpacity(0.6),
            )),
          ),
          ClayButton(
            label: cancelled ? "Restore" : "Cancel",
            icon: cancelled ? Icons.event_available_rounded : Icons.event_busy_rounded,
            primary: cancelled,
            onPressed: () {
              if (!cancelled) {
                final day = weeklyTimetable[DateTime.now().weekday - 1];
                final markKey = "${day.dayName}_${slot.subjectKey}_$idx";
                final currentMark = widget.todayMarks[markKey];
                if (currentMark != null) {
                  widget.appState.undoMark(slot.subjectKey, wasPresent: currentMark);
                  setState(() => widget.todayMarks.remove(markKey));
                  widget.persistMarks();
                }
              }
              widget.appState.toggleLectureCancelled(slot.subjectKey, idx);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${slot.subject} ${cancelled ? 'restored' : 'cancelled'}")),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LectureCard extends StatelessWidget {
  final TimetableSlot slot;
  final bool? mark;
  final bool isToday, isCancelled, isDisabled;
  final void Function(bool present) onMark;
  final VoidCallback? onLongPress;
  const _LectureCard({
    required this.slot,
    required this.mark,
    required this.isToday,
    required this.isCancelled,
    required this.isDisabled,
    required this.onMark,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColor(slot.type);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ink = Theme.of(context).colorScheme.onSurface;
    final muted = ink.withOpacity(0.6);
    final canMark = isToday && !isDisabled;

    return GestureDetector(
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: SoftClawMotion.medium,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isCancelled
              ? ink.withOpacity(0.03)
              : (mark != null
                  ? (mark! ? SoftClawPalette.green050.withOpacity(isDark ? 0.10 : 1) : SoftClawPalette.red100.withOpacity(isDark ? 0.10 : 1))
                  : Theme.of(context).colorScheme.surface),
          borderRadius: BorderRadius.circular(SoftClawRadii.md),
          boxShadow: isCancelled ? [] : SoftClawShadows.clayPressed,
          border: Border.all(
            color: isCancelled
                ? ink.withOpacity(0.10)
                : (mark != null
                    ? (mark! ? SoftClawPalette.green500.withOpacity(0.4) : SoftClawPalette.red500.withOpacity(0.3))
                    : Colors.transparent),
            width: 1.2,
          ),
        ),
        child: Opacity(
          opacity: isCancelled ? 0.5 : 1.0,
          child: Row(
            children: [
              // Time column
              SizedBox(
                width: 52,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      slot.startTime,
                      style: GoogleFonts.baloo2(
                        fontWeight: FontWeight.w800, fontSize: 13,
                        color: ink, letterSpacing: -0.2, height: 1.1,
                      ),
                    ),
                    Text(
                      slot.endTime,
                      style: GoogleFonts.inter(
                        fontSize: 10, fontWeight: FontWeight.w500,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Type indicator bar
              Container(
                width: 3, height: 36,
                decoration: BoxDecoration(
                  color: typeColor,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: typeColor.withOpacity(0.5),
                      blurRadius: 4, offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Subject info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            slot.subject,
                            style: GoogleFonts.baloo2(
                              fontWeight: FontWeight.w700, fontSize: 14,
                              color: ink, height: 1.1,
                              decoration: isCancelled ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                        if (isCancelled) ...[
                          const SizedBox(width: 6),
                          ClayChip(label: "CANCELLED", color: SoftClawPalette.amber500, small: true),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ClayChip(label: slot.type, color: typeColor, small: true),
                        if (slot.teacher != null) ...[
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              slot.teacher!,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 11, fontWeight: FontWeight.w500,
                                color: muted,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Mark buttons
              if (canMark) ...[
                const SizedBox(width: 6),
                _MarkButton(
                  icon: Icons.check_rounded,
                  active: mark == true,
                  color: SoftClawPalette.green500,
                  onTap: () => onMark(true),
                ),
                const SizedBox(width: 4),
                _MarkButton(
                  icon: Icons.close_rounded,
                  active: mark == false,
                  color: SoftClawPalette.red500,
                  onTap: () => onMark(false),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _typeColor(String t) {
    switch (t) {
      case 'TH': return const Color(0xFF7C3AED);
      case 'PR': return const Color(0xFF0891B2);
      case 'TUT': return const Color(0xFFF59E0B);
      case 'OE': return const Color(0xFF10B981);
      default: return SoftClawPalette.ink300;
    }
  }
}

class _MarkButton extends StatelessWidget {
  final IconData icon;
  final bool active;
  final Color color;
  final VoidCallback onTap;
  const _MarkButton({
    required this.icon,
    required this.active,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: SoftClawMotion.fast,
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: active ? color : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: active
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 10, offset: const Offset(0, 3),
                  ),
                ]
              : null,
          border: Border.all(
            color: active ? color : Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
            width: 1.5,
          ),
        ),
        child: Icon(
          icon, size: 16,
          color: active
              ? Colors.white
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  TAB 4 — SKIP ADVISOR
// ═══════════════════════════════════════════════════════════════════════════
class _SkipAdvisorTab extends StatelessWidget {
  final AppState appState;
  const _SkipAdvisorTab({required this.appState});

  @override
  Widget build(BuildContext context) {
    final suggestions = appState.getSkipSuggestions();
    final single = suggestions.where((s) => s.dayNames.length == 1).toList();
    final multi = suggestions.where((s) => s.dayNames.length > 1).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? SoftClawPalette.cyan300 : SoftClawPalette.cyan700;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [SoftClawPalette.cyan700, SoftClawPalette.cyan500],
              ),
              borderRadius: BorderRadius.circular(SoftClawRadii.lg),
              boxShadow: [
                BoxShadow(
                  color: SoftClawPalette.cyan500.withOpacity(0.4),
                  blurRadius: 20, offset: const Offset(0, 10),
                ),
                const BoxShadow(
                  color: Color(0x66FFFFFF),
                  offset: Offset(-3, -3), blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.beach_access_rounded, color: Colors.white, size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Smart Skip Advisor",
                        style: GoogleFonts.baloo2(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 20, letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Find safe days off without dropping below 75%.",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 12, fontWeight: FontWeight.w500, height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ClaySectionHeader(
            eyebrow: "SINGLE DAYS",
            title: "Skip one day",
            icon: Icons.calendar_today_rounded,
          ),
          const SizedBox(height: 12),
          ...single.map((s) => _SkipCard(suggestion: s)),
          const SizedBox(height: 24),
          ClaySectionHeader(
            eyebrow: "LONG WEEKENDS",
            title: "Multi-day combos",
            icon: Icons.weekend_rounded,
          ),
          const SizedBox(height: 12),
          ...multi.map((s) => _SkipCard(suggestion: s)),
        ],
      ),
    );
  }
}

class _SkipCard extends StatelessWidget {
  final SkipDaySuggestion suggestion;
  const _SkipCard({required this.suggestion});

  @override
  Widget build(BuildContext context) {
    final safe = suggestion.isSafe;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = safe
        ? (isDark ? SoftClawPalette.green300 : SoftClawPalette.green500)
        : (isDark ? const Color(0xFFFBBF24) : SoftClawPalette.amber500);
    final ink = Theme.of(context).colorScheme.onSurface;
    final muted = ink.withOpacity(0.65);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClayCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.16),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accent.withOpacity(0.3)),
              ),
              child: Icon(
                safe ? Icons.check_circle_rounded : Icons.warning_rounded,
                color: accent, size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.label,
                    style: GoogleFonts.baloo2(
                      fontWeight: FontWeight.w800, fontSize: 15,
                      color: ink, letterSpacing: -0.3, height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${suggestion.totalDaysOff} days off total",
                    style: GoogleFonts.inter(
                      fontSize: 12, fontWeight: FontWeight.w500,
                      color: muted,
                    ),
                  ),
                  if (!safe && suggestion.riskySubjects.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6, runSpacing: 6,
                      children: suggestion.riskySubjects.map((sub) =>
                        ClayChip(
                          label: sub, color: SoftClawPalette.amber500,
                          small: true, icon: Icons.priority_high_rounded,
                        ),
                      ).toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            ClayChip(
              label: safe ? "SAFE" : "RISKY",
              color: accent,
              icon: safe ? Icons.bolt_rounded : Icons.warning_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
