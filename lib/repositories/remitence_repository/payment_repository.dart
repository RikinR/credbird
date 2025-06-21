// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentRepository {
  late final String baseUrl;
  late final String apiPrefix;
  late final String pKey;
  late final Future<String?> token;

  PaymentRepository() {
    baseUrl = dotenv.get('API_DOMAIN');
    apiPrefix = dotenv.get('API_PREFIX');
    pKey = dotenv.get('P_KEY');
    token = _loadToken();
    print('PaymentRepository initialized → $baseUrl$apiPrefix');
  }

  Future<String?> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString('token');
    print('Loaded token: ${t != null ? "exists" : "null"}');
    return t;
  }

  Future<void> initiatePayment({
    required String transactionId,
    String? notifyLink,
    String? redirectUrl,
    String? externalUID,
  }) async {
    final tokenValue = await token;

    final url = Uri.parse('$baseUrl$apiPrefix/p-access/transactionPayment');
    final headers = {
      'Content-Type': 'application/json',
      'p-key': pKey,
      'Authorization': 'Bearer $tokenValue',
    };

    final body = jsonEncode({
      "transactionId": transactionId,
      "notifyLink": notifyLink ?? "",
      "redirectUrl": redirectUrl ?? "",
      "externalUID": externalUID ?? "",
    });

    print("Initiating payment: $body");

    final response = await http.post(url, headers: headers, body: body);
    print('Payment response → ${response.statusCode}');
    print('Payment body → ${response.body}');

    final responseData = json.decode(response.body);
    
    if (response.statusCode != 200 || responseData['success'] != true) {
      final msg = responseData['message'] ?? 'Payment initiation failed';
      throw Exception(msg);
    }

    // Check if payment link was generated successfully
    if (responseData['data'] == null || responseData['data']['paymentLink'] == null) {
      throw Exception('Payment link generation failed');
    }
  }
}
