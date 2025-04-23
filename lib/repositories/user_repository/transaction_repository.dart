// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'package:credbird/model/remittance/transaction_response_model.dart';
import 'package:credbird/model/user_models/api_transaction_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransactionRepository {
  late final String baseUrl;
  late final String apiPrefix;
  late final String p_key;
  late final Future<String?> token;

  TransactionRepository() {
    baseUrl = dotenv.get('API_DOMAIN');
    apiPrefix = dotenv.get('API_PREFIX');
    p_key = dotenv.get('P_KEY');
    token = _loadToken();
  }

  Future<String?> _loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<TransactionResponse> getTransactions({
    int page = 1,
    int pageSize = 10,
    String search = '',
  }) async {
    final url = Uri.parse(
      '$baseUrl$apiPrefix/p-access/myTransaction?page=$page&pageSize=$pageSize&search=$search',
    );
    final tokenValue = await token;

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'p-key': p_key,
          'Authorization': 'Bearer $tokenValue',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        if (responseData['data'] is List && responseData['data'].length == 2) {
          final totalCount =
              responseData['data'][0] is int ? responseData['data'][0] : 0;
          final transactionsList = responseData['data'][1] as List;
          final transactions =
              transactionsList
                  .map((item) {
                    try {
                      return ApiTransaction.fromJson(
                        item as Map<String, dynamic>,
                      );
                    } catch (e) {
                      print('Error parsing transaction item: $e');
                      return null;
                    }
                  })
                  .whereType<ApiTransaction>()
                  .toList();

          return TransactionResponse(
            totalCount: totalCount,
            transactions: transactions,
          );
        } else {
          throw Exception('Unexpected API response format');
        }
      } else {
        throw Exception(
          responseData['message'] ?? 'Failed to fetch transactions',
        );
      }
    } catch (e) {
      print('Error in getTransactions: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTransactionById(String id) async {
    print('Fetching Transaction details by ID: $id');
    final tokenValue = await token;
    final url = Uri.parse(
      '$baseUrl$apiPrefix/p-access/remittance-transaction/$id',
    );
    final headers = {'p-key': p_key, 'Authorization': 'Bearer $tokenValue'};

    print('API URL: $url');
    final response = await http.get(url, headers: headers);
    final responseData = jsonDecode(response.body);

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 && responseData['success'] == true) {
      print('Transaction details fetched successfully');
      return responseData['data'];
    } else {
      print('Error fetching Transaction');
      throw Exception(responseData['message'] ?? 'Failed to fetch Transaction');
    }
  }
}
