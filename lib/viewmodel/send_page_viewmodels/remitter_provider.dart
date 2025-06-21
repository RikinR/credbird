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
  String? _panName;
  String? _accountHolderName;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get remitterId => _remitterId;
  String? get panName => _panName;
  String? get accountHolderName => _accountHolderName;

  Future<void> createRemitter({
    required String remitterType,
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
    String? relationship,
    String? travellerFullName,
    String? passportNo,
    String? studentPlaceOfIssue,
    String? studentDateOfIssue,
    String? studentDateOfExpiry,
    String? studentAddress,
    String? remitterAddressProof,
    String? placeOfIssue,
    String? dateOfIssue,
    String? dateOfExpiry,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final panData = await _regRepo.verifyPan(pan);
      final bankData = await _regRepo.verifyBankDetails(accountNumber, ifsc);

      _panName = panData['full_name'];
      _accountHolderName = bankData['full_name'];

      final remitter = RemitterModel(
        remitterType: remitterType,
        remitterPan: pan,
        panVerifiedId: panData['verifiedId'],
        remitterName: panData['full_name'],
        tcsRate: panData['tcs_rate']?.toDouble(),
        remitterAddressProofType:
            remitterType == 'Self' ? 'Passport' : 'Aadhar',
        remitterAddressProof: remitterAddressProof ?? '',

        placeOfIssue: remitterType == 'Self' ? placeOfIssue : null,
        dateOfIssue: remitterType == 'Self' ? dateOfIssue : null,
        dateOfExpiry: remitterType == 'Self' ? dateOfExpiry : null,

        mobile: mobile,
        emailId: email,
        address: address,
        country: country,
        state: state,
        city: city,
        pin: pin,

        relationship: remitterType == 'Guardian' ? relationship : null,
        travellerFullName:
            remitterType == 'Guardian' ? travellerFullName : null,
        passportNo: remitterType == 'Guardian' ? passportNo : null,
        studentPlaceOfIssue:
            remitterType == 'Guardian' ? studentPlaceOfIssue : null,
        studentDateOfIssue:
            remitterType == 'Guardian' ? studentDateOfIssue : null,
        studentDateOfExpiry:
            remitterType == 'Guardian' ? studentDateOfExpiry : null,
        studentAddress: remitterType == 'Guardian' ? studentAddress : null,

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
