import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../models/subject_model.dart';
import '../services/persistence_service.dart';
import '../services/attendance_service.dart';
import 'auth_provider.dart';

class AttendanceProvider extends ChangeNotifier {
  final PersistenceService _persistence;
  final AttendanceService _attendanceService;
  final AuthProvider _authProvider;

  AttendanceProvider(this._persistence, this._attendanceService, this._authProvider);

  Student? get _student => _authProvider.currentStudent;

  Future<void> updateAttendance(String subjectKey, int newAttended, int newTotal) async {
    final student = _student;
    if (student == null) return;
    
    final sub = student.subjects[subjectKey];
    if (sub == null) return;
    
    sub.attended = newAttended;
    sub.total = newTotal;
    
    await _authProvider.updateCurrentStudent(student);
    notifyListeners();
  }

  void markPresent(String subjectKey) {
    final student = _student;
    if (student == null) return;

    student.subjects.putIfAbsent(
      subjectKey, () => Subject(name: subjectKey, attended: 0, total: 0),
    );
    student.subjects[subjectKey]!.attended += 1;
    student.subjects[subjectKey]!.total += 1;
    
    _authProvider.updateCurrentStudent(student);
    notifyListeners();
  }

  void markAbsent(String subjectKey) {
    final student = _student;
    if (student == null) return;

    student.subjects.putIfAbsent(
      subjectKey, () => Subject(name: subjectKey, attended: 0, total: 0),
    );
    student.subjects[subjectKey]!.total += 1;
    
    _authProvider.updateCurrentStudent(student);
    notifyListeners();
  }

  void undoMark(String subjectKey, {required bool wasPresent}) {
    final student = _student;
    if (student == null) return;
    
    final sub = student.subjects[subjectKey];
    if (sub == null) return;
    
    if (wasPresent && sub.attended > 0) sub.attended -= 1;
    if (sub.total > 0) sub.total -= 1;
    
    _authProvider.updateCurrentStudent(student);
    notifyListeners();
  }

  List<SkipDaySuggestion> getSkipSuggestions() {
    final student = _student;
    if (student == null) return [];
    return _attendanceService.getSkipSuggestions(student);
  }

  Future<void> saveTodayMarks(String date, Map<String, bool?> marks) async {
    final filtered = <String, bool>{};
    marks.forEach((k, v) { if (v != null) filtered[k] = v; });
    await _persistence.saveTodayMarks(date, filtered);
  }

  Future<Map<String, bool>> loadTodayMarks(String date) async {
    return await _persistence.getTodayMarks(date);
  }
}
