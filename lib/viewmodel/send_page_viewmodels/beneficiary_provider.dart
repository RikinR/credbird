import 'package:credbird/model/beneficiray_models.dart';
import 'package:flutter/material.dart';

class BeneficiaryProvider extends ChangeNotifier {
  final List<Beneficiary> _beneficiaries = [];
  Beneficiary? _selectedBeneficiary;

  List<Beneficiary> get beneficiaries => _beneficiaries;
  Beneficiary? get selectedBeneficiary => _selectedBeneficiary;

  void addBeneficiary(Beneficiary beneficiary) {
    _beneficiaries.add(beneficiary);
    notifyListeners();
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