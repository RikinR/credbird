// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceRepository {
  late final String baseUrl;
  late final String apiPrefix;
  late final String pKey;
  late final Future<String?> token;

  InvoiceRepository() {
    baseUrl = dotenv.get('API_DOMAIN');
    apiPrefix = dotenv.get('API_PREFIX');
    pKey = dotenv.get('P_KEY');
    token = _loadToken();
  }

  Future<String?> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> createInvoice({
    required String remitterId,
    required String remittanceTypeId,
    required String remittanceSubTypeId,
    required String agentId,
    required String currencyId,
    required String accountId,
    String? intermediaryName,
    required String intermediaryBankName,
    required String bicCode,
    required String intermediaryBankAddress,
    required String sortBsbAbaTransitFed,
    required List<Map<String, String>> invoices,
  }) async {
    final tokenValue = await token;
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/invoice');
    final headers = {
      'Content-Type': 'application/json',
      'p-key': pKey,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    final body = {
      "remitterId": remitterId,
      "remittanceTypeId": remittanceTypeId,
      "remittanceSubTypeId": remittanceSubTypeId,
      "agentId": agentId,
      "currencyId": currencyId,
      "accountId": accountId,
      if (intermediaryName != null) "intermediaryName": intermediaryName,
      "intermediaryBankName": intermediaryBankName,
      "bicCode": bicCode,
      "intermediaryBankAddress": intermediaryBankAddress,
      "sort_bsb_aba_transit_fed": sortBsbAbaTransitFed,
      "invoices": invoices,
    };

    print('[createInvoice] Request URL: $url');
    print('[createInvoice] Request Body: $body');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);
      print('[createInvoice] Response: ${response.statusCode} - $responseData');

      if (response.statusCode == 200 && responseData['success'] == true) {
        return responseData['data'];
      } else {
        throw Exception(responseData['message'] ?? 'Failed to create invoice');
      }
    } catch (e) {
      print('[createInvoice] Error: $e');
      throw Exception('Failed to create invoice: $e');
    }
  }

  Future<List<dynamic>> getInvoicesAssignedForMe({
    int page = 1,
    int pageSize = 10,
  }) async {
    final tokenValue = await token;
    final url = Uri.parse(
      '$baseUrl$apiPrefix/p-access/invoice/assignForMe?page=$page&pageSize=$pageSize',
    );
    final headers = {
      'p-key': pKey,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('[getInvoicesAssignedForMe] Request URL: $url');

    try {
      final response = await http.get(url, headers: headers);
      final responseData = jsonDecode(response.body);
      print('[getInvoicesAssignedForMe] Response: ${response.statusCode}');
      print('[getInvoicesAssignedForMe] Raw Data: ${responseData['data']}');

      if (response.statusCode == 200 && responseData['success'] == true) {
        final rawData = responseData['data'];
        if (rawData is List && rawData.length >= 2 && rawData[1] is List) {
          final invoiceList =
              rawData[1].whereType<Map<String, dynamic>>().toList();
          print(
            '[getInvoicesAssignedForMe] Filtered valid invoice count: ${invoiceList.length}',
          );
          return invoiceList;
        } else {
          print('[getInvoicesAssignedForMe] Unexpected structure: $rawData');
          return [];
        }
      } else {
        throw Exception(responseData['message'] ?? 'Failed to fetch invoices');
      }
    } catch (e) {
      print('[getInvoicesAssignedForMe] Error: $e');
      throw Exception('Failed to fetch invoices: $e');
    }
  }

  Future<List<dynamic>> getInvoicesAssignedByMe({
    int page = 1,
    int pageSize = 10,
  }) async {
    final tokenValue = await token;
    final url = Uri.parse(
      '$baseUrl$apiPrefix/p-access/invoice/assignByMe?page=$page&pageSize=$pageSize',
    );
    final headers = {
      'p-key': pKey,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('[getInvoicesAssignedByMe] Request URL: $url');

    try {
      final response = await http.get(url, headers: headers);
      final responseData = jsonDecode(response.body);
      print('[getInvoicesAssignedByMe] Response: ${response.statusCode}');
      print('[getInvoicesAssignedByMe] Raw Data: ${responseData['data']}');

      if (response.statusCode == 200 && responseData['success'] == true) {
        final rawData = responseData['data'];
        if (rawData is List && rawData.length >= 2 && rawData[1] is List) {
          final invoiceList =
              rawData[1].whereType<Map<String, dynamic>>().toList();
          print(
            '[getInvoicesAssignedByMe] Filtered valid invoice count: ${invoiceList.length}',
          );
          return invoiceList;
        } else {
          print('[getInvoicesAssignedByMe] Unexpected structure: $rawData');
          return [];
        }
      } else {
        throw Exception(responseData['message'] ?? 'Failed to fetch invoices');
      }
    } catch (e) {
      print('[getInvoicesAssignedByMe] Error: $e');
      throw Exception('Failed to fetch invoices: $e');
    }
  }
}
