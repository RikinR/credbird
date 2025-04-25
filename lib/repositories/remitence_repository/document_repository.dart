// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentRepository {
  late final String baseUrl;
  late final String apiPrefix;
  late final String p_key;
  late final Future<String?> token;

  DocumentRepository() {
    baseUrl = dotenv.get('API_DOMAIN');
    apiPrefix = dotenv.get('API_PREFIX');
    p_key = dotenv.get('P_KEY');
    print(
      'DocumentRepository initialized with baseUrl: $baseUrl, apiPrefix: $apiPrefix',
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

  Future<List<Map<String, dynamic>>> getTransactionDocumentsByStatus({
    required String transactionId,
  }) async {
    print('Fetching transaction documents for transactionId: $transactionId');
    final tokenValue = await token;
    final url = Uri.parse(
      '$baseUrl$apiPrefix/p-access/findTransactionDocumentByStatus?transactionId=$transactionId',
    );
    final headers = {
      'p-key': p_key,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('API URL: $url');
    final response = await http.get(url, headers: headers);
    final responseData = jsonDecode(response.body);

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 && responseData['success'] == true) {
      print('Transaction documents fetched successfully');
      return List<Map<String, dynamic>>.from(responseData['data']);
    } else {
      final errorMessage =
          responseData['message'] ?? 'Failed to fetch transaction documents';
      print('Error fetching transaction documents: $errorMessage');
      throw Exception(errorMessage);
    }
  }

  Future<List<String>> uploadFile(File file) async {
    print('Uploading file: ${file.path}');
    final tokenValue = await token;
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/common/uploadFile');

    final headers = {
      'p-key': p_key,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('API URL: $url');

    try {
      final request =
          http.MultipartRequest('POST', url)
            ..headers.addAll(headers)
            ..files.add(
              await http.MultipartFile.fromPath(
                'file',
                file.path,
                contentType: MediaType('application', 'octet-stream'),
              ),
            );

      print('Making file upload request');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('File uploaded successfully');
        return List<String>.from(responseData['data']);
      } else {
        final errorMessage = responseData['message'] ?? 'Failed to upload file';
        print('Error uploading file: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Exception occurred while uploading file: $e');
      rethrow;
    }
  }

  Future<void> uploadTransactionDocuments({
    required String transactionId,
    required List<Map<String, dynamic>> documents,
  }) async {
    print('Uploading transaction documents for transactionId: $transactionId');
    final tokenValue = await token;
    final url = Uri.parse(
      '$baseUrl$apiPrefix/p-access/uploadTransactionDocument/',
    );

    final headers = {
      'Content-Type': 'application/json',
      'p-key': p_key,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('API URL: $url');

    final body = jsonEncode({
      'transactionId': transactionId,
      'document': documents,
    });

    print('Request body: $body');

    try {
      print('Making document upload request');
      final response = await http.post(url, headers: headers, body: body);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('Transaction documents uploaded successfully');
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to upload transaction documents';
        print('Error uploading transaction documents: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Exception occurred while uploading transaction documents: $e');
      rethrow;
    }
  }

  Future<void> uploadTransactionDocumentsDraft({
    required String transactionId,
    required List<Map<String, dynamic>> documents,
  }) async {
    print(
      'Uploading draft transaction documents for transactionId: $transactionId',
    );
    final tokenValue = await token;
    final url = Uri.parse(
      '$baseUrl$apiPrefix/p-access/uploadTransactionDocumentDraft/',
    );

    final headers = {
      'Content-Type': 'application/json',
      'p-key': p_key,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('API URL: $url');

    final body = jsonEncode({
      'transactionId': transactionId,
      'document': documents,
    });

    print('Request body: $body');

    try {
      print('Making draft document upload request');
      final response = await http.post(url, headers: headers, body: body);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('Draft transaction documents uploaded successfully');
      } else {
        final errorMessage =
            responseData['message'] ??
            'Failed to upload draft transaction documents';
        print('Error uploading draft transaction documents: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print(
        'Exception occurred while uploading draft transaction documents: $e',
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>> initiateESign({
    required String transactionId,
    required String callBackUrl,
  }) async {
    print('Initiating e-sign for transactionId: $transactionId');
    final tokenValue = await token;
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/e-sign/$transactionId');

    final headers = {
      'Content-Type': 'application/json',
      'p-key': p_key,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('API URL: $url');

    final body = jsonEncode({'callBackUrl': callBackUrl});

    print('Request body: $body');

    try {
      print('Making e-sign initiation request');
      final response = await http.post(url, headers: headers, body: body);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('E-sign initiated successfully');
        return responseData['data'];
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to initiate e-sign';
        print('Error initiating e-sign: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Exception occurred while initiating e-sign: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkESignStatus(String clientId) async {
    print('Checking e-sign status for clientId: $clientId');
    final tokenValue = await token;
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/e-sign-check/$clientId');

    final headers = {
      'p-key': p_key,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    print('API URL: $url');

    try {
      print('Making e-sign status check request');
      final response = await http.get(url, headers: headers);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('E-sign status checked successfully');
        return responseData['data'];
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to check e-sign status';
        print('Error checking e-sign status: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Exception occurred while checking e-sign status: $e');
      rethrow;
    }
  }

  Future<void> downloadFormA2PDF(String transactionId) async {
    final tokenValue = await token;
    final url = Uri.parse(
      '$baseUrl$apiPrefix/p-access/getFormA2Doc/$transactionId',
    );

    final headers = {
      'p-key': p_key,
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };

    final response = await http.get(url, headers: headers);
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      final base64String = responseData['data']['base64'];
      if (base64String != null && base64String.isNotEmpty) {
        final bytes = base64Decode(base64String);
        final directory = await Directory.systemTemp.createTemp();
        final filePath = '${directory.path}/form_a2.pdf';
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        await OpenFile.open(filePath);
      } else {
        throw Exception("No PDF content available.");
      }
    } else {
      throw Exception(
        responseData['message'] ?? "Failed to fetch Form A2 PDF.",
      );
    }
  }
}
