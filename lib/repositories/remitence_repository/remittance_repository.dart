// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:credbird/model/remittance/remitter_model.dart';
import 'package:credbird/model/remittance/transaction_create_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemittanceRepository {
  late final String baseUrl;
  late final String apiPrefix;
  late final String pKey;
  late final Future<String?> token; //

  RemittanceRepository() {
    baseUrl = dotenv.get('API_DOMAIN');
    apiPrefix = dotenv.get('API_PREFIX');
    pKey = dotenv.get('P_KEY');
    token = _loadToken();
  }

  Future<String?> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> createRemitter(RemitterModel data) async {
    final tokenValue = await token;
    final url = Uri.parse('$baseUrl$apiPrefix/directory/remitter');
    final headers = {
      'Content-Type': 'application/json',
      'p-key': pKey,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    final body = jsonEncode(data.toJson());
    print('[createRemitter] Request URL: $url');
    print('[createRemitter] Request Headers: ${headers.keys.join(', ')}');
    print('[createRemitter] Request Body: $body');

    final response = await http.post(url, headers: headers, body: body);
    print('[createRemitter] Response Status: ${response.statusCode}');

    final responseData = jsonDecode(response.body);
    print('[createRemitter] Response Data: $responseData');

    if (response.statusCode == 200 && responseData['success'] == true) {
      return responseData['data'];
    } else {
      throw Exception(responseData['message'] ?? 'Remitter creation failed');
    }
  }

  Future<List<Map<String, dynamic>>> getRemittanceTypes() async {
    final tokenValue = await token;
    final url = Uri.parse('$baseUrl$apiPrefix/directory/remittanceType');
    final headers = {
      'p-key': pKey,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('[getRemittanceTypes] Fetching remittance types from $url');
    final response = await http.get(url, headers: headers);
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      return List<Map<String, dynamic>>.from(responseData['data']);
    } else {
      throw Exception('Failed to fetch remittance types');
    }
  }

  Future<List<Map<String, dynamic>>> getRemittanceSubTypes(
    String remittanceTypeId,
  ) async {
    final tokenValue = await token;
    final url = Uri.parse(
      '$baseUrl$apiPrefix/directory/remittanceSubType?remittanceTypeId=$remittanceTypeId',
    );
    final headers = {
      'p-key': pKey,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('[getRemittanceSubTypes] Fetching subtypes for $remittanceTypeId');
    final response = await http.get(url, headers: headers);
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      return List<Map<String, dynamic>>.from(responseData['data']);
    } else {
      throw Exception('Failed to fetch remittance subtypes');
    }
  }

  Future<List<Map<String, dynamic>>> getRemitterList() async {
    final tokenValue = await token;
    final url = Uri.parse(
      '$baseUrl$apiPrefix/directory/remitter?view=dropdown',
    );
    final headers = {
      'p-key': pKey,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('[getRemitterList] Fetching remitter list');
    final response = await http.get(url, headers: headers);
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      return List<Map<String, dynamic>>.from(responseData['data']['result']);
    } else {
      throw Exception('Failed to fetch remitter list');
    }
  }

  Future<List<Map<String, dynamic>>> getBeneficiaryList() async {
    final tokenValue = await token;
    final url = Uri.parse(
      '$baseUrl$apiPrefix/directory/beneficiary?view=dropdown',
    );
    final headers = {
      'p-key': pKey,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('[getBeneficiaryList] Fetching beneficiary list');
    final response = await http.get(url, headers: headers);
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      return List<Map<String, dynamic>>.from(responseData['data']['result']);
    } else {
      throw Exception('Failed to fetch beneficiary list');
    }
  }

  Future<List<Map<String, dynamic>>> getIntermediaryList() async {
    final tokenValue = await token;
    final url = Uri.parse(
      '$baseUrl$apiPrefix/directory/intermediary?view=dropdown',
    );
    final headers = {
      'p-key': pKey,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('[getIntermediaryList] Fetching intermediary list');
    final response = await http.get(url, headers: headers);
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      return List<Map<String, dynamic>>.from(responseData['data']['result']);
    } else {
      throw Exception('Failed to fetch intermediary list');
    }
  }

  Future<List<Map<String, dynamic>>> getCurrencyList() async {
    final tokenValue = await token;
    final url = Uri.parse(
      '$baseUrl$apiPrefix/p-access/currency?pageSize=100&page=1',
    );
    final headers = {
      'p-key': pKey,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('[getCurrencyList] Fetching currency list');
    final response = await http.get(url, headers: headers);
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      return List<Map<String, dynamic>>.from(responseData['data']);
    } else {
      throw Exception('Failed to fetch currency list');
    }
  }

  Future<Map<String, dynamic>> getTcsData(String pan) async {
    final tokenValue = await token;
    final url = Uri.parse(
      '$baseUrl$apiPrefix/p-access/getTcsData?panNumber=$pan',
    );
    final headers = {
      'p-key': pKey,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('[getTcsData] Fetching TCS data for PAN: $pan');
    final response = await http.get(url, headers: headers);
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      return responseData['data'];
    } else {
      throw Exception('Failed to fetch TCS data');
    }
  }

  Future<Map<String, dynamic>> createTransaction(
    TransactionCreateModel data,
  ) async {
    final tokenValue = await token;
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/transaction');
    final headers = {
      'Content-Type': 'application/json',
      'p-key': pKey,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    final body = jsonEncode(data.toJson());
    print('[createTransaction] Request URL: $url');
    print('[createTransaction] Request Headers: ${headers.keys.join(', ')}');
    print('[createTransaction] Request Body: $body');

    final response = await http.post(url, headers: headers, body: body);
    print('[createTransaction] Response Status: ${response.statusCode}');

    final responseData = jsonDecode(response.body);
    print('[createTransaction] Response Data: $responseData');

    if (response.statusCode == 200 && responseData['success'] == true) {
      return responseData['data'];
    } else {
      throw Exception(responseData['message'] ?? 'Transaction creation failed');
    }
  }

  Future<Map<String, dynamic>> getRemitterById(String remitterId) async {
    final tokenValue = await token;
    final url = Uri.parse('$baseUrl$apiPrefix/directory/remitter/$remitterId');
    final headers = {
      'p-key': pKey,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('[getRemitterById] Fetching remitter by ID: $remitterId');
    final response = await http.get(url, headers: headers);
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      return responseData['data'];
    } else {
      throw Exception('Failed to fetch remitter by ID');
    }
  }
}
