import 'package:flutter/material.dart';
import 'package:credbird/model/registration_model.dart';
import 'package:credbird/repositories/registration_repository.dart';

class RegistrationProvider with ChangeNotifier {
  final RegistrationRepository _repository = RegistrationRepository();
  RegistrationModel _registrationData = RegistrationModel();
  bool _isLoading = false;
  String? _errorMessage;
  int _currentStep = 0;

  RegistrationModel get registrationData => _registrationData;
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
    required String passport,
    required String mobile,
    required String email,
    required String address,
    required String pin,
    required String city,
    required String state,
    required String country,
  }) {
    _registrationData = _registrationData.copyWith(
      passport: passport,
      mobile: mobile,
      email: email,
      orgAddress: address,
      orgPin: pin,
      orgCity: city,
      orgState: state,
      orgCountry: country,
    );
    notifyListeners();
  }

  void updatePan(String pan) {
    _registrationData = _registrationData.copyWith(panNumber: pan);
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

  Future<void> verifyPan() async {
    _setLoading(true);
    try {
      final data = await _repository.verifyPan(_registrationData.panNumber!);
      final tcsRaw = data['tcs_rate'];
      _registrationData = _registrationData.copyWith(
        fullName: data['full_name'],
        tcsRate: tcsRaw != null ? (tcsRaw as num).toDouble() : 0.0,
        verifiedId: data['verifiedId']?.toString(),
      );

      goToStep(2);
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
      goToStep(3);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> submitRegistration() async {
    _setLoading(true);
    try {
      await _repository.completeRegistration(_registrationData);
      goToStep(4);
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
