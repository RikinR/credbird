import 'package:credbird/model/beneficiary_models/beneficiray_models.dart';
import 'package:credbird/repositories/remitence_repository/beneficairy_repository.dart';
import 'package:flutter/material.dart';

class BeneficiaryProvider extends ChangeNotifier {
  final List<Beneficiary> _beneficiaries = [];
  Beneficiary? _selectedBeneficiary;
  bool _isLoading = false;
  String? _error;

  final BeneficiaryRepository _repository = BeneficiaryRepository();

  List<Beneficiary> get beneficiaries => _beneficiaries;
  Beneficiary? get selectedBeneficiary => _selectedBeneficiary;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> _currencies = [];
  String? _selectedCurrencyId;

  List<Map<String, dynamic>> get currencies => _currencies;
  String? get selectedCurrencyId => _selectedCurrencyId;
  set selectedCurrencyId(String? id) {
    _selectedCurrencyId = id;
    notifyListeners();
  }

  Future<void> loadCurrencyList() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currencies = await _repository.getCurrencyList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBeneficiary(
    Beneficiary beneficiary,
    String currencyId,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.createBeneficiary(
        currencyId: currencyId,
        benificiaryName: beneficiary.name,
        address: beneficiary.address ?? '',
        city: beneficiary.city,
        country: beneficiary.country,
        accountNumber: beneficiary.accountNumber,
        bankName: beneficiary.bankName,
        bankAddress: beneficiary.bankAddress,
        swiftCode: beneficiary.swiftCode ?? '',
        iban_bsb_aba: beneficiary.ibanBsbAba,
      );

      if (response['success'] == true) {
        _beneficiaries.add(beneficiary);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBeneficiaries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.getBeneficiaries();
      if (response['success'] == true) {
        _beneficiaries.clear();
        final result = response['data']['result'] as List;
        for (var item in result) {
          _beneficiaries.add(
            Beneficiary(
              id: item['_id'],
              name: item['benificiaryName'],
              accountNumber: item['accountNumber'],
              bankName: item['bankName'],
              branchName: '',
              swiftCode: item['swiftCode'],
              ibanBsbAba: item['iban_bsb_aba'],
              address: item['address'],
              city: item['city'],
              country: item['country'],
              bankAddress: item['bankAddress'],
              isInternational: true,
              isActivated: item['isActivated'] ?? true,
            ),
          );
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Beneficiary?> fetchBeneficiaryDetailById(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _repository.getBeneficiaryById(id);
      final beneficiary = Beneficiary(
        id: data['_id'],
        name: data['benificiaryName'],
        accountNumber: data['accountNumber'],
        bankName: data['bankName'],
        bankAddress: data['bankAddress'],
        city: data['city'],
        country: data['country'],
        swiftCode: data['swiftCode'],
        ibanBsbAba: data['iban_bsb_aba'],
        address: data['address'],
        branchName: '',
        isInternational: true,
        isActivated: data['isActivated'] ?? true,
      );

      return beneficiary;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleBeneficiaryActivation(String id, bool isActivated) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _repository.updateBeneficiaryActivation(
        id: id,
        isActivated: isActivated,
      );
      return result;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void removeBeneficiary(String id) {
    _beneficiaries.removeWhere((beneficiary) => beneficiary.id == id);
    notifyListeners();
  }

  void selectBeneficiary(Beneficiary beneficiary) {
    _selectedBeneficiary = beneficiary;
    notifyListeners();
  }

  void clearSelection() {
    _selectedBeneficiary = null;
    notifyListeners();
  }
}
