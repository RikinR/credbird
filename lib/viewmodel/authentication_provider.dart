import 'package:credbird/model/auth_models/user_model.dart';
import 'package:credbird/model/user_models/addtional_details.dart';
import 'package:credbird/repositories/auth_repository/auth_repository.dart';
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
  User? _user;
  bool _isLoading = false;
  String? _error;
  final AuthRepository authRepository;
  AdditionalDetailsModel? _additionalDetails;
  String? _contactId;

  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userId => _userId;
  String? get dialCode => _dialCode;
  String? get phone => _phone;
  String? get userType => _userType;
  bool get rememberMe => _rememberMe;
  bool get isLoading => _isLoading;
  String? get error => _error;
  AdditionalDetailsModel? get additionalDetails => _additionalDetails;
  String? get contactId => _contactId;

  AuthViewModel(this.authRepository) {
    _loadUserSession();
  }

  Future<void> _loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _rememberMe = prefs.getBool('rememberMe') ?? false;
    _contactId = prefs.getString('contactId');

    if (_isLoggedIn) {
      _user = User(
        id: prefs.getString('userId') ?? '',
        name: prefs.getString('userName') ?? '',
        email: prefs.getString('userEmail') ?? '',
        phone: prefs.getString('phone') ?? '',
        userType: prefs.getString('userType') ?? 'STUDENT',
        token: prefs.getString('token') ?? '',
        accountVerified: prefs.getBool('accountVerified') ?? false,
        isActive: prefs.getBool('isActive') ?? false,
        walletAmount: prefs.getDouble('walletAmount') ?? 0,
        lastOnline:
            prefs.getString('lastOnline') != null
                ? DateTime.tryParse(prefs.getString('lastOnline')!)
                : null,
      );
      _userId = _user?.id;
    }
    notifyListeners();
  }

  Future<void> login({
    required String username,
    required String password,
    required bool rememberMe,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('Username and password are required');
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await authRepository.login(
        username: username,
        password: password,
        rememberMe: rememberMe,
      );

      await _saveUserData(user, rememberMe);
      _isLoggedIn = true;
      _user = user;
      _rememberMe = rememberMe;
      _userId = user.id;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String username,
    required String otp,
  }) async {
    if (username.isEmpty || otp.isEmpty) {
      throw Exception('Username and OTP are required');
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await authRepository.verifyOtp(
        username: username,
        otp: otp,
      );

      final user = _user?.copyWith(
        token: response['token'],
        userType: response['userType'],
      );

      if (user != null) {
        await _saveUserData(user, _rememberMe);
        _isLoggedIn = true;
        _user = user;
        _userId = user.id;
      }

      return response;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signup({
    required String email,
    required String password,
    required String dialCode,
    required String phone,
    required String userType,
  }) async {
    if (email.isEmpty || password.isEmpty || phone.isEmpty) {
      throw Exception('Email, password and phone are required');
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await authRepository.signup(
        email: email,
        password: password,
        dialCode: dialCode,
        phone: phone,
        userType: userType,
      );

      _user = user;
      _userId = user.id;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signupwithoutOtp({
    required String email,
    required String password,
    required String dialCode,
    required String phone,
    required String userType,
  }) async {
    if (email.isEmpty || password.isEmpty || phone.isEmpty) {
      throw Exception('Email, password and phone are required');
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await authRepository.signupwithoutOtp(
        email: email,
        password: password,
        dialCode: dialCode,
        phone: phone,
        userType: userType,
      );

      await _saveUserData(user, false);
      _isLoggedIn = true;
      _user = user;
      _rememberMe = false;
      _userId = user.id;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveUserData(User user, bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', user.id);
    await prefs.setString('userName', user.name);
    await prefs.setString('userEmail', user.email);
    await prefs.setString('phone', user.phone);
    await prefs.setString('userType', user.userType);
    await prefs.setString('token', user.token);
    await prefs.setBool('accountVerified', user.accountVerified);
    await prefs.setBool('isActive', user.isActive);
    await prefs.setDouble('walletAmount', user.walletAmount);
    if (user.lastOnline != null) {
      await prefs.setString('lastOnline', user.lastOnline!.toIso8601String());
    }
    await prefs.setBool('rememberMe', rememberMe);
  }

  Future<bool> logout(BuildContext context) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
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

  Future<void> updateProfile(
    String name,
    String email,
    String dialCode,
    String phone,
    String userType,
  ) async {
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

  Future<void> forgotPassword({required String email}) async {
    if (email.isEmpty) {
      throw Exception('Email is required');
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await authRepository.forgotPassword(email: email);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword({required String password}) async {
    if (password.isEmpty) {
      throw Exception('Password is required');
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await authRepository.resetPassword(password: password);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserDetails() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await authRepository.getUserDetails();
      final userData = response['findUser'];
      final contactData =
          response['findContact']?.isNotEmpty == true
              ? response['findContact'][0]
              : null;

      _userName = userData['name'];
      _userEmail = userData['email'];
      _phone = userData['phone']?.toString();
      _userType = userData['userType'];
      _userId = userData['_id'];

      if (contactData != null) {
        _contactId = contactData['_id'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('contactId', _contactId!);
      }

      if (contactData != null) {
        _additionalDetails = AdditionalDetailsModel();
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _userName ?? '');
      await prefs.setString('userEmail', _userEmail ?? '');
      await prefs.setString('phone', _phone ?? '');
      await prefs.setString('userType', _userType ?? 'STUDENT');
      await prefs.setString('userId', _userId ?? '');
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAdditionalDetails(AdditionalDetailsModel details) async {
    _isLoading = true;
    notifyListeners();

    try {
      await authRepository.updateAdditionalDetails(details);
      _additionalDetails = details;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateContactDetails({
    required String name,
    required String email,
    required String mobile,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await authRepository.updateContactDetails(
        name: name,
        email: email,
        mobile: mobile,
        id: _contactId!,
      );

      _userName = name;
      _userEmail = email;
      _phone = mobile;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', name);
      await prefs.setString('userEmail', email);
      await prefs.setString('phone', mobile);

      if (_user != null) {
        _user = _user!.copyWith(name: name, email: email, phone: mobile);
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
