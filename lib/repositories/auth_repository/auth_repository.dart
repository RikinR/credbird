// ignore_for_file: avoid_print, non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:credbird/model/auth_models/user_model.dart';
import 'package:credbird/model/user_models/addtional_details.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  late final String baseUrl;
  late final String apiPrefix;
  late final String p_key;
  late final Future<String?> token;

  AuthRepository() {
    baseUrl = dotenv.get('API_DOMAIN');
    apiPrefix = dotenv.get('API_PREFIX');
    p_key = dotenv.get('P_KEY');
    print('[AuthRepository] Initialized with baseUrl: $baseUrl');
    token = _loadToken();
  }

  Future<void> _saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> _loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
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
        User user = User.fromJson(responseData['data']);
        _saveToken(user.token);
        return user;
      } else {
        print('[login] Login failed: ${jsonEncode(responseData)}');
        throw Exception(jsonEncode(responseData));
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
        print('[signup] Signup failed: ${jsonEncode(responseData)}');
        throw Exception(jsonEncode(responseData));
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

    int _otp = int.parse(otp);

    final body = jsonEncode({'username': username, 'otp': _otp});

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
          '[signupwithoutOtp] Signup (no OTP) failed: ${jsonEncode(responseData)}',
        );
        throw Exception(jsonEncode(responseData));
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

  Future<void> resetPassword({required String password}) async {
    final token = await _loadToken();
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

  Future<Map<String, dynamic>> getUserDetails() async {
    final token = await _loadToken();
    print('token value is : $token');
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/myProfile');
    final headers = {
      'Content-Type': 'application/json',
      'p-key': p_key,
      'Authorization': 'Bearer $token',
    };

    print('[getUserDetails] Sending GET request to $url');
    try {
      final response = await http.get(url, headers: headers);
      print('[getUserDetails] Response status: ${response.statusCode}');
      final responseData = jsonDecode(response.body);
      print('[getUserDetails] Response data: $responseData');

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('[getUserDetails] User details fetched successfully');
        return responseData['data'];
      } else {
        print('[getUserDetails] Failed: ${responseData['message']}');
        throw Exception(
          responseData['message'] ?? 'Failed to fetch user details',
        );
      }
    } catch (e) {
      print('[getUserDetails] Error occurred: $e');
      rethrow;
    }
  }

  Future<void> updateAdditionalDetails(AdditionalDetailsModel details) async {
    final token = await _loadToken();
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/updateAdditionalDetail');
    final headers = {
      'Content-Type': 'application/json',
      'p-key': p_key,
      'Authorization': 'Bearer $token',
    };

    final body = {
      'businessAddress': details.businessAddress,
      'businessCity': details.businessCity,
      'businessCountry': details.businessCountry?.toUpperCase(),
      'businessPin': details.businessPin,
      'businessState': details.businessState,
    };

    print('DEBUG: updateAdditionalDetails ');
    print('URL: $url');
    print('Token: $token');
    print('Headers: ${jsonEncode(headers)}');
    print('Request Body: ${jsonEncode(body)}');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Raw Response Body: ${response.body}');

      final responseData = jsonDecode(response.body);
      print('Parsed Response Data: $responseData');

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('[updateAdditionalDetails] Success');
      } else {
        print(
          '[updateAdditionalDetails] Failed: ${responseData['error']?['msg'] ?? responseData['message']}',
        );
        throw Exception(
          responseData['error']?['msg'] ??
              responseData['message'] ??
              'Failed to update additional details',
        );
      }
    } catch (e) {
      print('[updateAdditionalDetails]  Error occurred: $e');
      rethrow;
    }
  }

  Future<void> updateContactDetails({
    required String name,
    required String email,
    required String mobile,
    required String id,
  }) async {
    final token = await _loadToken();
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/addUpdateContactDetail');
    final headers = {
      'Content-Type': 'application/json',
      'p-key': p_key,
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'name': name,
      'email': email,
      'mobile': mobile,
      '_id': id,
      'status': 'ACTIVE',
    });

    print(
      '[updateContactDetails] Sending POST request to $url with body: $body',
    );
    try {
      final response = await http.post(url, headers: headers, body: body);
      print('[updateContactDetails] Response status: ${response.statusCode}');
      final responseData = jsonDecode(response.body);
      print('[updateContactDetails] Response data: $responseData');

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('[updateContactDetails] Contact details updated successfully');
      } else {
        print('[updateContactDetails] Failed: ${responseData['message']}');
        throw Exception(
          responseData['message'] ?? 'Failed to update contact details',
        );
      }
    } catch (e) {
      print('[updateContactDetails] Error occurred: $e');
      rethrow;
    }
  }
}
