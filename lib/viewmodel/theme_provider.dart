import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  Map<String, dynamic> get themeConfig => {
        "scaffoldBackground": const Color(0xFF121212),
        "backgroundColor": const Color(0xFF1E1E1E),
        "cardBackground": const Color(0xFF242424),
        "buttonHighlight": const Color(0xFFBB86FC),
        "unhighlightedButton": Colors.grey[600],
        "textColor": Colors.white,
        "secondaryText": Colors.grey[400],
        "positiveAmount": const Color(0xFF4CAF50),
        "negativeAmount": const Color(0xFFF44336),
        "cardGradient": const [
          Color(0xFFBB86FC),
          Color(0xFF03DAC6),
        ],
      };

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}