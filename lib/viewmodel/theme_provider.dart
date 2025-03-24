import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  Map<String, dynamic> get themeConfig =>
      _isDarkMode
          ? {
            "scaffoldBackground": const Color(0xFF0B0B0B),
            "containerColor": const Color(0xFF161616),
            "backgroundColor": const Color(0xFF101010),
            "highlightColor": const Color(0xFF252525),
            "switchActiveColor": const Color(0xFF303030),
            "switchInactiveColor": const Color(0xFF1A1A1A),
            "buttonHighlight": Colors.white,
            "textColor": Colors.white,
            "unhighlightedButton": Colors.grey.shade800,
          }
          : {
            "scaffoldBackground": const Color(0xFF0E1B33),
            "containerColor": const Color(0xFF162A4C),
            "backgroundColor": const Color(0xFF1C315E),
            "highlightColor": const Color(0xFF2A4B8D),
            "switchActiveColor": const Color(0xFF4C73B5),
            "switchInactiveColor": const Color(0xFF36598A),
            "buttonHighlight": Colors.white,
            "textColor": Colors.white,
            "unhighlightedButton": Colors.grey.shade600,
          };

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
