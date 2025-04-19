import 'package:credbird/model/remittance/remitter_model.dart';
import 'package:credbird/repositories/user_repository/registration_repository.dart';
import 'package:credbird/repositories/remitence_repository/remittance_repository.dart';
import 'package:flutter/material.dart';

class RemitterProvider extends ChangeNotifier {
  final RemittanceRepository _remitRepo = RemittanceRepository();
  final RegistrationRepository _regRepo = RegistrationRepository();

  bool _isLoading = false;
  String? _error;
  String? _remitterId;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get remitterId => _remitterId;

  Future<void> createRemitter({
    required String pan,
    required String accountNumber,
    required String ifsc,
    required String email,
    required String mobile,
    required String address,
    required String city,
    required String state,
    required String country,
    required String pin,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final panData = await _regRepo.verifyPan(pan);
      final bankData = await _regRepo.verifyBankDetails(accountNumber, ifsc);

      final remitter = RemitterModel(
        remitterType: "Self",
        remitterPan: pan,
        panVerifiedId: panData['verifiedId'],
        remitterName: panData['full_name'],
        tcsRate: panData['tcs_rate']?.toDouble() ?? 5,
        remitterAddressProofType: "Passport", 
        remitterAddressProof: "YOUR_PASSPORT_NO",
        placeOfIssue: "DELHI",
        dateOfIssue: "2020-01-01",
        dateOfExpiry: "2030-01-01",
        mobile: mobile,
        emailId: email,
        address: address,
        city: city,
        state: state,
        country: country,
        pin: pin,
        accountNumber: accountNumber,
        ifsc: ifsc,
        accountName: bankData['full_name'],
        accountVerifiedId: bankData['verifiedId'],
      );

      final response = await _remitRepo.createRemitter(remitter);
      _remitterId = response['_id'];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
