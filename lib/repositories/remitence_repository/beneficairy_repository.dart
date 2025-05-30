// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BeneficiaryRepository {
  late final String baseUrl;
  late final String apiPrefix;
  late final String p_key;
  late final Future<String?> token;

  BeneficiaryRepository() {
    baseUrl = dotenv.get('API_DOMAIN');
    apiPrefix = dotenv.get('API_PREFIX');
    p_key = dotenv.get('P_KEY');
    print(
      'BeneficiaryRepository initialized with baseUrl: $baseUrl, apiPrefix: $apiPrefix',
    );
    token = _loadToken();
  }

  Future<String?> _loadToken() async {
    print('Loading token from SharedPreferences');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token loaded: ${token != null ? "exists" : "null"}');
    return token;
  }

  Future<List<Map<String, dynamic>>> getCurrencyList() async {
    final tokenValue = await token;
    final url = Uri.parse(
      '$baseUrl$apiPrefix/p-access/currency?pageSize=100&page=1',
    );
    final headers = {
      'p-key': p_key,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('[getCurrencyList] Fetching currency list');
    print('API URL: $url');
    final response = await http.get(url, headers: headers);
    final responseData = jsonDecode(response.body);

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 && responseData['success'] == true) {
      print('Currency list fetched successfully');
      return List<Map<String, dynamic>>.from(responseData['data']);
    } else {
      print('Error fetching currency list');
      throw Exception('Failed to fetch currency list');
    }
  }

  Future<Map<String, dynamic>> createBeneficiary({
    required String benificiaryName,
    required String address,
    required String city,
    required String country,
    required String accountNumber,
    required String bankName,
    required String bankAddress,
    required String swiftCode,
    required String currencyId,
    String? iban_bsb_aba,
  }) async {
    print('Creating beneficiary with name: $benificiaryName');
    final url = Uri.parse('$baseUrl$apiPrefix/directory/beneficiary');
    print('API URL: $url');

    final tokenValue = await token;
    print('Token value: $tokenValue');

    final headers = {
      'Content-Type': 'application/json',
      'p-key': p_key,
      'Authorization': 'Bearer $tokenValue',
    };
    print('Request headers: $headers');

    print('Using hardcoded currencyId: $currencyId');

    final body = jsonEncode({
      'benificiaryName': benificiaryName,
      'currencyId': currencyId,
      'address': address,
      'city': city,
      'country': country.toUpperCase(),
      'accountNumber': accountNumber,
      'bankName': bankName,
      'bankAddress': bankAddress,
      'swiftCode': swiftCode,
      if (iban_bsb_aba != null) 'iban_bsb_aba': iban_bsb_aba,
    });
    print('Request body: $body');

    try {
      print('Making POST request to create beneficiary');
      final response = await http.post(url, headers: headers, body: body);
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      print('Parsed response data: $responseData');

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('Beneficiary created successfully');
        return responseData;
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to create beneficiary';
        print('Error creating beneficiary: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Exception occurred while creating beneficiary: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getBeneficiaries({
    int page = 1,
    int pageSize = 10,
    String search = '',
  }) async {
    print(
      'Fetching beneficiaries with page: $page, pageSize: $pageSize, search: $search',
    );
    final url = Uri.parse(
      '$baseUrl$apiPrefix/directory/beneficiary?page=$page&pageSize=$pageSize&search=$search',
    );
    print('API URL: $url');

    final tokenValue = await token;
    print('Token value: $tokenValue');

    final headers = {
      'Content-Type': 'application/json',
      'p-key': p_key,
      'Authorization': 'Bearer $tokenValue',
    };
    print('Request headers: $headers');

    try {
      print('Making GET request to fetch beneficiaries');
      final response = await http.get(url, headers: headers);
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      print('Parsed response data: $responseData');

      if (response.statusCode == 200 && responseData['success'] == true) {
        final count = responseData['data']['count'];
        final resultCount = responseData['data']['result']?.length ?? 0;
        print(
          'Successfully fetched $resultCount beneficiaries (total: $count)',
        );
        return responseData;
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to fetch beneficiaries';
        print('Error fetching beneficiaries: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Exception occurred while fetching beneficiaries: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getBeneficiaryById(String id) async {
    print('Fetching beneficiary details by ID: $id');
    final tokenValue = await token;
    final url = Uri.parse('$baseUrl$apiPrefix/directory/beneficiary/$id');
    final headers = {'p-key': p_key, 'Authorization': 'Bearer $tokenValue'};

    print('API URL: $url');
    final response = await http.get(url, headers: headers);
    final responseData = jsonDecode(response.body);

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 && responseData['success'] == true) {
      print('Beneficiary details fetched successfully');
      return responseData['data'];
    } else {
      print('Error fetching beneficiary');
      throw Exception(responseData['message'] ?? 'Failed to fetch beneficiary');
    }
  }

  Future<bool> updateBeneficiaryActivation({
    required String id,
    required bool isActivated,
  }) async {
    print(
      'Updating beneficiary activation for ID: $id, isActivated: $isActivated',
    );
    final tokenValue = await token;
    final url = Uri.parse('$baseUrl$apiPrefix/directory/updateActivation/$id');
    final headers = {
      'Content-Type': 'application/json',
      'p-key': p_key,
      'Authorization': 'Bearer $tokenValue',
    };

    print('API URL: $url');
    final body = jsonEncode({'type': 2, 'isActivated': isActivated});
    print('Request body: $body');

    final response = await http.put(url, headers: headers, body: body);
    final responseData = jsonDecode(response.body);

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 && responseData['success'] == true) {
      print('Beneficiary activation updated successfully');
      return true;
    } else {
      print('Error updating beneficiary activation');
      return false;
    }
  }
}
