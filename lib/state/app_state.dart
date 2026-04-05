import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student_model.dart';
import '../models/timetable_model.dart';
import '../subject_model.dart';

enum UserRole { none, student, teacher }

class SkipDaySuggestion {
  final String label;
  final List<String> dayNames;
  final int totalDaysOff;
  final bool isSafe;
  final List<String> riskySubjects;

  SkipDaySuggestion({
    required this.label,
    required this.dayNames,
    required this.totalDaysOff,
    required this.isSafe,
    required this.riskySubjects,
  });
}

// ─── Default attendance data (used on first launch) ──────────────────────────
Map<String, Subject> _defaultSubjects() => {
  "DS (TH)":     Subject(name: "DS (TH)",     attended: 22, total: 24),
  "ML-I (TH)":   Subject(name: "ML-I (TH)",   attended: 22, total: 24),
  "SDS (TH)":    Subject(name: "SDS (TH)",    attended: 23, total: 26),
  "EFM (TH)":    Subject(name: "EFM (TH)",    attended: 13, total: 17),
  "CMPM (TH)":   Subject(name: "CMPM (TH)",   attended: 21, total: 21),
  "OE (TH)":     Subject(name: "OE (TH)",     attended: 21, total: 22),
  "DS (PR)":     Subject(name: "DS (PR)",     attended: 18, total: 18),
  "ML-I (PR)":   Subject(name: "ML-I (PR)",   attended: 16, total: 18),
  "SDS (PR)":    Subject(name: "SDS (PR)",    attended: 10, total: 14),
  "WE (PR)":     Subject(name: "WE (PR)",     attended: 28, total: 34),
  "CMPM (PR)":   Subject(name: "CMPM (PR)",   attended: 18, total: 18),
  "PBC (TUT)":   Subject(name: "PBC (TUT)",   attended: 16, total: 18),
};

class AppState extends ChangeNotifier {
  UserRole _currentUserRole = UserRole.none;
  UserRole get currentUserRole => _currentUserRole;

  Student? _currentStudent;
  Student? get currentStudent => _currentStudent;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  // ─── Holiday & Cancelled lecture tracking ─────────────────────────────────
  final Set<String> _holidays = {};
  final Set<String> _cancelledLectures = {};

  Set<String> get holidays => _holidays;
  Set<String> get cancelledLectures => _cancelledLectures;

  String get _todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  bool get isTodayHoliday => _holidays.contains(_todayKey);

  void markTodayAsHoliday() {
    _holidays.add(_todayKey);
    _save();
    notifyListeners();
  }

  void unmarkTodayAsHoliday() {
    _holidays.remove(_todayKey);
    _save();
    notifyListeners();
  }

  void toggleTodayHoliday() {
    if (isTodayHoliday) {
      unmarkTodayAsHoliday();
    } else {
      markTodayAsHoliday();
    }
  }

  String _cancelKey(String subjectKey, int slotIndex) =>
      '${_todayKey}_${subjectKey}_$slotIndex';

  bool isLectureCancelledToday(String subjectKey, int slotIndex) =>
      _cancelledLectures.contains(_cancelKey(subjectKey, slotIndex));

  void toggleLectureCancelled(String subjectKey, int slotIndex) {
    final key = _cancelKey(subjectKey, slotIndex);
    if (_cancelledLectures.contains(key)) {
      _cancelledLectures.remove(key);
    } else {
      _cancelledLectures.add(key);
    }
    _save();
    notifyListeners();
  }

  // ─── Free attendance editing ──────────────────────────────────────────────
  void updateAttendance(String subjectKey, int newAttended, int newTotal) {
    final student = _currentStudent;
    if (student == null) return;
    final sub = student.subjects[subjectKey];
    if (sub == null) return;
    sub.attended = newAttended;
    sub.total = newTotal;
    _save();
    notifyListeners();
  }

