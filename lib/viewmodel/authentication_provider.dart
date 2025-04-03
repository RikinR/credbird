import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userName;
  String? _userEmail;
  String? _userId;
  String? _dialCode;
  String? _phone;
  String? _userType;
  bool _rememberMe = false;

  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userId => _userId;
  String? get dialCode => _dialCode;
  String? get phone => _phone;
  String? get userType => _userType;
  bool get rememberMe => _rememberMe;

  AuthViewModel() {
    _loadUserSession();
  }

  Future<void> _loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userName = prefs.getString('userName') ?? "User";
    _userEmail = prefs.getString('userEmail') ?? "user@credbird.com";
    _userId = prefs.getString('userId') ?? "@user";
    _dialCode = prefs.getString('dialCode') ?? "+91";
    _phone = prefs.getString('phone') ?? "+91999999999";
    _userType = prefs.getString('userType') ?? "STUDENT";
    _rememberMe = prefs.getBool('rememberMe') ?? false;
    notifyListeners();
  }

  Future<void> login(String email, String password, String dialCode, String phone, String userType, bool rememberMe) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userName', "User");
      await prefs.setString('userEmail', email);
      await prefs.setString('userId', "@${email.split('@')[0]}");
      await prefs.setString('dialCode', dialCode);
      await prefs.setString('phone', phone);
      await prefs.setString('userType', userType);
      await prefs.setBool('rememberMe', rememberMe);

      _isLoggedIn = true;
      _userName = "User";
      _userEmail = email;
      _userId = "@${email.split('@')[0]}";
      _dialCode = dialCode;
      _phone = phone;
      _userType = userType;
      _rememberMe = rememberMe;
      notifyListeners();
    }
  }

  Future<bool> logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmed) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      _isLoggedIn = false;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> updateProfile(String name, String email, String dialCode, String phone, String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    await prefs.setString('dialCode', dialCode);
    await prefs.setString('phone', phone);
    await prefs.setString('userType', userType);

    _userName = name;
    _userEmail = email;
    _dialCode = dialCode;
    _phone = phone;
    _userType = userType;
    notifyListeners();
  }
}