import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:credbird/repositories/user_repository/kyc_repository.dart';

class KYCProvider with ChangeNotifier {
  final _repository = KYCRepository();
  List<dynamic> _pendingDocs = [];
  final Map<String, File?> _selectedFiles = {};
  bool _isLoading = false;
  bool _isSubmitted = false;

  List<dynamic> get pendingDocs => _pendingDocs;
  Map<String, File?> get selectedFiles => _selectedFiles;
  bool get isLoading => _isLoading;
  bool get isSubmitted => _isSubmitted;

  bool _kycDone = false;
  bool get isKYCDone => _kycDone;

  bool get hasUploadedDocuments => _pendingDocs.any((doc) => doc['status'] == "UPLOADED");
  bool get hasVerifiedDocuments => _pendingDocs.any((doc) => doc['status'] == "VERIFIED");
  bool get isKYCComplete => _pendingDocs.isNotEmpty && _pendingDocs.every((doc) => doc['status'] == "VERIFIED");

  // New: True if all docs are PENDING (under review)
  bool get isUnderReview => _pendingDocs.isNotEmpty && _pendingDocs.every((doc) => doc['status'] == "PENDING");

  // New: True if any doc is not PENDING or VERIFIED (needs upload)
  bool get needsToUpload => _pendingDocs.any((doc) => doc['status'] != "PENDING" && doc['status'] != "VERIFIED");

  Future<void> loadPendingDocuments() async {
    _isLoading = true;
    notifyListeners();
    try {
      final allDocs = await _repository.getPendingDocuments();
      _pendingDocs = allDocs.where((doc) => doc['status'] != 'VERIFIED').toList();
    } catch (e) {
      debugPrint('Error loading pending documents: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectFile(String docId, File file) {
    _selectedFiles[docId] = file;
    notifyListeners();
  }

  Future<void> uploadAllDocuments(String registrationId) async {
    _isLoading = true;
    notifyListeners();

    try {
      for (var doc in _pendingDocs) {
        final docId = doc['documentId']['_id'];
        final file = _selectedFiles[docId];
        if (file != null) {
          await _repository.uploadDocument(registrationId, docId, file);
        }
      }
      _isSubmitted = true;
      await loadPendingDocuments(); // Refresh the documents list
    } catch (e) {
      debugPrint('Error uploading documents: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkKYCStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      _kycDone = await _repository.checkKYCStatus();
      if (!_kycDone) {
        await loadPendingDocuments();
      }
    } catch (e) {
      debugPrint('Error checking KYC status: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
