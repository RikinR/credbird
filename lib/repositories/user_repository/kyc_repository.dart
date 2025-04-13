// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class KycRepository {
  late final String baseUrl;
  late final String apiPrefix;
  late final String p_key;
  late final Future<String?> token;

  KycRepository() {
    baseUrl = dotenv.get('API_DOMAIN');
    apiPrefix = dotenv.get('API_PREFIX');
    p_key = dotenv.get('P_KEY');
    print('[KYCRepository] Initialized with baseUrl: $baseUrl');
    token = _loadToken();
    print("token is : $token");
  }

  Future<String?> _loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void addOrUpdateBankDetails({
    required String accountNumber,
    required String ifsc,
    required String accountName,
    required String verifiedId,
    required bool refundAccount,
    required String? id,
    required String? verifiedStatus,
    required String status,
  }) async {
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/addUpdateBankDetail');
    final tokenValue = await token;
    
    print("token is : $tokenValue");
    
    final headers = {
      'Content-Type': 'application/json',
      'p-key': p_key,
      'Authorization': 'Bearer $tokenValue',
    };
    final body = jsonEncode({
      'accountNumber': accountNumber,
      'ifsc': ifsc,
      'accountName': accountName,
      'refundAccount': refundAccount,
      'verifiedStatus': verifiedId,
      '_id': id,
      'status': status,
      'verifiedId': verifiedId,
    });

    print('[Bank] Sending POST request to $url with body: $body');
    try {
      final response = await http.post(url, headers: headers, body: body);
      print('[Bank] Response status: ${response.statusCode}');
      final responseData = jsonDecode(response.body);
      print('[Bank] Response data: $responseData');

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('[Bank] Bank deatils updated successfully');
      } else {
        print('[Bank] Bank updation failed: ${responseData['message']}');
        throw Exception(responseData['message'] ?? 'Cant update bank details');
      }
    } catch (e) {
      print('[Bank] Error occurred: $e');
      rethrow;
    }
  }

  void addUpdateContactDetail({
    required String name,
    required String mobile,
    required String email,
    required String? id,
    required String status,
  }) async {
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/addUpdateContactDetail');
    final tokenValue = await token;
    final headers = {
      'Content-Type': 'application/json',
      'p-key': p_key,
      'Authorization': 'Bearer $tokenValue',
    };
    final body = jsonEncode({
      "name": name,
      "mobile": mobile,
      "email": email,
      "_id": id,
      "status": status,
    });

    print('[Contact] Sending POST request to $url with body: $body');
    try {
      final response = await http.post(url, headers: headers, body: body);
      print('[Contact] Response status: ${response.statusCode}');
      final responseData = jsonDecode(response.body);
      print('[Contact] Response data: $responseData');

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('[Contact] Contact deatils updated successfully');
      } else {
        print('[Contact] Contact updation failed: ${responseData['message']}');
        throw Exception(
          responseData['message'] ?? 'Cant update Contact details',
        );
      }
    } catch (e) {
      print('[Contact] Error occurred: $e');
      rethrow;
    }
  }

  void updateAdditonalDetails({
    required String businessAddress,
    required String businessCity,
    required String businessCountry,
    required String businessPin,
    required String businessState,
  }) async {
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/addUpdateContactDetail');
    final tokenValue = await token;
    final headers = {
      'Content-Type': 'application/json',
      'p-key': p_key,
      'Authorization': 'Bearer $tokenValue',
    };
    final body = jsonEncode({
      "businessAddress": businessAddress,
      "businessCity": businessCity,
      "businessCountry": businessCountry,
      "businessPin": businessPin,
      "businessState": businessState,
    });

    print('[Additonal Details] Sending POST request to $url with body: $body');
    try {
      final response = await http.post(url, headers: headers, body: body);
      print('[Additonal Details] Response status: ${response.statusCode}');
      final responseData = jsonDecode(response.body);
      print('[Additonal Details] Response data: $responseData');

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('[Additonal Details] Contact deatils updated successfully');
      } else {
        print(
          '[Additonal Details] Additonal Details  failed: ${responseData['message']}',
        );
        throw Exception(
          responseData['message'] ?? 'Cant update Additonal Details',
        );
      }
    } catch (e) {
      print('[Additonal Details] Error occurred: $e');
      rethrow;
    }
  }
}
