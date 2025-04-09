// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:credbird/model/auth_models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  late final String baseUrl;
  late final String apiPrefix;
  late final String p_key;

  AuthRepository() {
    baseUrl = dotenv.get('API_DOMAIN');
    apiPrefix = dotenv.get('API_PREFIX');
    p_key = dotenv.get('P_KEY');
    print('[AuthRepository] Initialized with baseUrl: $baseUrl');
  }

  Future<User> login({
    required String username,
    required String password,
    required bool rememberMe,
  }) async {
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/login');
    final headers = {'Content-Type': 'application/json', 'p-key': p_key};
    final body = jsonEncode({
      'username': username,
      'password': password,
      'rememberMe': rememberMe,
    });

    print('[login] Sending POST request to $url with body: $body');
    try {
      final response = await http.post(url, headers: headers, body: body);
      print('[login] Response status: ${response.statusCode}');
      final responseData = jsonDecode(response.body);
      print('[login] Response data: $responseData');

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('[login] Login successful for user: $username');
        return User.fromJson(responseData['data']);
      } else {
        print('[login] Login failed: ${responseData['message']}');
        throw Exception(responseData['message'] ?? 'Login failed');
      }
    } catch (e) {
      print('[login] Error occurred: $e');
      rethrow;
    }
  }

  Future<User> signup({
    required String email,
    required String password,
    required String dialCode,
    required String phone,
    required String userType,
  }) async {
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/signup');
    final headers = {'Content-Type': 'application/json', 'p-key': p_key};
    final body = jsonEncode({
      'email': email,
      'password': password,
      'dialCode': dialCode,
      'phone': phone,
      'userType': userType,
    });

    print('[signup] Sending POST request to $url with body: $body');
    try {
      final response = await http.post(url, headers: headers, body: body);
      print('[signup] Response status: ${response.statusCode}');
      final responseData = jsonDecode(response.body);
      print('[signup] Response data: $responseData');

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('[signup] Signup successful for email: $email');
        return User.fromJson(responseData['data']);
      } else {
        print('[signup] Signup failed: ${responseData['message']}');
        throw Exception(responseData['message'] ?? 'Signup failed');
      }
    } catch (e) {
      print('[signup] Error occurred: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String username,
    required String otp,
  }) async {
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/verifyOtp');
    final headers = {'Content-Type': 'application/json', 'p-key': p_key};
    final body = jsonEncode({'username': username, 'otp': otp});

    print('[verifyOtp] Sending POST request to $url with body: $body');
    try {
      final response = await http.post(url, headers: headers, body: body);
      print('[verifyOtp] Response status: ${response.statusCode}');
      final responseData = jsonDecode(response.body);
      print('[verifyOtp] Response data: $responseData');

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('[verifyOtp] OTP verified for user: $username');
        return responseData['data'];
      } else {
        print(
          '[verifyOtp] OTP verification failed: ${responseData['message']}',
        );
        throw Exception(responseData['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      print('[verifyOtp] Error occurred: $e');
      rethrow;
    }
  }

  Future<User> signupwithoutOtp({
    required String email,
    required String password,
    required String dialCode,
    required String phone,
    required String userType,
  }) async {
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/signup-internal');
    final headers = {'Content-Type': 'application/json', 'p-key': p_key};
    final body = jsonEncode({
      'email': email,
      'password': password,
      'dialCode': dialCode,
      'phone': phone,
      'userType': userType,
    });

    print('[signupwithoutOtp] Sending POST request to $url with body: $body');
    try {
      final response = await http.post(url, headers: headers, body: body);
      print('[signupwithoutOtp] Response status: ${response.statusCode}');
      final responseData = jsonDecode(response.body);
      print('[signupwithoutOtp] Response data: $responseData');

      if (response.statusCode == 200 && responseData['success'] == true) {
        print(
          '[signupwithoutOtp] Signup (no OTP) successful for email: $email',
        );
        return User.fromJson(responseData['data']);
      } else {
        print(
          '[signupwithoutOtp] Signup (no OTP) failed: ${responseData['message']}',
        );
        throw Exception(responseData['message'] ?? 'Signup failed');
      }
    } catch (e) {
      print('[signupwithoutOtp] Error occurred: $e');
      rethrow;
    }
  }

  Future<void> forgotPassword({required String email}) async {
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/forgotPassword');
    final headers = {'Content-Type': 'application/json', 'p-key': p_key};
    final body = jsonEncode({'username': email});

    print('[forgotPassword] Sending POST request to $url with body: $body');
    try {
      final response = await http.post(url, headers: headers, body: body);
      print('[forgotPassword] Response status: ${response.statusCode}');
      final responseData = jsonDecode(response.body);
      print('[forgotPassword] Response data: $responseData');

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('[forgotPassword] Reset link sent to: $email');
      } else {
        print('[forgotPassword] Failed: ${responseData['message']}');
        throw Exception(responseData['message'] ?? 'Failed to send reset link');
      }
    } catch (e) {
      print('[forgotPassword] Error occurred: $e');
      rethrow;
    }
  }

  Future<void> resetPassword({
    required String password,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/changePassword');
    final headers = {
      'Content-Type': 'application/json',
      'p-key': p_key,
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({'password': password});

    print('[resetPassword] Sending POST request to $url');
    try {
      final response = await http.post(url, headers: headers, body: body);
      print('[resetPassword] Response status: ${response.statusCode}');
      final responseData = jsonDecode(response.body);
      print('[resetPassword] Response data: $responseData');

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('[resetPassword] Password reset successful');
      } else {
        print('[resetPassword] Failed: ${responseData['message']}');
        throw Exception(responseData['message'] ?? 'Failed to reset password');
      }
    } catch (e) {
      print('[resetPassword] Error occurred: $e');
      rethrow;
    }
  }
}
