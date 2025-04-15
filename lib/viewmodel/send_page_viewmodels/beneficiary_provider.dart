import 'package:credbird/model/beneficiary_models/beneficiray_models.dart';
import 'package:credbird/repositories/beneficiary/beneficairy_repository.dart';
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

  Future<void> addBeneficiary(Beneficiary beneficiary) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.createBeneficiary(
        benificiaryName: beneficiary.name,
        address: beneficiary.address ?? '',
        city: beneficiary.city,
        country: beneficiary.country,
        accountNumber: beneficiary.accountNumber,
        bankName: beneficiary.bankName,
        bankAddress: beneficiary.bankAddress ?? '',
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
          _beneficiaries.add(Beneficiary(
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
          ));
        }
      }
    } catch (e) {
      _error = e.toString();
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