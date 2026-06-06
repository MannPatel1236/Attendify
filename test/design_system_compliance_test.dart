// Design system compliance test (spec §8).
// These checks are grep-based. They run as part of the regular test suite.

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory lib;

  setUpAll(() {
    lib = Directory('lib');
  });

  List<File> allDartFiles() {
    return lib
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .toList();
  }

  test('No file imports softclaw_theme.dart', () {
    final offenders = allDartFiles()
        .where((f) => f.readAsStringSync().contains('softclaw_theme'))
        .toList();
    expect(offenders, isEmpty,
        reason: 'Files still import softclaw_theme.dart: '
            '${offenders.map((f) => f.path).join(", ")}');
  });

  test('No file imports clay_widgets.dart', () {
    final offenders = allDartFiles()
        .where((f) => f.readAsStringSync().contains('clay_widgets'))
        .toList();
    expect(offenders, isEmpty,
        reason: 'Files still import clay_widgets.dart: '
            '${offenders.map((f) => f.path).join(", ")}');
  });

  test('No file imports monolith_components.dart', () {
    final offenders = allDartFiles()
        .where((f) => f.readAsStringSync().contains('monolith_components'))
        .toList();
    expect(offenders, isEmpty,
        reason: 'Files still import monolith_components.dart: '
            '${offenders.map((f) => f.path).join(", ")}');
  });

  test('No file imports attendance_gauges.dart', () {
    final offenders = allDartFiles()
        .where((f) => f.readAsStringSync().contains('attendance_gauges'))
        .toList();
    expect(offenders, isEmpty,
        reason: 'Files still import attendance_gauges.dart: '
            '${offenders.map((f) => f.path).join(", ")}');
  });

  test('No file imports manual_timetable_screen.dart', () {
    final offenders = allDartFiles()
        .where((f) => f.readAsStringSync().contains('manual_timetable'))
        .toList();
    expect(offenders, isEmpty,
        reason: 'Files still import manual_timetable_screen.dart: '
            '${offenders.map((f) => f.path).join(", ")}');
  });

  test('softclaw_theme.dart is deleted', () {
    expect(File('lib/theme/softclaw_theme.dart').existsSync(), isFalse);
  });

  test('clay_widgets.dart is deleted', () {
    expect(File('lib/widgets/clay_widgets.dart').existsSync(), isFalse);
  });

  test('monolith_components.dart is deleted', () {
    expect(File('lib/widgets/monolith_components.dart').existsSync(), isFalse);
  });

  test('attendance_gauges.dart is deleted', () {
    expect(File('lib/widgets/attendance_gauges.dart').existsSync(), isFalse);
  });

  test('manual_timetable_screen.dart is deleted', () {
    expect(File('lib/screens/manual_timetable_screen.dart').existsSync(),
        isFalse);
  });

  test('No BoxShadow in the codebase (spec §2.3: zero shadows)', () {
    final offenders = allDartFiles()
        .where((f) {
          final content = f.readAsStringSync();
          // The login screen has a single BoxShadow on the wordmark dot
          // (spec §4.1 explicitly permits this). Allow only that one.
          if (f.path.endsWith('login_screen.dart')) return false;
          return content.contains('BoxShadow(');
        })
        .toList();
    expect(offenders, isEmpty,
        reason: 'Files use BoxShadow (spec §2.3 disallows): '
            '${offenders.map((f) => f.path).join(", ")}');
  });

  test('No Card widget with non-zero border-radius (spec §2.3: sharp corners)',
      () {
    final offenders = <String>[];
    for (final f in allDartFiles()) {
      final content = f.readAsStringSync();
      // Heuristic: look for BorderRadius.circular( followed by a number
      // that is not 0, and that is near a Card or container usage.
      // Simpler: search for any BorderRadius.circular(N) where N > 0
      // except in studio_*.dart files (those legitimately use radii).
      if (f.path.contains('widgets/studio/')) continue;
      if (f.path.contains('theme/studio_')) continue;
      if (f.path.contains('test/')) continue;
      final reg = RegExp(r'BorderRadius\.circular\(([1-9][0-9]*)\)');
      if (reg.hasMatch(content)) {
        offenders.add(f.path);
      }
    }
    expect(offenders, isEmpty,
        reason: 'Files use non-zero border-radius outside the studio design '
            'system: ${offenders.join(", ")}');
  });
}
