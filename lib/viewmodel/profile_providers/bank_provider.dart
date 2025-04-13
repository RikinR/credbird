import 'package:credbird/model/user_models/bank_model.dart';
import 'package:credbird/repositories/user_repository/kyc_repository.dart';
import 'package:flutter/material.dart';

class BankProvider with ChangeNotifier {
  BankModel _bankData = BankModel();
  bool _isLoading = false;
  String? _errorMessage;
  final KycRepository _repository = KycRepository();

  BankModel get bankData => _bankData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void updateBankDetails({
    String? accountNumber,
    String? ifsc,
    String? accountName,
    bool? refundAccount,
  }) {
    _bankData = _bankData.copyWith(
      accountNumber: accountNumber,
      ifsc: ifsc,
      accountName: accountName,
      refundAccount: refundAccount,
    );
    notifyListeners();
  }

  Future<void> submitBankDetails() async {
    if (_validateForm()) {
      _isLoading = true;
      notifyListeners();

      try {
        _repository.addOrUpdateBankDetails(
          accountNumber: _bankData.accountNumber!,
          ifsc: _bankData.ifsc!,
          accountName: _bankData.accountName!,
          verifiedId: _bankData.verifiedStatus ?? "PENDING",
          refundAccount: _bankData.refundAccount ?? false,
          id: null, 
          verifiedStatus: _bankData.verifiedStatus,
          status: _bankData.status ?? "ACTIVE",
        );

        _isLoading = false;
        notifyListeners();
      } catch (e) {
        _errorMessage = 'Failed to submit bank details: ${e.toString()}';
        _isLoading = false;
        notifyListeners();
        rethrow;
      }
    }
  }

  bool _validateForm() {
    if (_bankData.accountNumber == null || _bankData.accountNumber!.isEmpty) {
      _errorMessage = 'Please enter your account number';
      notifyListeners();
      return false;
    }
    if (_bankData.ifsc == null || _bankData.ifsc!.isEmpty) {
      _errorMessage = 'Please enter your IFSC code';
      notifyListeners();
      return false;
    }
    if (_bankData.accountName == null || _bankData.accountName!.isEmpty) {
      _errorMessage = 'Please enter account holder name';
      notifyListeners();
      return false;
    }
    _errorMessage = null;
    return true;
  }
}

extension BankModelExtension on BankModel {
  BankModel copyWith({
    String? accountNumber,
    String? ifsc,
    String? accountName,
    bool? refundAccount,
    String? verifiedStatus,
    String? status,
  }) {
    return BankModel(
      accountNumber: accountNumber ?? this.accountNumber,
      ifsc: ifsc ?? this.ifsc,
      accountName: accountName ?? this.accountName,
      refundAccount: refundAccount ?? this.refundAccount,
      verifiedStatus: verifiedStatus ?? this.verifiedStatus,
      status: status ?? this.status,
    );
  }
}
