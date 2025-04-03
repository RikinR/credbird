import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  Map<String, dynamic> get themeConfig => {
    "scaffoldBackground": const Color(0xFF0A0E21),
    "backgroundColor": const Color(0xFF12152D),
    "cardBackground": const Color(0xFF1D1F3A),
    "buttonHighlight": const Color(0xFF4E7AFF),
    "unhighlightedButton": const Color(0xFF6D6D80),
    "textColor": Colors.white,
    "secondaryText": const Color(0xFF8D8E98),
    "positiveAmount": const Color(0xFF4CAF50),
    "negativeAmount": const Color(0xFFFF5252),
    "cardGradient": const [Color(0xFF4E7AFF), Color(0xFF6A5ACD)],
    "buttonGradient": const [Color(0xFF4E7AFF), Color(0xFF3A5BBF)],
    "glassEffect": const Color(0x20FFFFFF),
  };

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
