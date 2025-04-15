// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:credbird/model/registration_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationRepository {
  late final String baseUrl;
  late final String apiPrefix;
  late final String pKey;
  late final Future<String?> token;

  RegistrationRepository() {
    print('[RegistrationRepository] Initializing repository...');
    baseUrl = dotenv.get('API_DOMAIN');
    apiPrefix = dotenv.get('API_PREFIX');
    pKey = dotenv.get('P_KEY');
    print('[RegistrationRepository] Configuration loaded:');
    print('  - baseUrl: $baseUrl');
    print('  - apiPrefix: $apiPrefix');
    print('  - pKey: ${pKey.isNotEmpty ? '*****' : 'EMPTY'}');

    token = _loadToken();
    print('[RegistrationRepository] Token loading initiated');
  }

  Future<String?> _loadToken() async {
    print('[RegistrationRepository] Loading token from SharedPreferences...');
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print(
        '[RegistrationRepository] Token loaded: ${token != null ? '*****' : 'NULL'}',
      );
      return token;
    } catch (e) {
      print('[RegistrationRepository] ERROR loading token: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyPan(String panNumber) async {
    print(
      '[PAN Verification] Starting verification for PAN: ${panNumber.replaceRange(2, 6, '****')}',
    );
    final tokenValue = await token;
    print(
      '[PAN Verification] Using token: ${tokenValue != null ? '*****' : 'NULL'}',
    );

    final url = Uri.parse('$baseUrl$apiPrefix/p-access/registerFormValidation');
    print('[PAN Verification] API Endpoint: $url');

    final headers = {
      'Content-Type': 'application/json',
      'p-key': pKey,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    final body = jsonEncode({"id": panNumber, "type": "PAN"});

    print('[PAN Verification] Request Headers: ${headers.keys.join(', ')}');
    print(
      '[PAN Verification] Request Body: ${body.replaceAll(panNumber, panNumber.replaceRange(2, 6, '****'))}',
    );

    try {
      print('[PAN Verification] Making API request...');
      final response = await http.post(url, headers: headers, body: body);
      print(
        '[PAN Verification] Response received. Status: ${response.statusCode}',
      );

      final responseData = jsonDecode(response.body);
      print(
        '[PAN Verification] Response Data: ${responseData.toString().length > 200 ? '${responseData.toString().substring(0, 200)}...' : responseData}',
      );

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('[PAN Verification] Verification successful!');
        print(
          '[PAN Verification] Verified Name: ${responseData['data']['full_name']}',
        );
        print(
          '[PAN Verification] Verified ID: ${responseData['data']['verifiedId']}',
        );
        return responseData['data'];
      } else {
        final errorMsg = responseData['message'] ?? 'PAN verification failed';
        print('[PAN Verification] Verification failed: $errorMsg');
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('[PAN Verification] ERROR during verification: $e');
      print(
        '[PAN Verification] Stack trace: ${e is Error ? e.stackTrace : ''}',
      );
      throw Exception('Failed to verify PAN: $e');
    }
  }

  Future<Map<String, dynamic>> verifyBankDetails(
    String accountNumber,
    String ifsc,
  ) async {
    print(
      '[Bank Verification] Starting verification for Account: ${accountNumber.replaceRange(2, accountNumber.length - 2, '****')}',
    );
    print('[Bank Verification] IFSC Code: $ifsc');
    final tokenValue = await token;
    print(
      '[Bank Verification] Using token: ${tokenValue != null ? '*****' : 'NULL'}',
    );

    final url = Uri.parse('$baseUrl$apiPrefix/p-access/registerFormValidation');
    print('[Bank Verification] API Endpoint: $url');

    final headers = {
      'Content-Type': 'application/json',
      'p-key': pKey,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    final body = jsonEncode({
      "id": accountNumber,
      "type": "BANK",
      "ifsc": ifsc,
    });

    print('[Bank Verification] Request Headers: ${headers.keys.join(', ')}');
    print(
      '[Bank Verification] Request Body: ${body.replaceAll(accountNumber, accountNumber.replaceRange(2, accountNumber.length - 2, '****'))}',
    );

    try {
      print('[Bank Verification] Making API request...');
      final response = await http.post(url, headers: headers, body: body);
      print(
        '[Bank Verification] Response received. Status: ${response.statusCode}',
      );

      final responseData = jsonDecode(response.body);
      print(
        '[Bank Verification] Response Data: ${responseData.toString().length > 200 ? '${responseData.toString().substring(0, 200)}...' : responseData}',
      );

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('[Bank Verification] Verification successful!');
        print(
          '[Bank Verification] Account Name: ${responseData['data']['full_name']}',
        );
        print(
          '[Bank Verification] Verified ID: ${responseData['data']['verifiedId']}',
        );
        return responseData['data'];
      } else {
        final errorMsg = responseData['message'] ?? 'Bank verification failed';
        print('[Bank Verification] Verification failed: $errorMsg');
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('[Bank Verification] ERROR during verification: $e');
      print(
        '[Bank Verification] Stack trace: ${e is Error ? e.stackTrace : ''}',
      );
      throw Exception('Failed to verify bank details: $e');
    }
  }

  Future<Map<String, dynamic>> verifyGst(String gstNumber) async {
    print(
      '[GST Verification] Starting verification for GST: ${gstNumber.replaceRange(2, gstNumber.length - 2, '****')}',
    );
    final tokenValue = await token;
    print(
      '[GST Verification] Using token: ${tokenValue != null ? '*****' : 'NULL'}',
    );

    final url = Uri.parse('$baseUrl$apiPrefix/p-access/getGstData');
    print('[GST Verification] API Endpoint: $url');

    final headers = {
      'Content-Type': 'application/json',
      'p-key': pKey,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    final body = jsonEncode({"gst": gstNumber});

    print('[GST Verification] Request Headers: ${headers.keys.join(', ')}');
    print(
      '[GST Verification] Request Body: ${body.replaceAll(gstNumber, gstNumber.replaceRange(2, gstNumber.length - 2, '****'))}',
    );

    try {
      print('[GST Verification] Making API request...');
      final response = await http.post(url, headers: headers, body: body);
      print(
        '[GST Verification] Response received. Status: ${response.statusCode}',
      );

      final responseData = jsonDecode(response.body);
      print(
        '[GST Verification] Full Response Data Length: ${responseData.toString().length}',
      );
      print('[GST Verification] Response Success: ${responseData['success']}');
      print('[GST Verification] Response Message: ${responseData['message']}');

      if (response.statusCode == 200 && responseData['success'] == true) {
        final gstData = responseData['data']?['data'];
        if (gstData == null) {
          throw Exception('GST data not found in response');
        }

        final details = gstData['details'];
        final contactDetails = details?['contact_details']?['principal'];

        print('[GST Verification] Verification successful!');
        print(
          '[GST Verification] Business Name: ${details?['legal_name'] ?? details?['business_name'] ?? 'N/A'}',
        );
        print(
          '[GST Verification] Business Address: ${contactDetails?['address'] ?? 'N/A'}',
        );

        return {
          'businessName': details?['legal_name'] ?? details?['business_name'],
          'businessAddress': contactDetails?['address'],
          'gstVerifiedId': gstData['client_id'],
          'email': gstData['email'],
          'mobile': gstData['mobile'],
          'panNumber': details?['pan_number'],
        };
      } else {
        final errorMsg = responseData['message'] ?? 'GST verification failed';
        print('[GST Verification] Verification failed: $errorMsg');
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('[GST Verification] ERROR during verification: $e');
      print(
        '[GST Verification] Stack trace: ${e is Error ? e.stackTrace : ''}',
      );
      throw Exception('Failed to verify GST: $e');
    }
  }

  Future<Map<String, dynamic>> completeRegistration(
    RegistrationModel data,
  ) async {
    print('[Registration] Starting registration completion...');
    final tokenValue = await token;
    print(
      '[Registration] Using token: ${tokenValue != null ? '*****' : 'NULL'}',
    );

    final url = Uri.parse('$baseUrl$apiPrefix/p-access/register');
    print('[Registration] API Endpoint: $url');

    final headers = {
      'Content-Type': 'application/json',
      'p-key': pKey,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    final body = jsonEncode({
      "passport": data.passport,
      "pan": data.panNumber,
      "tcsRate": data.tcsRate,
      "verifiedId": data.verifiedId,
      "name": data.fullName,
      "mobile": data.mobile,
      "email": data.email,
      "orgAddress": data.orgAddress,
      "orgPin": data.orgPin,
      "orgCity": data.orgCity,
      "orgState": data.orgState,
      "orgCountry": data.orgCountry,
      if (data.businessAddress != null) "businessAddress": data.businessAddress,
      if (data.businessPin != null) "businessPin": data.businessPin,
      if (data.businessCity != null) "businessCity": data.businessCity,
      if (data.businessState != null) "businessState": data.businessState,
      if (data.businessCountry != null) "businessCountry": data.businessCountry,
      "contactDetail": data.contactDetails.map((e) => e.toJson()).toList(),
      "bankDetail": data.bankDetails.map((e) => e.toJson()).toList(),
    });

    print('[Registration] Request Headers: ${headers.keys.join(', ')}');
    print('[Registration] Making API request...');

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('[Registration] Response received. Status: ${response.statusCode}');

      final responseData = jsonDecode(response.body);
      print(
        '[Registration] Response Data: ${responseData.toString().length > 200 ? '${responseData.toString().substring(0, 200)}...' : responseData}',
      );

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('[Registration] Registration successful!');
        return responseData['data'];
      } else {
        final errorMsg = responseData['message'] ?? 'Registration failed';
        print('[Registration] Registration failed: $errorMsg');
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('[Registration] ERROR during registration: $e');
      print('[Registration] Stack trace: ${e is Error ? e.stackTrace : ''}');
      throw Exception('Failed to complete registration: $e');
    }
  }
}
