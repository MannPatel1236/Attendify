import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/timetable_model.dart';
import 'manual_timetable_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> with SingleTickerProviderStateMixin {
  bool _isUploadingTimetable = false;
  bool _isUploadingHod = false;
  late TabController _tabController;

  // Track today's marking state: subjectKey -> true=present, false=absent, null=unmarked
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
    final appState = context.read<AppState>();
    appState.saveTodayMarks(_todayMarks);
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

    if (student == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Text("Hi, ${student.name} 👋"),
        actions: [
          IconButton(
            icon: Icon(appState.themeIcon),
            onPressed: () => appState.toggleTheme(),
            tooltip: "Theme: ${appState.themeLabel}",
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: () => appState.logout()),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: const [
            Tab(text: "Overview"),
            Tab(text: "Subjects"),
            Tab(text: "Timetable"),
            Tab(text: "Skip Advisor"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(student, appState, isDark),
          _buildSubjectsTab(student, appState, isDark),
          _buildTimetableTab(appState, isDark),
          _buildSkipAdvisorTab(appState, isDark),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  TAB 1: OVERVIEW
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildOverviewTab(student, AppState appState, bool isDark) {
    final pct = student.overallAttendance;
    final bool isSafe = pct >= 75.0;
    final cardBg = isDark ? const Color(0xFF1E1E2C) : Colors.white;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Holiday Banner ──
          if (appState.isTodayHoliday)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.amber.shade600, Colors.orange.shade700]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text("🏖️", style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Today is a Holiday!",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                        SizedBox(height: 2),
                        Text("No lectures will be conducted today",
                            style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                    onPressed: () => appState.unmarkTodayAsHoliday(),
                    tooltip: "Remove holiday",
                  ),
                ],
              ),
            ),

          _buildHeroGauge(pct, isSafe),
          const SizedBox(height: 20),
          Row(
            children: [
              _miniStat("Total\nSubjects", "${student.subjects.length}", Icons.book, Colors.indigo, cardBg, isDark),
              const SizedBox(width: 12),
              _miniStat("Can Skip\n(Total)", "${_totalCanSkip(student)}", Icons.event_available, Colors.teal, cardBg, isDark),
              const SizedBox(width: 12),
              _miniStat("Need to\nAttend", "${_totalNeedAttend(student)}", Icons.warning_amber_rounded, Colors.orange, cardBg, isDark),
            ],
          ),
          const SizedBox(height: 20),

          // Quick action row: Mark Today + Holiday toggle
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    _tabController.animateTo(2); // Jump to timetable tab
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.deepPurple.shade400, Colors.indigo.shade600]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.touch_app, color: Colors.white, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Mark Today", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                              SizedBox(height: 2),
                              Text("Go to timetable", style: TextStyle(color: Colors.white70, fontSize: 11)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 14),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () => appState.toggleTodayHoliday(),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: appState.isTodayHoliday
                        ? LinearGradient(colors: [Colors.amber.shade600, Colors.orange.shade700])
                        : LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade600]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        appState.isTodayHoliday ? Icons.celebration : Icons.beach_access,
                        color: Colors.white, size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appState.isTodayHoliday ? "Holiday ✓" : "Holiday",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Attendance Breakdown",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
                const SizedBox(height: 14),
                ...student.subjects.values.map((sub) => _attendanceBar(sub, isDark)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildActionButtons(appState, isDark),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeroGauge(double pct, bool isSafe) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isSafe
              ? [const Color(0xFF00B4D8), const Color(0xFF0077B6)]
              : [const Color(0xFFFF6B6B), const Color(0xFFEE5A24)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isSafe ? const Color(0xFF00B4D8) : const Color(0xFFFF6B6B)).withOpacity(0.35),
            blurRadius: 20, offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100, height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100, height: 100,
                  child: CircularProgressIndicator(
                    value: pct / 100, strokeWidth: 10,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text("${pct.toStringAsFixed(1)}%",
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Overall Attendance",
                    style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Text(isSafe ? "You're on track! 🎉" : "Below 75% ⚠️",
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: Text(isSafe ? "Keep it going" : "Recover ASAP",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, IconData icon, Color accentColor, Color cardBg, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: accentColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _attendanceBar(sub, bool isDark) {
    final pct = sub.percentage;
    final isSafe = pct >= 75.0;
    final barColor = isSafe ? const Color(0xFF00B4D8) : const Color(0xFFFF6B6B);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(sub.name, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: isDark ? Colors.white : Colors.black87))),
              Text("${pct.toStringAsFixed(0)}%  (${sub.attended}/${sub.total})",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: barColor)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (pct / 100).clamp(0.0, 1.0), minHeight: 8,
              backgroundColor: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(barColor),
            ),
          ),
        ],
      ),
    );
  }

  int _totalCanSkip(student) {
    int total = 0;
    for (var sub in student.subjects.values) {
      total += sub.canSkip as int;
    }
    return total;
  }

  int _totalNeedAttend(student) {
    int total = 0;
    for (var sub in student.subjects.values) {
      if (sub.percentage < 75) total += sub.classesToAttend as int;
    }
    return total;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  TAB 2: SUBJECTS (with edit attendance)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildSubjectsTab(student, AppState appState, bool isDark) {
    final cardBg = isDark ? const Color(0xFF1E1E2C) : Colors.white;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: student.subjects.length,
      itemBuilder: (context, index) {
        final key = student.subjects.keys.elementAt(index);
        final sub = student.subjects.values.elementAt(index);
        final pct = sub.percentage;
        final isSafe = pct >= 75.0;
        final accent = isSafe ? const Color(0xFF00B4D8) : const Color(0xFFFF6B6B);

        return GestureDetector(
          onTap: () => _showEditAttendanceDialog(appState, key, sub, isDark),
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardBg, borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade200),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 54, height: 54,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: (pct / 100).clamp(0.0, 1.0), strokeWidth: 5,
                        backgroundColor: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(accent), strokeCap: StrokeCap.round,
                      ),
                      Text("${pct.toInt()}%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: accent)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sub.name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: isDark ? Colors.white : Colors.black87)),
                      const SizedBox(height: 4),
                      Text("${sub.attended} / ${sub.total} attended",
                          style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isSafe)
                      _chip("Skip ${sub.canSkip}", Colors.teal)
                    else
                      _chip("Need ${sub.classesToAttend}", Colors.red.shade400),
                    const SizedBox(height: 6),
                    Icon(Icons.edit_outlined, size: 16,
                        color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Show dialog for editing a subject's attended/total values
  void _showEditAttendanceDialog(AppState appState, String subjectKey, dynamic sub, bool isDark) {
    final attendedController = TextEditingController(text: sub.attended.toString());
    final totalController = TextEditingController(text: sub.total.toString());

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E2C) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.edit, color: Colors.indigo.shade400, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text("Edit ${sub.name}",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17,
                        color: isDark ? Colors.white : Colors.black87)),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Modify attendance to match your official records.",
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: attendedController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Attended",
                        labelStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.indigo.shade400, width: 2),
                        ),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF2A2A3C) : Colors.grey.shade50,
                        prefixIcon: Icon(Icons.check_circle_outline, color: Colors.teal.shade400, size: 20),
                      ),
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18,
                          color: isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text("/", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300,
                        color: isDark ? Colors.grey.shade500 : Colors.grey.shade400)),
                  ),
                  Expanded(
                    child: TextField(
                      controller: totalController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Total",
                        labelStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.indigo.shade400, width: 2),
                        ),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF2A2A3C) : Colors.grey.shade50,
                        prefixIcon: Icon(Icons.format_list_numbered, color: Colors.indigo.shade400, size: 20),
                      ),
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18,
                          color: isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Cancel", style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
            ),
            ElevatedButton(
              onPressed: () {
                final newAttended = int.tryParse(attendedController.text);
                final newTotal = int.tryParse(totalController.text);
                if (newAttended == null || newTotal == null || newAttended < 0 || newTotal < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter valid numbers"), behavior: SnackBarBehavior.floating),
                  );
                  return;
                }
                if (newAttended > newTotal) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Attended can't exceed total"), behavior: SnackBarBehavior.floating),
                  );
                  return;
                }
                appState.updateAttendance(subjectKey, newAttended, newTotal);
                Navigator.pop(ctx);
                _showSnackBar("${sub.name} updated to $newAttended/$newTotal");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text("Save", style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  TAB 3: TIMETABLE + SELF-MARK ATTENDANCE + HOLIDAY + CANCEL LECTURE
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildTimetableTab(AppState appState, bool isDark) {
    final cardBg = isDark ? const Color(0xFF1E1E2C) : Colors.white;
    final todayIdx = DateTime.now().weekday - 1;

    return DefaultTabController(
      length: weeklyTimetable.length,
      initialIndex: todayIdx.clamp(0, 4),
      child: Column(
        children: [
          // Holiday banner for timetable tab
          if (appState.isTodayHoliday)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.amber.shade600, Colors.orange.shade700]),
              ),
              child: Row(
                children: const [
                  Text("🏖️", style: TextStyle(fontSize: 20)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text("Today is marked as a holiday — attendance marking is disabled.",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ],
              ),
            ),
          // Info banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.deepPurple.withOpacity(isDark ? 0.15 : 0.08),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.deepPurple.shade400),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Tap ✓ or ✗ to mark attendance. Long-press to cancel a lecture.",
                    style: TextStyle(fontSize: 12, color: Colors.deepPurple.shade400, fontWeight: FontWeight.w600),
                  ),
                ),
                // Holiday toggle button in timetable
                GestureDetector(
                  onTap: () => appState.toggleTodayHoliday(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: appState.isTodayHoliday
                          ? Colors.amber.shade600.withOpacity(0.2)
                          : Colors.deepPurple.shade400.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: appState.isTodayHoliday
                            ? Colors.amber.shade600
                            : Colors.deepPurple.shade400.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      appState.isTodayHoliday ? "🏖️ Holiday" : "📅 Holiday",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: appState.isTodayHoliday ? Colors.amber.shade700 : Colors.deepPurple.shade400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Day tabs
          Material(
            color: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
            child: TabBar(
              isScrollable: true,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: weeklyTimetable.map((d) {
                final idx = weeklyTimetable.indexOf(d);
                final isToday = idx == todayIdx;
                return Tab(
                  child: Row(
                    children: [
                      Text(d.dayName, style: TextStyle(fontWeight: isToday ? FontWeight.w800 : FontWeight.w500)),
                      if (isToday) ...[
                        const SizedBox(width: 4),
                        Container(width: 6, height: 6,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.primary)),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: weeklyTimetable.asMap().entries.map((entry) {
                final dayIdx = entry.key;
                final day = entry.value;
                final isToday = dayIdx == todayIdx;
                final isTodayHoliday = appState.isTodayHoliday && isToday;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: day.slots.length,
                  itemBuilder: (context, i) {
                    final slot = day.slots[i];

                    if (slot.isBreak) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(child: Divider(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text("☕ BREAK", style: TextStyle(
                                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                                  fontWeight: FontWeight.w600, fontSize: 12)),
                            ),
                            Expanded(child: Divider(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300)),
                          ],
                        ),
                      );
                    }

                    final typeColor = _typeColor(slot.type);
                    final markKey = "${day.dayName}_${slot.subjectKey}_$i";
                    final currentMark = _todayMarks[markKey];
                    final isCancelled = isToday && appState.isLectureCancelledToday(slot.subjectKey, i);
                    final isDisabled = isTodayHoliday || isCancelled;

                    return GestureDetector(
                      onLongPress: isToday && !isTodayHoliday
                          ? () => _showCancelLectureDialog(appState, slot, i, isCancelled, isDark)
                          : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isCancelled
                              ? (isDark ? Colors.grey.withOpacity(0.08) : Colors.grey.withOpacity(0.06))
                              : currentMark == true
                                  ? (isDark ? Colors.green.withOpacity(0.08) : Colors.green.withOpacity(0.04))
                                  : currentMark == false
                                      ? (isDark ? Colors.red.withOpacity(0.08) : Colors.red.withOpacity(0.04))
                                      : cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isCancelled
                                ? Colors.grey.withOpacity(0.3)
                                : currentMark == true
                                    ? Colors.green.withOpacity(0.3)
                                    : currentMark == false
                                        ? Colors.red.withOpacity(0.3)
                                        : (isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade200),
                          ),
                        ),
                        child: Opacity(
                          opacity: isCancelled ? 0.5 : 1.0,
                          child: Row(
                            children: [
                              // Time
                              SizedBox(
                                width: 52,
                                child: Column(children: [
                                  Text(slot.startTime, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13,
                                      color: isDark ? Colors.white : Colors.black87)),
                                  Text(slot.endTime, style: TextStyle(fontSize: 11,
                                      color: isDark ? Colors.grey.shade500 : Colors.grey.shade500)),
                                ]),
                              ),
                              Container(
                                width: 3, height: 40,
                                margin: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(color: typeColor, borderRadius: BorderRadius.circular(2)),
                              ),
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
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600, fontSize: 14,
                                              color: isDark ? Colors.white : Colors.black87,
                                              decoration: isCancelled ? TextDecoration.lineThrough : null,
                                            ),
                                          ),
                                        ),
                                        if (isCancelled) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text("CANCELLED",
                                                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w700, fontSize: 9)),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Row(children: [
                                      _typeTag(slot.type, typeColor),
                                      if (slot.teacher != null) ...[
                                        const SizedBox(width: 6),
                                        Text("• ${slot.teacher}", style: TextStyle(fontSize: 12,
                                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                                      ],
                                      if (slot.room != null) ...[
                                        const SizedBox(width: 6),
                                        Text("• ${slot.room}", style: TextStyle(fontSize: 12,
                                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                                      ],
                                    ]),
                                  ],
                                ),
                              ),
                              // ── Self-mark buttons (only for today, non-OE, not disabled) ──
                              if (isToday && slot.subjectKey != 'OE' && !isDisabled) ...[
                                const SizedBox(width: 8),
                                _markButton(
                                  icon: Icons.check,
                                  isActive: currentMark == true,
                                  activeColor: const Color(0xFF00B4D8),
                                  isDark: isDark,
                                  onTap: () {
                                    setState(() {
                                      if (currentMark == true) {
                                        _todayMarks.remove(markKey);
                                        appState.undoMark(slot.subjectKey, wasPresent: true);
                                      } else {
                                        if (currentMark == false) {
                                          appState.undoMark(slot.subjectKey, wasPresent: false);
                                        }
                                        _todayMarks[markKey] = true;
                                        appState.markSelfPresent(slot.subjectKey);
                                      }
                                    });
                                    _persistMarks();
                                  },
                                ),
                                const SizedBox(width: 6),
                                _markButton(
                                  icon: Icons.close,
                                  isActive: currentMark == false,
                                  activeColor: const Color(0xFFFF6B6B),
                                  isDark: isDark,
                                  onTap: () {
                                    setState(() {
                                      if (currentMark == false) {
                                        _todayMarks.remove(markKey);
                                        appState.undoMark(slot.subjectKey, wasPresent: false);
                                      } else {
                                        if (currentMark == true) {
                                          appState.undoMark(slot.subjectKey, wasPresent: true);
                                        }
                                        _todayMarks[markKey] = false;
                                        appState.markSelfAbsent(slot.subjectKey);
                                      }
                                    });
                                    _persistMarks();
                                  },
                                ),
                              ],
                              // Show cancelled indicator if disabled but not holiday
                              if (isToday && isCancelled && !isTodayHoliday)
                                GestureDetector(
                                  onTap: () => _showCancelLectureDialog(appState, slot, i, true, isDark),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    child: Icon(Icons.event_busy, size: 20,
                                        color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Dialog to cancel/un-cancel a lecture
  void _showCancelLectureDialog(AppState appState, TimetableSlot slot, int slotIndex, bool isCancelled, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E2C) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(isCancelled ? Icons.event_available : Icons.event_busy,
                color: isCancelled ? Colors.teal : Colors.orange, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(isCancelled ? "Restore Lecture?" : "Cancel Lecture?",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17,
                      color: isDark ? Colors.white : Colors.black87)),
            ),
          ],
        ),
        content: Text(
          isCancelled
              ? "Mark \"${slot.subject}\" as conducted today?"
              : "Mark \"${slot.subject}\" as not conducted today?\n\nThis won't count towards your total.",
          style: TextStyle(fontSize: 14, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Dismiss", style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () {
              // If un-cancelling, just remove the cancel flag
              // If cancelling, also undo any mark made for this slot
              if (!isCancelled) {
                final markKey = "${weeklyTimetable[DateTime.now().weekday - 1].dayName}_${slot.subjectKey}_$slotIndex";
                final currentMark = _todayMarks[markKey];
                if (currentMark != null) {
                  appState.undoMark(slot.subjectKey, wasPresent: currentMark);
                  setState(() => _todayMarks.remove(markKey));
                  _persistMarks();
                }
              }
              appState.toggleLectureCancelled(slot.subjectKey, slotIndex);
              Navigator.pop(ctx);
              _showSnackBar(isCancelled
                  ? "${slot.subject} restored for today"
                  : "${slot.subject} cancelled for today");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isCancelled ? Colors.teal : Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(isCancelled ? "Restore" : "Cancel Lecture",
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _markButton({
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 34, height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? activeColor : Colors.transparent,
          border: Border.all(
            color: isActive ? activeColor : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
            width: 2,
          ),
        ),
        child: Icon(icon, size: 18, color: isActive ? Colors.white : (isDark ? Colors.grey.shade500 : Colors.grey.shade400)),
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'TH': return const Color(0xFF6C63FF);
      case 'PR': return const Color(0xFF00B4D8);
      case 'TUT': return const Color(0xFFFF9F43);
      case 'OE': return const Color(0xFF78C4A0);
      default: return Colors.grey;
    }
  }

  Widget _typeTag(String type, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
      child: Text(type, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 10)),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  TAB 4: SKIP ADVISOR
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildSkipAdvisorTab(AppState appState, bool isDark) {
    final suggestions = appState.getSkipSuggestions();
    final cardBg = isDark ? const Color(0xFF1E1E2C) : Colors.white;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.deepPurple.shade400, Colors.indigo.shade600]),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(Icons.beach_access, color: Colors.white, size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Smart Skip Advisor",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                      SizedBox(height: 4),
                      Text("Find safe days to skip without dropping below 75%",
                          style: TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text("Single Day Skips", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16,
              color: isDark ? Colors.white : Colors.black87)),
          const SizedBox(height: 10),
          ...suggestions.where((s) => s.dayNames.length == 1).map((s) => _skipCard(s, cardBg, isDark)),
          const SizedBox(height: 24),
          Text("Long Weekend Combos 🏖️", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16,
              color: isDark ? Colors.white : Colors.black87)),
          const SizedBox(height: 10),
          ...suggestions.where((s) => s.dayNames.length > 1).map((s) => _skipCard(s, cardBg, isDark)),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _skipCard(SkipDaySuggestion s, Color cardBg, bool isDark) {
    final safeColor = const Color(0xFF00B4D8);
    final riskyColor = const Color(0xFFFF6B6B);
    final accent = s.isSafe ? safeColor : riskyColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: accent.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(s.isSafe ? Icons.check_circle : Icons.cancel, color: accent, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15,
                    color: isDark ? Colors.white : Colors.black87)),
                const SizedBox(height: 4),
                Text("${s.totalDaysOff} days off total",
                    style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                if (!s.isSafe) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6, runSpacing: 4,
                    children: s.riskySubjects.map((sub) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: riskyColor.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                      child: Text("⚠ $sub", style: TextStyle(color: riskyColor, fontSize: 11, fontWeight: FontWeight.w600)),
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: accent.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
            child: Text(s.isSafe ? "SAFE ✓" : "RISKY",
                style: TextStyle(color: accent, fontWeight: FontWeight.w800, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  // ─── Action buttons (overview tab) ────────────────────────────────────────
  Widget _buildActionButtons(AppState appState, bool isDark) {
    final cardBg = isDark ? const Color(0xFF1E1E2C) : Colors.white;

    return Row(
      children: [
        Expanded(
          child: _actionBtn("Scan Timetable", Icons.document_scanner,
              [Colors.blue.shade400, Colors.indigo.shade600], cardBg, _isUploadingTimetable, isDark,
              () async {
                setState(() => _isUploadingTimetable = true);
                bool success = await appState.uploadAndExtractTimetable();
                setState(() => _isUploadingTimetable = false);
                if (mounted) {
                  if (success) _showSnackBar("Timetable uploaded!");
                  else _showManualFallbackDialog();
                }
              }),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _actionBtn("HOD Letter", Icons.verified_user_outlined,
              [Colors.deepPurple.shade400, Colors.indigo.shade700], cardBg, _isUploadingHod, isDark,
              () async {
                setState(() => _isUploadingHod = true);
                await appState.uploadHodLetter();
                setState(() => _isUploadingHod = false);
                if (mounted) _showSnackBar("HOD Letter uploaded!");
              }),
        ),
      ],
    );
  }

  Widget _actionBtn(String text, IconData icon, List<Color> gradient, Color cardBg, bool loading, bool isDark, VoidCallback onTap) {
    return InkWell(
      onTap: loading ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: cardBg, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade200),
        ),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ShaderMask(shaderCallback: (rect) => LinearGradient(colors: gradient).createShader(rect),
                    child: Icon(icon, color: Colors.white, size: 24)),
                const SizedBox(width: 8),
                Text(text, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87)),
              ]),
      ),
    );
  }

  void _showManualFallbackDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text("Extraction Failed"),
        content: const Text("We couldn't clearly read the timetable. Would you like to enter it manually?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () { Navigator.pop(ctx); Navigator.push(context, MaterialPageRoute(builder: (_) => const ManualTimetableScreen())); },
            child: const Text("Manual Entry"),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating, backgroundColor: Colors.indigo),
    );
  }
}
