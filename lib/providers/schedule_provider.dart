import 'package:flutter/material.dart';
import '../services/persistence_service.dart';

class ScheduleProvider extends ChangeNotifier {
  final PersistenceService _persistence;
  final Set<String> _holidays = {};
  final Set<String> _cancelledLectures = {};

  ScheduleProvider(this._persistence);

  Set<String> get holidays => _holidays;
  Set<String> get cancelledLectures => _cancelledLectures;

  String get todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  bool get isTodayHoliday => _holidays.contains(todayKey);

  Future<void> loadSchedule() async {
    final hols = await _persistence.getHolidays();
    final cans = await _persistence.getCancelledLectures();
    _holidays.addAll(hols);
    _cancelledLectures.addAll(cans);
    notifyListeners();
  }

  void toggleTodayHoliday() {
    if (isTodayHoliday) {
      _holidays.remove(todayKey);
    } else {
      _holidays.add(todayKey);
    }
    _persistence.saveHolidays(_holidays.toList());
    notifyListeners();
  }

  void unmarkTodayAsHoliday() {
    _holidays.remove(todayKey);
    _persistence.saveHolidays(_holidays.toList());
    notifyListeners();
  }

  String _cancelKey(String subjectKey, int slotIndex) =>
      '${todayKey}_${subjectKey}_$slotIndex';

  bool isLectureCancelledToday(String subjectKey, int slotIndex) =>
      _cancelledLectures.contains(_cancelKey(subjectKey, slotIndex));

  void toggleLectureCancelled(String subjectKey, int slotIndex) {
    final key = _cancelKey(subjectKey, slotIndex);
    if (_cancelledLectures.contains(key)) {
      _cancelledLectures.remove(key);
    } else {
      _cancelledLectures.add(key);
    }
    _persistence.saveCancelledLectures(_cancelledLectures.toList());
    notifyListeners();
  }
}
