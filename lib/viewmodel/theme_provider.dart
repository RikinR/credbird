import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Map<String, dynamic> get themeConfig =>
      _isDarkMode ? _darkTheme : _lightTheme;

  final Map<String, dynamic> _darkTheme = {
    "scaffoldBackground": const Color(0xFF121212),
    "backgroundColor": const Color(0xFF121212),
    "cardBackground": const Color(0xFF121212),
    "buttonBackground": const Color(0xFF121212),
    "buttonHighlight": const Color(0xFFE0E0E0),
    "unhighlightedButton": const Color(0xFFE0E0E0),
    "textColor": const Color(0xFFE0E0E0),
    "secondaryText": const Color(0xFFE0E0E0),
    "positiveAmount": const Color(0xFF66BB6A),
    "negativeAmount": const Color(0xFFFF5252),
    "cardGradient": const [Color(0xFF121212), Color(0xFFE0E0E0)],
    "buttonGradient": const [Color(0xFF121212), Color(0xFFE0E0E0)],
    "glassEffect": const Color(0xFFE0E0E0),
    "textStyle": GoogleFonts.inter(),
    "headingStyle": GoogleFonts.inter(fontWeight: FontWeight.bold),
    "elevation": 0.0,
    "buttonElevation": 0.0,
    "appBarElevation": 0.0,
    "scrolledUnderElevation": 0.0,
    "borderRadius": 8.0,
  };

  final Map<String, dynamic> _lightTheme = {
    "scaffoldBackground": const Color(0xFFF8F8F8),
    "backgroundColor": const Color(0xFFF8F8F8),
    "cardBackground": const Color(0xFFFFFFFF),
    "buttonBackground": const Color(0xFFFFFFFF),
    "buttonHighlight": const Color.fromARGB(255, 99, 37, 207),
    "unhighlightedButton": const Color(0xFF8B5CF6),
    "textColor": const Color.fromARGB(233, 24, 24, 27),
    "secondaryText": const Color.fromARGB(255, 111, 42, 231),
    "positiveAmount": const Color(0xFF66BB6A),
    "negativeAmount": const Color(0xFFFF5252),
    "cardGradient": const [Color(0xFFFFFFFF), Color(0xFFF8F8F8)],
    "buttonGradient": const [
      Color.fromARGB(255, 111, 42, 231),
      Color.fromARGB(255, 111, 42, 231),
    ],
    "glassEffect": const Color.fromARGB(255, 111, 42, 231).withOpacity(0.1),
    "textStyle": GoogleFonts.inter(),
    "headingStyle": GoogleFonts.inter(fontWeight: FontWeight.bold),
    "elevation": 0.0,
    "buttonElevation": 0.0,
    "appBarElevation": 0.0,
    "scrolledUnderElevation": 0.0,
    "borderRadius": 8.0,
  };

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
