import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  Map<String, dynamic> get themeConfig => {
    "scaffoldBackground": const Color(0xFF121212),
    "backgroundColor": const Color(0xFF121212),
    "cardBackground": const Color(0xFF121212),
    "buttonHighlight": const Color(0xFFE0E0E0),
    "unhighlightedButton": const Color(0xFFE0E0E0),
    "textColor": const Color(0xFFE0E0E0),
    "secondaryText": const Color(0xFFE0E0E0),
    "positiveAmount": const Color(0xFF66BB6A),
    "negativeAmount": const Color(0xFFFF5252),
    "cardGradient": const [Color(0xFF121212), Color(0xFFE0E0E0)],
    "buttonGradient": const [Color(0xFF121212), Color(0xFFE0E0E0)],
    "glassEffect": const Color(0xFFE0E0E0),
  };

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
