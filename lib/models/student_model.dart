import '../subject_model.dart';

class Student {
  final String id;
  final String name;
  final String batch;
  final Map<String, Subject> subjects;
  String? hodLetterUrl; // Mock path or URL to proxy letter
  String? timetableUrl; // Mock path or URL to timetable

  Student({
    required this.id,
    required this.name,
    required this.batch,
    required this.subjects,
    this.hodLetterUrl,
    this.timetableUrl,
  });

  // Calculate overall attendance percentage across all subjects
  double get overallAttendance {
    if (subjects.isEmpty) return 0.0;
    int totalAttended = 0;
    int totalClasses = 0;
    
    for (var sub in subjects.values) {
      totalAttended += sub.attended;
      totalClasses += sub.total;
    }
    
    return totalClasses == 0 ? 0.0 : (totalAttended / totalClasses) * 100;
  }
}
