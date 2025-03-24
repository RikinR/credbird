import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsageProvider extends ChangeNotifier {
  bool _isFirstTime;
  final SharedPreferences pref;

  UsageProvider({required this.pref}) : _isFirstTime = pref.getBool('isFirstTime') ?? true;

  bool get isFirstTime => _isFirstTime;

  void changeUseTime() async {
    _isFirstTime = false;
    await pref.setBool('isFirstTime', false);
    notifyListeners();
  }
}
