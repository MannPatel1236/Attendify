import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PersistenceService {
  static const String _kTheme = 'theme_mode';
  static const String _kAuthRole = 'auth_role';
  static const String _kAuthStudentId = 'auth_student_id';
  static const String _kHolidays = 'holidays';
  static const String _kCancelled = 'cancelled_lectures';
  static const String _kTodayMarks = 'today_marks';
  static const String _kTodayMarksDate = 'today_marks_date';
  static const String _kStudentPrefix = 'student_';

  Future<void> saveTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTheme, theme);
  }

  Future<String?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kTheme);
  }

  Future<void> saveAuth(String role, String? studentId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAuthRole, role);
    if (studentId != null) {
      await prefs.setString(_kAuthStudentId, studentId);
    } else {
      await prefs.remove(_kAuthStudentId);
    }
  }

  Future<Map<String, String?>> getAuth() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'role': prefs.getString(_kAuthRole),
      'studentId': prefs.getString(_kAuthStudentId),
    };
  }

  Future<void> saveHolidays(List<String> holidays) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kHolidays, holidays);
  }

  Future<List<String>> getHolidays() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_kHolidays) ?? [];
  }

  Future<void> saveCancelledLectures(List<String> cancelled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kCancelled, cancelled);
  }

  Future<List<String>> getCancelledLectures() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_kCancelled) ?? [];
  }

  Future<void> saveTodayMarks(String date, Map<String, bool> marks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTodayMarksDate, date);
    await prefs.setString(_kTodayMarks, jsonEncode(marks));
  }

  Future<Map<String, bool>> getTodayMarks(String todayDate) async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString(_kTodayMarksDate);
    if (savedDate != todayDate) return {};
    
    final data = prefs.getString(_kTodayMarks);
    if (data == null) return {};
    
    final Map<String, dynamic> decoded = jsonDecode(data);
    return decoded.map((k, v) => MapEntry(k, v as bool));
  }

  Future<void> saveStudentData(String studentId, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_kStudentPrefix$studentId', jsonEncode(data));
  }

  Future<Map<String, dynamic>?> getStudentData(String studentId) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('$_kStudentPrefix$studentId');
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }
}
