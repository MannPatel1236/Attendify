class TimetableSlot {
  final String startTime;
  final String endTime;
  final String subject;
  final String subjectKey;
  final String type; // TH, PR, TUT, OE, BREAK
  final String? teacher;
  final String? room;
  final bool isBreak;

  const TimetableSlot({
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.subjectKey,
    required this.type,
    this.teacher,
    this.room,
    this.isBreak = false,
  });
}

class TimetableDay {
  final String dayName;
  final List<TimetableSlot> slots;

  const TimetableDay({required this.dayName, required this.slots});

  List<TimetableSlot> get classes => slots.where((s) => !s.isBreak).toList();
  int get classCount => classes.length;

  /// How many lectures per subject on this day
  Map<String, int> get subjectClassCount {
    final map = <String, int>{};
    for (var slot in classes) {
      if (slot.subjectKey != 'OE') {
        map[slot.subjectKey] = (map[slot.subjectKey] ?? 0) + 1;
      }
    }
    return map;
  }
}

const List<TimetableDay> weeklyTimetable = [
  // ─── Monday ──────────────────────────────────────────────
  TimetableDay(dayName: 'Monday', slots: [
    TimetableSlot(startTime: '08:00', endTime: '09:00', subject: 'Data Structures', subjectKey: 'DS (TH)', type: 'TH', teacher: 'RP', room: 'Room 51'),
    TimetableSlot(startTime: '09:00', endTime: '10:00', subject: 'Machine Learning - I', subjectKey: 'ML-I (TH)', type: 'TH', teacher: 'SSM', room: 'Room 51'),
    TimetableSlot(startTime: '10:00', endTime: '11:00', subject: 'Statistics for Data Science', subjectKey: 'SDS (TH)', type: 'TH', teacher: 'MA', room: 'Room 51'),
    TimetableSlot(startTime: '11:00', endTime: '12:00', subject: 'Break', subjectKey: 'BREAK', type: 'BREAK', isBreak: true),
    TimetableSlot(startTime: '12:00', endTime: '02:00', subject: 'Prof. & Business Comm.', subjectKey: 'PBC (TUT)', type: 'TUT', teacher: 'RVP', room: 'Lab L2'),
  ]),
  // ─── Tuesday ─────────────────────────────────────────────
  TimetableDay(dayName: 'Tuesday', slots: [
    TimetableSlot(startTime: '08:00', endTime: '10:00', subject: 'Open Elective', subjectKey: 'OE', type: 'OE'),
    TimetableSlot(startTime: '10:00', endTime: '11:00', subject: 'Economics & Financial Mgmt.', subjectKey: 'EFM (TH)', type: 'TH', teacher: 'MD', room: 'Room 51'),
    TimetableSlot(startTime: '11:00', endTime: '12:00', subject: 'Break', subjectKey: 'BREAK', type: 'BREAK', isBreak: true),
    TimetableSlot(startTime: '12:00', endTime: '02:00', subject: 'Web Engineering Lab', subjectKey: 'WE (PR)', type: 'PR', teacher: 'GW', room: 'Lab L3'),
    TimetableSlot(startTime: '02:00', endTime: '04:00', subject: 'Statistics for Data Science', subjectKey: 'SDS (PR)', type: 'PR', teacher: 'MD', room: 'Lab L3'),
  ]),
  // ─── Wednesday ───────────────────────────────────────────
  TimetableDay(dayName: 'Wednesday', slots: [
    TimetableSlot(startTime: '10:00', endTime: '12:00', subject: 'Machine Learning - I', subjectKey: 'ML-I (PR)', type: 'PR', teacher: 'SSM', room: 'Lab L4'),
    TimetableSlot(startTime: '12:00', endTime: '01:00', subject: 'Data Structures', subjectKey: 'DS (TH)', type: 'TH', teacher: 'RP', room: 'Room 52'),
    TimetableSlot(startTime: '01:00', endTime: '02:00', subject: 'Break', subjectKey: 'BREAK', type: 'BREAK', isBreak: true),
    TimetableSlot(startTime: '02:00', endTime: '03:00', subject: 'Statistics for Data Science', subjectKey: 'SDS (TH)', type: 'TH', teacher: 'MA', room: 'Room 52'),
    TimetableSlot(startTime: '03:00', endTime: '04:00', subject: 'Economics & Financial Mgmt.', subjectKey: 'EFM (TH)', type: 'TH', teacher: 'SF', room: 'Room 52'),
    TimetableSlot(startTime: '04:00', endTime: '06:00', subject: 'Web Engineering Lab', subjectKey: 'WE (PR)', type: 'PR', teacher: 'GW', room: 'Lab L3'),
  ]),
  // ─── Thursday ────────────────────────────────────────────
  TimetableDay(dayName: 'Thursday', slots: [
    TimetableSlot(startTime: '08:00', endTime: '09:00', subject: 'Open Elective', subjectKey: 'OE', type: 'OE'),
    TimetableSlot(startTime: '09:00', endTime: '10:00', subject: 'Data Structures', subjectKey: 'DS (TH)', type: 'TH', teacher: 'RP', room: 'Room 52'),
    TimetableSlot(startTime: '10:00', endTime: '11:00', subject: 'Machine Learning - I', subjectKey: 'ML-I (TH)', type: 'TH', teacher: 'SSM', room: 'Room 52'),
    TimetableSlot(startTime: '11:00', endTime: '12:00', subject: 'Comp. Methods & Pricing', subjectKey: 'CMPM (TH)', type: 'TH', teacher: 'MAA', room: 'Room 52'),
    TimetableSlot(startTime: '12:00', endTime: '01:00', subject: 'Break', subjectKey: 'BREAK', type: 'BREAK', isBreak: true),
    TimetableSlot(startTime: '01:00', endTime: '02:00', subject: 'Comp. Methods & Pricing', subjectKey: 'CMPM (TH)', type: 'TH', teacher: 'MAA', room: 'Room 46'),
  ]),
  // ─── Friday ──────────────────────────────────────────────
  TimetableDay(dayName: 'Friday', slots: [
    TimetableSlot(startTime: '10:00', endTime: '12:00', subject: 'Data Structures', subjectKey: 'DS (PR)', type: 'PR', teacher: 'RP', room: 'Lab L1'),
    TimetableSlot(startTime: '12:00', endTime: '01:00', subject: 'Statistics for Data Science', subjectKey: 'SDS (TH)', type: 'TH', teacher: 'MA', room: 'Room 52'),
    TimetableSlot(startTime: '01:00', endTime: '02:00', subject: 'Machine Learning - I', subjectKey: 'ML-I (TH)', type: 'TH', teacher: 'SSM', room: 'Room 52'),
    TimetableSlot(startTime: '02:00', endTime: '03:00', subject: 'Break', subjectKey: 'BREAK', type: 'BREAK', isBreak: true),
    TimetableSlot(startTime: '03:00', endTime: '04:00', subject: 'Comp. Methods & Pricing', subjectKey: 'CMPM (TH)', type: 'TH', teacher: 'MAA', room: 'Room 52'),
    TimetableSlot(startTime: '04:00', endTime: '06:00', subject: 'Comp. Methods & Pricing', subjectKey: 'CMPM (PR)', type: 'PR', teacher: 'MAA', room: 'Lab L3'),
  ]),
];
