import 'package:flutter/material.dart';

/// Controlador global muy simple para alternar el ThemeMode.
/// Úsalo con AnimatedBuilder/ValueListenableBuilder o Provider si prefieres.
class ThemeController extends ChangeNotifier {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  ThemeMode _mode = ThemeMode.dark;
  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void toggle(bool dark) {
    _mode = dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
