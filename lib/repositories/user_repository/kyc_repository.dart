// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class KYCRepository {
  late final String baseUrl;
  late final String apiPrefix;
  late final String p_key;
  late final Future<String?> token;

  KYCRepository() {
    baseUrl = dotenv.get('API_DOMAIN');
    apiPrefix = dotenv.get('API_PREFIX');
    p_key = dotenv.get('P_KEY');
    token = _loadToken();
    print('KYCRepository initialized: $baseUrl$apiPrefix');
  }

  Future<String?> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString('token');
    print('Loaded token: ${t != null ? "exists" : "null"}');
    return t;
  }

  Future<List<dynamic>> getPendingDocuments() async {
    final tokenValue = await token;
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/findDocumentByStatus');

    final headers = {'p-key': p_key, 'Authorization': 'Bearer $tokenValue'};

    print('Fetching pending documents → $url');
    print('Headers: $headers');

    final response = await http.get(url, headers: headers);
    print('Response code: ${response.statusCode}');
    print('Response body: ${response.body}');

    final responseData = json.decode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      print('Documents fetched: ${responseData['data']?.length ?? 0}');
      return responseData['data'] ?? [];
    } else if (response.statusCode == 500) {
      // If server returns 500, it means no documents are found yet
      print('No documents found yet');
      return [];
    } else {
      final msg = responseData['message'] ?? 'Failed to fetch documents';
      print('Error fetching documents: $msg');
      throw Exception(msg);
    }
  }

  Future<List<String>> uploadFile(File file) async {
    final tokenValue = await token;
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/common/uploadFile');

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'p-key': p_key,
      'Authorization': 'Bearer $tokenValue',
    });

    print('⬆ Uploading file: ${file.path}');
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    print('⬆Upload response code: ${response.statusCode}');
    print('⬆Upload response body: ${responseBody.body}');

    final responseData = json.decode(responseBody.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      final urls = List<String>.from(responseData['data']);
      print('File uploaded. URLs: $urls');
      return urls;
    } else {
      final msg = responseData['message'] ?? 'Upload failed';
      print('File upload error: $msg');
      throw Exception(msg);
    }
  }

  Future<String> makeFilePublic(String fileUri) async {
    final tokenValue = await token;
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/common/createPublic');
    final headers = {
      'Content-Type': 'application/json',
      'p-key': p_key,
      'Authorization': 'Bearer $tokenValue',
    };

    final body = jsonEncode({'fileUri': fileUri});
    print('Making file public for URI: $fileUri');

    final response = await http.post(url, headers: headers, body: body);
    print('Public URL response code: ${response.statusCode}');
    print('Response body: ${response.body}');

    final responseData = json.decode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      final publicUrl = responseData['data'];
      print('Public URL created: $publicUrl');
      return publicUrl;
    } else {
      final msg = responseData['message'] ?? 'Failed to make file public';
      print('Public URL error: $msg');
      throw Exception(msg);
    }
  }

  Future<bool> uploadRegistrationDocuments({
    required String registrationId,
    required List<Map<String, dynamic>> documents,
  }) async {
    final tokenValue = await token;
    final url = Uri.parse(
      '$baseUrl$apiPrefix/p-access/uploadRegisterationDocument',
    );
    final headers = {
      'Content-Type': 'application/json',
      'p-key': p_key,
      'Authorization': 'Bearer $tokenValue',
    };

    final body = jsonEncode({
      'registrationId': registrationId,
      'document': documents,
    });

    print('Uploading registration documents for ID: $registrationId');
    print('Request Body: $body');

    final response = await http.post(url, headers: headers, body: body);
    print(' Response code: ${response.statusCode}');
    print(' Response body: ${response.body}');

    final responseData = json.decode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      print(' Registration documents uploaded successfully');
      return true;
    } else {
      final msg = responseData['message'] ?? 'Registration upload failed';
      print(' Registration upload error: $msg');
      throw Exception(msg);
    }
  }

  Future<bool> checkKYCStatus() async {
    final tokenValue = await token;
    final url = Uri.parse('$baseUrl$apiPrefix/p-access/checkKyc');

    final headers = {'p-key': p_key, 'Authorization': 'Bearer $tokenValue'};

    print('Checking KYC status → $url');
    final response = await http.get(url, headers: headers);
    print('KYC check response: ${response.body}');

    final responseData = json.decode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      return responseData['data']['kycDone'] ?? false;
    } else {
      final msg = responseData['message'] ?? 'Failed to check KYC status';
      throw Exception(msg);
    }
  }

  Future<void> uploadDocument(String registrationId, String documentId, File file) async {
    try {
      // First upload the file to get the URL
      final uploadedUrls = await uploadFile(file);
      
      // Then create the document entry
      final documents = [{
        "documentId": documentId,
        "documentUrl": uploadedUrls,
      }];

      await uploadRegistrationDocuments(
        registrationId: registrationId,
        documents: documents,
      );
    } catch (e) {
      debugPrint('Error uploading document: $e');
      rethrow;
    }
  }
}
