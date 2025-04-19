// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IntermediaryRepository {
  late final String baseUrl;
  late final String apiPrefix;
  late final String p_key;
  late final Future<String?> token;

  IntermediaryRepository() {
    baseUrl = dotenv.get('API_DOMAIN');
    apiPrefix = dotenv.get('API_PREFIX');
    p_key = dotenv.get('P_KEY');
    print(
      'IntermediaryRepository initialized with baseUrl: $baseUrl, apiPrefix: $apiPrefix',
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

  Future<Map<String, dynamic>> createIntermediary({
    required String intermediaryBankName,
    required String bicCode,
    required String intermediaryBankAddress,
    required String sortBsbAbaTransitFed,
  }) async {
    final tokenValue = await token;
    final url = Uri.parse('$baseUrl$apiPrefix/directory/intermediary');
    final headers = {
      'Content-Type': 'application/json',
      'p-key': p_key,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('[createIntermediary] Creating intermediary: $intermediaryBankName');
    print('[createIntermediary] URL: $url');

    final body = jsonEncode({
      'intermediaryBankName': intermediaryBankName,
      'bicCode': bicCode,
      'intermediaryBankAddress': intermediaryBankAddress,
      'sort_bsb_aba_transit_fed': sortBsbAbaTransitFed,
    });

    print('[createIntermediary] Request body: $body');

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('[createIntermediary] Response status: ${response.statusCode}');
      print('[createIntermediary] Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success'] == true) {
        return responseData['data'];
      } else {
        throw Exception(
          responseData['message'] ?? 'Failed to create intermediary',
        );
      }
    } catch (e) {
      print('[createIntermediary] Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getIntermediaryById(String id) async {
    final tokenValue = await token;
    final url = Uri.parse('$baseUrl$apiPrefix/directory/intermediary/$id');
    final headers = {
      'p-key': p_key,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('[getIntermediaryById] Fetching intermediary with id: $id');
    print('[getIntermediaryById] URL: $url');

    try {
      final response = await http.get(url, headers: headers);
      print('[getIntermediaryById] Response status: ${response.statusCode}');
      print('[getIntermediaryById] Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success'] == true) {
        return responseData['data'];
      } else {
        throw Exception(
          responseData['message'] ?? 'Failed to fetch intermediary',
        );
      }
    } catch (e) {
      print('[getIntermediaryById] Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getIntermediaries({
    int page = 1,
    int pageSize = 10,
    String search = '',
  }) async {
    final tokenValue = await token;
    final url = Uri.parse(
      '$baseUrl$apiPrefix/directory/intermediary?page=$page&pageSize=$pageSize&intermediaryName=$search',
    );
    final headers = {
      'p-key': p_key,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('[getIntermediaries] Fetching intermediaries');
    print('[getIntermediaries] URL: $url');

    try {
      final response = await http.get(url, headers: headers);
      print('[getIntermediaries] Response status: ${response.statusCode}');
      print('[getIntermediaries] Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success'] == true) {
        return responseData['data'];
      } else {
        throw Exception(
          responseData['message'] ?? 'Failed to fetch intermediaries',
        );
      }
    } catch (e) {
      print('[getIntermediaries] Error: $e');
      rethrow;
    }
  }
}
