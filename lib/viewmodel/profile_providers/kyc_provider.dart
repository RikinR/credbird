// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:credbird/model/kyc_model.dart';

class KYCProvider with ChangeNotifier {
  KYCModel _kycData = KYCModel();
  bool _isLoading = false;
  String? _errorMessage;

  KYCModel get kycData => _kycData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void updateFirstName(String value) {
    _kycData = _kycData.copyWith(firstName: value);
    notifyListeners();
  }

  void updateLastName(String value) {
    _kycData = _kycData.copyWith(lastName: value);
    notifyListeners();
  }

  void updateBankDetails({
    String? accountNumber,
    String? ifsc,
    String? accountName,
    bool? refundAccount,
  }) {
    _kycData = _kycData.copyWith(
      accountNumber: accountNumber,
      ifsc: ifsc,
      accountName: accountName,
      refundAccount: refundAccount,
    );
    notifyListeners();
  }

  void updateDocument(String path, String type) {
    _kycData = _kycData.copyWith(
      documentPath: path,
      documentType: type,
    );
    notifyListeners();
  }

  Future<void> submitKYC(BuildContext context) async {
    if (_validateForm()) {
      _isLoading = true;
      notifyListeners();
      
      try {
        await Future.delayed(const Duration(seconds: 2));
        
        _isLoading = false;
        notifyListeners();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('KYC submitted successfully')),
        );
        
        Navigator.pop(context);
      } catch (e) {
        _errorMessage = 'Failed to submit KYC: ${e.toString()}';
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  bool _validateForm() {
    if (_kycData.firstName == null || _kycData.firstName!.isEmpty) {
      _errorMessage = 'Please enter your first name';
      notifyListeners();
      return false;
    }
    if (_kycData.lastName == null || _kycData.lastName!.isEmpty) {
      _errorMessage = 'Please enter your last name';
      notifyListeners();
      return false;
    }
    if (_kycData.accountNumber == null || _kycData.accountNumber!.isEmpty) {
      _errorMessage = 'Please enter your account number';
      notifyListeners();
      return false;
    }
    if (_kycData.documentPath == null || _kycData.documentPath!.isEmpty) {
      _errorMessage = 'Please upload a document';
      notifyListeners();
      return false;
    }
    _errorMessage = null;
    return true;
  }
}

extension KYCModelExtension on KYCModel {
  KYCModel copyWith({
    String? firstName,
    String? lastName,
    String? accountNumber,
    String? ifsc,
    String? accountName,
    bool? refundAccount,
    String? verifiedStatus,
    String? status,
    String? documentType,
    String? documentPath,
  }) {
    return KYCModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifsc: ifsc ?? this.ifsc,
      accountName: accountName ?? this.accountName,
      refundAccount: refundAccount ?? this.refundAccount,
      verifiedStatus: verifiedStatus ?? this.verifiedStatus,
      status: status ?? this.status,
      documentType: documentType ?? this.documentType,
      documentPath: documentPath ?? this.documentPath,
    );
  }
}