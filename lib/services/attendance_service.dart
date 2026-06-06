import '../models/student_model.dart';
import '../models/timetable_model.dart';

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

class AttendanceService {
  List<SkipDaySuggestion> getSkipSuggestions(Student student) {
    final suggestions = <SkipDaySuggestion>[];
    final days = weeklyTimetable;

    for (int i = 0; i < days.length; i++) {
      final day = days[i];
      final risky = _evaluateSkip(student, [day]);
      int totalOff = 1;
      if (i == 0 || i == 4) totalOff = 3; // Long weekend effect
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
}
