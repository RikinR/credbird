import 'package:credbird/repositories/remitence_repository/invoices_repository.dart';
import 'package:flutter/material.dart';

class InvoiceViewModel with ChangeNotifier {
  final InvoiceRepository _repository;

  InvoiceViewModel(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<dynamic> _invoicesAssignedForMe = [];
  List<dynamic> get invoicesAssignedForMe => _invoicesAssignedForMe;

  List<dynamic> _invoicesAssignedByMe = [];
  List<dynamic> get invoicesAssignedByMe => _invoicesAssignedByMe;

  String? _error;
  String? get error => _error;

  Future<void> loadInvoicesAssignedForMe() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _invoicesAssignedForMe = await _repository.getInvoicesAssignedForMe();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadInvoicesAssignedByMe() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _invoicesAssignedByMe = await _repository.getInvoicesAssignedByMe();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createInvoice({
    required String remitterId,
    required String remittanceTypeId,
    required String remittanceSubTypeId,
    required String agentId,
    required String currencyId,
    required String accountId,
    String? intermediaryName,
    required String intermediaryBankName,
    required String bicCode,
    required String intermediaryBankAddress,
    required String sortBsbAbaTransitFed,
    required List<Map<String, String>> invoices,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.createInvoice(
        remitterId: remitterId,
        remittanceTypeId: remittanceTypeId,
        remittanceSubTypeId: remittanceSubTypeId,
        agentId: agentId,
        currencyId: currencyId,
        accountId: accountId,
        intermediaryName: intermediaryName,
        intermediaryBankName: intermediaryBankName,
        bicCode: bicCode,
        intermediaryBankAddress: intermediaryBankAddress,
        sortBsbAbaTransitFed: sortBsbAbaTransitFed,
        invoices: invoices,
      );
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}