// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:credbird/repositories/remitence_repository/document_repository.dart';
import 'package:flutter/material.dart';

class DocumentViewModel with ChangeNotifier {
  final DocumentRepository _repository;

  DocumentViewModel(this._repository);

  bool _isLoading = false;
  String _errorMessage = '';
  List<Map<String, dynamic>> _documents = [];
  List<String> _uploadedFileUrls = [];
  Map<String, dynamic>? _eSignData;
  Map<String, dynamic>? _eSignStatus;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get documents => _documents;
  List<String> get uploadedFileUrls => _uploadedFileUrls;
  Map<String, dynamic>? get eSignData => _eSignData;
  Map<String, dynamic>? get eSignStatus => _eSignStatus;

  List<Map<String, dynamic>> _requiredDocuments = [];

  List<Map<String, dynamic>> get requiredDocuments => _requiredDocuments;
  bool _isESignInProgress = false;
  bool get isESignInProgress => _isESignInProgress;

  void setESignInProgress(bool value) {
    _isESignInProgress = value;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
  }

  Future<void> completeESignFlow({
    required String transactionId,
    required List<Map<String, dynamic>> documents,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.uploadTransactionDocuments(
        transactionId: transactionId,
        documents: documents,
      );

    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchTransactionDocuments(String transactionId) async {
    _setLoading(true);
    _clearError();

    try {
      _documents = await _repository.getTransactionDocumentsByStatus(
        transactionId: transactionId,
      );

      if (_documents.isNotEmpty) {
        final transactionData = _documents.first;
        final docs = transactionData['docs'] as List? ?? [];

        _requiredDocuments =
            docs.map((doc) {
              final detail = (doc['documentDetail'] as List?)?.first;
              return {
                'id': doc['_id'],
                'label': detail?['documentName'] ?? 'Document',
                'required': doc['isRequired'] ?? true,
                'status': doc['status'] ?? 'PENDING',
              };
            }).toList();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> uploadFile(File file) async {
    _setLoading(true);
    _clearError();

    try {
      _uploadedFileUrls = await _repository.uploadFile(file);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> submitDocuments({
    required String transactionId,
    required List<Map<String, dynamic>> documents,
    bool isDraft = false,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      if (isDraft) {
        await _repository.uploadTransactionDocumentsDraft(
          transactionId: transactionId,
          documents: documents,
        );
      } else {
        await _repository.uploadTransactionDocuments(
          transactionId: transactionId,
          documents: documents,
        );
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>> startESignProcess({
    required String transactionId,
    required String callBackUrl,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _repository.initiateESign(
        transactionId: transactionId,
        callBackUrl: callBackUrl,
      );
      _eSignData = response;
      return {"success": true, "data": response};
    } catch (e) {
      _setError(e.toString());
      return {"success": false};
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkESignStatus(String clientId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _repository.checkESignStatus(clientId);
      print("heree 1");

      _eSignStatus = response;
      print("heree 2");

      final statusString = response['data'] ?? '';

      print("heree 3");

      if (statusString.toString().toLowerCase() == "esign_completed" ||
          statusString == "COMPLETED") {
        print("E-Sign completed for $clientId");
      } else {
        print("E-Sign still pending for $clientId, status: $statusString");
      }
    } catch (e) {
      print("heree");
      print(e.toString());
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void clearUploadedFiles() {
    _uploadedFileUrls.clear();
    notifyListeners();
  }

  void resetESignData() {
    _eSignData = null;
    _eSignStatus = null;
    notifyListeners();
  }

  Future<void> downloadFormA2(String transactionId) async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.downloadFormA2PDF(transactionId);
    } catch (e) {
      _setError("Failed to download A2 Form: ${e.toString()}");
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