  // ─── Students ─────────────────────────────────────────────────────────────
  List<Student> _students = [
    Student(
      id: "S01", name: "Mann", batch: "D21",
      subjects: {
        "DS (TH)":     Subject(name: "DS (TH)",     attended: 22, total: 24),
        "ML-I (TH)":   Subject(name: "ML-I (TH)",   attended: 22, total: 24),
        "SDS (TH)":    Subject(name: "SDS (TH)",    attended: 23, total: 26),
        "EFM (TH)":    Subject(name: "EFM (TH)",    attended: 13, total: 17),
        "CMPM (TH)":   Subject(name: "CMPM (TH)",   attended: 21, total: 21),
        "OE (TH)":     Subject(name: "OE (TH)",     attended: 21, total: 22),
        "DS (PR)":     Subject(name: "DS (PR)",     attended: 18, total: 18),
        "ML-I (PR)":   Subject(name: "ML-I (PR)",   attended: 16, total: 18),
        "SDS (PR)":    Subject(name: "SDS (PR)",    attended: 10, total: 14),
        "WE (PR)":     Subject(name: "WE (PR)",     attended: 28, total: 34),
        "CMPM (PR)":   Subject(name: "CMPM (PR)",   attended: 18, total: 18),
        "PBC (TUT)":   Subject(name: "PBC (TUT)",   attended: 16, total: 18),
      },
    ),
    Student(
      id: "S02", name: "Jane Doe", batch: "D21",
      subjects: {
        "ML-I (TH)": Subject(name: "ML-I (TH)", attended: 7, total: 8),
        "DS (TH)": Subject(name: "DS (TH)", attended: 9, total: 10),
      },
      hodLetterUrl: "mock_proxy_letter.png",
      timetableUrl: "mock_timetable.pdf",
    ),
  ];
  List<Student> get students => _students;

  // ═══════════════════════════════════════════════════════════════════════════
  //  PERSISTENCE — SharedPreferences
  // ═══════════════════════════════════════════════════════════════════════════

  static const _kSubjects = 'subjects_v1';
  static const _kHolidays = 'holidays_v1';
  static const _kCancelled = 'cancelled_v1';
  static const _kTheme = 'theme_v1';
  static const _kTodayMarks = 'today_marks_v1';
  static const _kTodayMarksDate = 'today_marks_date_v1';

  /// Call once at app startup to load persisted data.
  Future<void> loadFromDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // ── Theme ──
      final savedTheme = prefs.getString(_kTheme);
      if (savedTheme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else if (savedTheme == 'light') {
        _themeMode = ThemeMode.light;
      } else {
        _themeMode = ThemeMode.system;
      }

      // ── Subjects ──
      final subJson = prefs.getString(_kSubjects);
      if (subJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(subJson);
        final subjects = decoded.map((key, val) => MapEntry(
          key,
          Subject(name: val['name'] as String, attended: val['a'] as int, total: val['t'] as int),
        ));
        final mann = _students.firstWhere((s) => s.id == "S01");
        mann.subjects.clear();
        mann.subjects.addAll(subjects);
      }

      // ── Holidays ──
      final holJson = prefs.getStringList(_kHolidays);
      if (holJson != null) _holidays.addAll(holJson);

      // ── Cancelled lectures ──
      final canJson = prefs.getStringList(_kCancelled);
      if (canJson != null) _cancelledLectures.addAll(canJson);
    } catch (e) {
      // SharedPreferences may fail on hot restart — use defaults
      debugPrint('loadFromDisk: using defaults ($e)');
    }

