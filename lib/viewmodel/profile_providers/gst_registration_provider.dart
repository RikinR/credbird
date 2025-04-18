import 'package:credbird/model/gst_registration_model.dart';
import 'package:credbird/repositories/registration_repository.dart';
import 'package:flutter/material.dart';

class GstRegistrationProvider with ChangeNotifier {
  final RegistrationRepository _repository = RegistrationRepository();
  GstRegistrationModel _registrationData = GstRegistrationModel();
  bool _isLoading = false;
  String? _errorMessage;
  int _currentStep = 0;

  GstRegistrationModel get registrationData => _registrationData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentStep => _currentStep;

  void updateAccountNumber(String value) {
    _tempAccountNumber = value;
    notifyListeners();
  }

  void updateIfsc(String value) {
    _tempIfsc = value;
    notifyListeners();
  }

  void updateBasicDetails({
    required String panNumber,
    required String gstNumber,
    required String orgName,
    required String orgType,
    required String orgAddress,
    required String orgPin,
    required String orgCity,
    required String orgState,
    required String orgCountry,
  }) {
    _registrationData = _registrationData.copyWith(
      panNumber: panNumber,
      gstNumber: gstNumber,
      orgName: orgName,
      orgType: orgType,
      orgAddress: orgAddress,
      orgPin: orgPin,
      orgCity: orgCity,
      orgState: orgState,
      orgCountry: orgCountry,
    );
    notifyListeners();
  }

  void updatePan(String pan) {
    _registrationData = _registrationData.copyWith(panNumber: pan);
    notifyListeners();
  }

  void updateGst(String gst) {
    _registrationData = _registrationData.copyWith(gstNumber: gst);
    notifyListeners();
  }

  void updateBank(String accountNumber, String ifsc) {
    _tempAccountNumber = accountNumber;
    _tempIfsc = ifsc;
    notifyListeners();
  }

  void updateContact(String name, String mobile, String email) {
    _registrationData.contactDetails = [
      ContactDetail(name: name, mobile: mobile, email: email),
    ];
    notifyListeners();
  }

  String? _tempAccountNumber;
  String? _tempIfsc;

  Future<void> verifyGst() async {
    _setLoading(true);
    try {
      final data = await _repository.verifyGst(_registrationData.gstNumber!);
      _registrationData = _registrationData.copyWith(
        orgName: data['businessName'],
        orgType: data['orgType'],
        panNumber: data['panNumber'],
      );
      goToStep(1);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyBankDetails() async {
    if (_tempAccountNumber == null || _tempAccountNumber!.isEmpty) {
      _setError("Please enter account number");
      return;
    }
    if (_tempIfsc == null || _tempIfsc!.isEmpty) {
      _setError("Please enter IFSC code");
      return;
    }

    _setLoading(true);
    try {
      final data = await _repository.verifyBankDetails(
        _tempAccountNumber!,
        _tempIfsc!,
      );

      final fullName = data['full_name'];
      final verifiedId = data['verifiedId'];

      if (fullName == null || verifiedId == null) {
        _setError(
          "Bank verification failed: missing account name or verified ID.",
        );
        return;
      }

      final detail = BankDetail(
        accountNumber: _tempAccountNumber!,
        ifsc: _tempIfsc!,
        accountName: fullName.toString(),
        verifiedId: verifiedId.toString(),
      );

      _registrationData.bankDetails = [detail];
      goToStep(2);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> submitRegistration() async {
    _setLoading(true);
    try {
      await _repository.completeGstRegistration(_registrationData);
      goToStep(3);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void goToStep(int step) {
    _currentStep = step;
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
}