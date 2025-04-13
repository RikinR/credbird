// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:credbird/model/user_models/forex_rate_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ForexRateRepository {
  late final String baseUrl;
  late final String apiPrefix;
  late final String p_key;
  late final Future<String?> token;

  ForexRateRepository() {
    baseUrl = dotenv.get('API_DOMAIN');
    apiPrefix = dotenv.get('API_PREFIX');
    p_key = dotenv.get('P_KEY');
    token = _loadToken();
  }

  Future<String?> _loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<ForexRate>> getLiveRates() async {
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/getLiveRate');
    final tokenValue = await token;
    final headers = {
      'Content-Type': 'application/json',
      'p-key': p_key,
      'Authorization': 'Bearer $tokenValue',
    };

    try {
      final response = await http.get(url, headers: headers);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        List<dynamic> data = responseData['data'];
        return data.map((item) => ForexRate.fromJson(item)).toList();
      } else {
        throw Exception(responseData['message'] ?? 'Failed to fetch live rates');
      }
    } catch (e) {
      rethrow;
    }
  }
}