import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../services/persistence_service.dart';
import '../models/subject_model.dart';

enum UserRole { none, student, teacher }

class AuthProvider extends ChangeNotifier {
  final PersistenceService _persistence;
  UserRole _role = UserRole.none;
  Student? _currentStudent;

  // Mock student list (In a real app, this would come from an API)
  final List<Student> _allStudents = [
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

  AuthProvider(this._persistence);

  UserRole get role => _role;
  Student? get currentStudent => _currentStudent;
  List<Student> get allStudents => _allStudents;

  Future<void> loadAuth() async {
    final auth = await _persistence.getAuth();
    final roleStr = auth['role'];
    final studentId = auth['studentId'];

    if (roleStr == UserRole.student.name && studentId != null) {
      _role = UserRole.student;
      _currentStudent = _allStudents.firstWhere((s) => s.id == studentId, orElse: () => _allStudents.first);
      
      // Load student data from persistence if exists
      final savedData = await _persistence.getStudentData(studentId);
      if (savedData != null) {
        _currentStudent = Student.fromJson(savedData);
      }
    } else if (roleStr == UserRole.teacher.name) {
      _role = UserRole.teacher;
    }
    notifyListeners();
  }

  void loginAsStudent() {
    _role = UserRole.student;
    _currentStudent = _allStudents.first;
    _persistence.saveAuth(_role.name, _currentStudent?.id);
    notifyListeners();
  }

  void loginAsTeacher() {
    _role = UserRole.teacher;
    _currentStudent = null;
    _persistence.saveAuth(_role.name, null);
    notifyListeners();
  }

  void logout() {
    _role = UserRole.none;
    _currentStudent = null;
    _persistence.saveAuth(_role.name, null);
    notifyListeners();
  }

  Future<void> updateCurrentStudent(Student student) async {
    _currentStudent = student;
    await _persistence.saveStudentData(student.id, student.toJson());
    notifyListeners();
  }
}
