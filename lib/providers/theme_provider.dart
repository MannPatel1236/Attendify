import 'package:flutter/material.dart';
import '../services/persistence_service.dart';

class ThemeProvider extends ChangeNotifier {
  final PersistenceService _persistence;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider(this._persistence);

  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    final saved = await _persistence.getTheme();
    if (saved == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (saved == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.system;
    } else {
      _themeMode = ThemeMode.dark;
    }
    _persistence.saveTheme(_themeMode.name);
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
}
