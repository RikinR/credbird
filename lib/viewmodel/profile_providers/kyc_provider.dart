import 'dart:io';
import 'package:credbird/repositories/user_repository/kyc_repository.dart';
import 'package:flutter/material.dart';

class KYCProvider with ChangeNotifier {
  final _repository = KYCRepository();
  List<dynamic> _pendingDocs = [];
  final Map<String, File?> _selectedFiles = {};
  bool _loading = false;

  List<dynamic> get pendingDocs => _pendingDocs;
  Map<String, File?> get selectedFiles => _selectedFiles;
  bool get isLoading => _loading;

  bool _kycDone = false;
  bool get isKYCDone => _kycDone;

  Future<void> loadPendingDocuments() async {
    _loading = true;
    notifyListeners();
    try {
      final allDocs = await _repository.getPendingDocuments();
      _pendingDocs =
          allDocs.where((doc) => doc['status'] != 'VERIFIED').toList();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void selectFile(String documentId, File file) {
    _selectedFiles[documentId] = file;
    notifyListeners();
  }

  Future<void> uploadAllDocuments(String registrationId) async {
    _loading = true;
    notifyListeners();

    try {
      List<Map<String, dynamic>> finalDocuments = [];

      for (var entry in _selectedFiles.entries) {
        final uploadedUrls = await _repository.uploadFile(entry.value!);
        finalDocuments.add({
          "documentId": entry.key,
          "documentUrl": uploadedUrls,
        });
      }

      await _repository.uploadRegistrationDocuments(
        registrationId: registrationId,
        documents: finalDocuments,
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> checkKYCStatus() async {
    _loading = true;
    notifyListeners();
    try {
      _kycDone = await _repository.checkKYCStatus();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