    _isLoaded = true;
    notifyListeners();
  }

  /// Persist current state to disk. Called after every mutation.
  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_kTheme, _themeMode == ThemeMode.dark ? 'dark' : _themeMode == ThemeMode.light ? 'light' : 'system');
      final mann = _students.firstWhere((s) => s.id == "S01", orElse: () => _students.first);
      final subMap = mann.subjects.map((key, sub) => MapEntry(
        key, {'name': sub.name, 'a': sub.attended, 't': sub.total},
      ));
      prefs.setString(_kSubjects, jsonEncode(subMap));
      prefs.setStringList(_kHolidays, _holidays.toList());
      prefs.setStringList(_kCancelled, _cancelledLectures.toList());
    } catch (_) {}
  }

  /// Save today's marks (called from the dashboard)
  Future<void> saveTodayMarks(Map<String, bool?> marks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final filtered = <String, bool>{};
      marks.forEach((k, v) { if (v != null) filtered[k] = v; });
      prefs.setString(_kTodayMarks, jsonEncode(filtered));
      prefs.setString(_kTodayMarksDate, _todayKey);
    } catch (_) {}
  }

  /// Load today's marks (called from the dashboard)
  Future<Map<String, bool?>> loadTodayMarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedDate = prefs.getString(_kTodayMarksDate);
      if (savedDate != _todayKey) {
        prefs.remove(_kTodayMarks);
        prefs.remove(_kTodayMarksDate);
        return {};
      }
      final json = prefs.getString(_kTodayMarks);
      if (json == null) return {};
      final Map<String, dynamic> decoded = jsonDecode(json);
      return decoded.map((k, v) => MapEntry(k, v as bool));
    } catch (_) {
      return {};
    }
  }

  // ─── Theme ────────────────────────────────────────────────────────────────
  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.system;
    } else {
      _themeMode = ThemeMode.dark;
    }
    _save();
    notifyListeners();
  }

  String get themeLabel {
    switch (_themeMode) {
      case ThemeMode.dark: return 'Dark';
      case ThemeMode.light: return 'Light';
      default: return 'Auto';
    }
  }

  IconData get themeIcon {
    switch (_themeMode) {
      case ThemeMode.dark: return Icons.dark_mode;
      case ThemeMode.light: return Icons.light_mode;
      default: return Icons.brightness_auto;
    }
  }

  // ─── Auth ─────────────────────────────────────────────────────────────────
  void loginAsTeacher() {
    _currentUserRole = UserRole.teacher;
    notifyListeners();
  }

  void loginAsStudent() {
    _currentUserRole = UserRole.student;
    _currentStudent = _students.firstWhere((s) => s.id == "S01");
    notifyListeners();
  }

  void logout() {
    _currentUserRole = UserRole.none;
    _currentStudent = null;
    notifyListeners();
  }

  // ─── Timetable ────────────────────────────────────────────────────────────
  TimetableDay? getTodaySchedule() {
    final weekday = DateTime.now().weekday;
    if (weekday < 1 || weekday > 5) return null;
    return weeklyTimetable[weekday - 1];
  }

  // ─── Self-mark attendance ─────────────────────────────────────────────────
  void markSelfPresent(String subjectKey) {
    final student = _currentStudent;
    if (student == null) return;
    student.subjects.putIfAbsent(
      subjectKey, () => Subject(name: subjectKey, attended: 0, total: 0),
    );
    student.subjects[subjectKey]!.attended += 1;
    student.subjects[subjectKey]!.total += 1;
    _save();
    notifyListeners();
  }

  void markSelfAbsent(String subjectKey) {
    final student = _currentStudent;
    if (student == null) return;
    student.subjects.putIfAbsent(
      subjectKey, () => Subject(name: subjectKey, attended: 0, total: 0),
    );
    student.subjects[subjectKey]!.total += 1;
    _save();
    notifyListeners();
  }

  void undoMark(String subjectKey, {required bool wasPresent}) {
    final student = _currentStudent;
    if (student == null) return;
    final sub = student.subjects[subjectKey];
    if (sub == null) return;
    if (wasPresent && sub.attended > 0) sub.attended -= 1;
    if (sub.total > 0) sub.total -= 1;
    _save();
    notifyListeners();
  }

  // ─── Skip Day Advisor ─────────────────────────────────────────────────────
  List<SkipDaySuggestion> getSkipSuggestions() {
    final student = _currentStudent;
    if (student == null) return [];

    final suggestions = <SkipDaySuggestion>[];
    final days = weeklyTimetable;

    for (int i = 0; i < days.length; i++) {
      final day = days[i];
      final risky = _evaluateSkip(student, [day]);
      int totalOff = 1;
      if (i == 0) totalOff = 3;
      if (i == 4) totalOff = 3;
      suggestions.add(SkipDaySuggestion(
        label: 'Skip ${day.dayName}',
        dayNames: [day.dayName],
        totalDaysOff: totalOff,
        isSafe: risky.isEmpty,
        riskySubjects: risky,
      ));
    }

    final combos = <String, List<int>>{
      'Skip Fri + Mon': [4, 0],
      'Skip Thu + Fri': [3, 4],
      'Skip Mon + Tue': [0, 1],
      'Skip Thu–Mon (5-day break!)': [3, 4, 0],
    };
    final comboTotalOff = {
      'Skip Fri + Mon': 4,
      'Skip Thu + Fri': 4,
      'Skip Mon + Tue': 4,
      'Skip Thu–Mon (5-day break!)': 5,
    };

    for (final entry in combos.entries) {
      final skipDays = entry.value.map((i) => days[i]).toList();
      final risky = _evaluateSkip(student, skipDays);
      suggestions.add(SkipDaySuggestion(
        label: entry.key,
        dayNames: entry.value.map((i) => days[i].dayName).toList(),
        totalDaysOff: comboTotalOff[entry.key] ?? entry.value.length,
        isSafe: risky.isEmpty,
        riskySubjects: risky,
      ));
    }

    return suggestions;
  }

  List<String> _evaluateSkip(Student student, List<TimetableDay> skipDays) {
    final risky = <String>[];
    final missedPerSubject = <String, int>{};

    for (final day in skipDays) {
      day.subjectClassCount.forEach((key, count) {
        missedPerSubject[key] = (missedPerSubject[key] ?? 0) + count;
      });
    }

    missedPerSubject.forEach((key, missed) {
      final sub = student.subjects[key];
      if (sub == null) return;
      final newTotal = sub.total + missed;
      final newPct = newTotal == 0 ? 0.0 : sub.attended / newTotal * 100;
      if (newPct < 75.0) {
        risky.add(key);
      }
    });

    return risky;
  }

  // ─── Upload ───────────────────────────────────────────────────────────────
  Future<bool> uploadAndExtractTimetable() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return true;
    if (_currentStudent != null) {
      _currentStudent!.timetableUrl = image.path;
      notifyListeners();
      return true;
    }
    return false;
  }

  void saveManualTimetable(List<String> subjects) {
    if (_currentStudent != null) {
      _currentStudent!.timetableUrl = "manual_entry";
      for (var sub in subjects) {
        if (!_currentStudent!.subjects.containsKey(sub)) {
           _currentStudent!.subjects[sub] = Subject(name: sub, attended: 0, total: 0);
        }
      }
      _save();
      notifyListeners();
    }
  }

  Future<void> uploadHodLetter() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && _currentStudent != null) {
      _currentStudent!.hodLetterUrl = image.path;
      notifyListeners();
    }
  }

  // ─── Roll Call (teacher) ──────────────────────────────────────────────────
  void submitRollCall(Map<String, bool> attendanceData, String subjectName) {
    for (var entry in attendanceData.entries) {
      String studentId = entry.key;
      bool isPresent = entry.value;

      final studentIndex = _students.indexWhere((s) => s.id == studentId);
      if (studentIndex != -1) {
        final student = _students[studentIndex];
        if (!student.subjects.containsKey(subjectName)) {
           student.subjects[subjectName] = Subject(name: subjectName, attended: 0, total: 0);
        }
        student.subjects[subjectName]!.total += 1;
        if (isPresent) {
          student.subjects[subjectName]!.attended += 1;
        }
      }
    }
    _save();
    notifyListeners();
  }
}
