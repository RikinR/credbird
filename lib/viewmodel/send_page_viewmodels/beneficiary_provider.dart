import 'package:credbird/model/beneficiray_models.dart';
import 'package:flutter/material.dart';

class BeneficiaryProvider extends ChangeNotifier {
  final List<Beneficiary> _beneficiaries = [];

  List<Beneficiary> get beneficiaries => _beneficiaries;

  void addBeneficiary(Beneficiary beneficiary) {
    _beneficiaries.add(beneficiary);
    notifyListeners();
  }

  void removeBeneficiary(String id) {
    _beneficiaries.removeWhere((beneficiary) => beneficiary.id == id);
    notifyListeners();
  }
}