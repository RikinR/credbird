// ignore_for_file: use_build_context_synchronously, avoid_print, curly_braces_in_flow_control_structures

import 'package:credbird/model/remittance/transaction_create_model.dart';
import 'package:credbird/model/remittance/transaction_model.dart';
import 'package:credbird/repositories/remitence_repository/remittance_repository.dart';
import 'package:credbird/view/send_page_views/remittance_view/initate_remittance_views/documents_upload_view.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/home_provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/beneficiary_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum PaymentMethod { beneficiary }

class SendMoneyViewModel extends ChangeNotifier {
  double _amount = 0.0;
  String? _selectedContact;
  PaymentMethod _paymentMethod = PaymentMethod.beneficiary;
  final List<String> _recentContacts = [
    "Jonas Hoffman",
    "Martha Richards",
    "Rakesh Thomas",
    "Sunidhi Mittal",
    "Alex Smith",
  ];
  final TextEditingController amountController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  String _nostroCharge = 'SHA';

  double get amount => _amount;
  String? get selectedContact => _selectedContact;
  PaymentMethod get paymentMethod => _paymentMethod;
  List<String> get recentContacts => _recentContacts;
  String get nostroCharge => _nostroCharge;
  String get purpose => purposeController.text;
  set purpose(String value) => purposeController.text = value;

  void updateAmount(double newAmount) {
    _amount = newAmount;
    notifyListeners();
  }

  void setPaymentMethod(PaymentMethod method) {
    _paymentMethod = method;
    _selectedContact = null;
    notifyListeners();
  }

  void selectContact(String contact) {
    _selectedContact = contact;
    notifyListeners();
  }

  void addToAmount(String value) {
    String newAmount = amountController.text;
    if (value == ".") {
      if (!newAmount.contains(".")) {
        newAmount += ".";
      }
    } else if (value == "backspace") {
      if (newAmount.isNotEmpty) {
        newAmount = newAmount.substring(0, newAmount.length - 1);
      }
    } else {
      newAmount += value;
    }

    amountController.text = newAmount;
    _amount = double.tryParse(newAmount) ?? 0.0;
    notifyListeners();
  }

  void setNostroCharge(String? value) {
    if (value != null) {
      _nostroCharge = value;
      notifyListeners();
    }
  }

  Future<bool> sendMoney(BuildContext context) async {
    if (_amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid amount")),
      );
      return false;
    }

    String recipient;
    String? recipientDetails;

    final beneficiary =
        Provider.of<BeneficiaryProvider>(
          context,
          listen: false,
        ).selectedBeneficiary;
    if (beneficiary == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a beneficiary")),
      );
      return false;
    }
    recipient = beneficiary.name;
    recipientDetails = "${beneficiary.bankName} • ${beneficiary.accountNumber}";

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Confirm Payment"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Send \$${_amount.toStringAsFixed(2)} to $recipient?"),
                if (recipientDetails != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    recipientDetails,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Confirm"),
              ),
            ],
          ),
    );

    if (confirmed != true) return false;

    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    homeViewModel.addTransaction(
      Transaction(
        recipient: recipient,
        date: DateTime.now().toString(),
        amount: _amount,
        isIncoming: false,
        details: recipientDetails,
      ),
    );
    homeViewModel.addFunds(-_amount);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Sent \$${_amount.toStringAsFixed(2)} to $recipient"),
      ),
    );

    _amount = 0.0;
    amountController.clear();
    _selectedContact = null;
    Provider.of<BeneficiaryProvider>(context, listen: false).clearSelection();
    notifyListeners();

    return true;
  }

  void addRecipient(String name) {
    if (name.isNotEmpty && !_recentContacts.contains(name)) {
      _recentContacts.add(name);
      notifyListeners();
    }
  }

  final RemittanceRepository _repo = RemittanceRepository();

  List<Map<String, dynamic>> remitters = [];
  List<Map<String, dynamic>> beneficiaries = [];
  List<Map<String, dynamic>> remittanceTypes = [];
  List<Map<String, dynamic>> subTypes = [];
  List<Map<String, dynamic>> intermediaries = [];
  List<Map<String, dynamic>> currencies = [];

  List<Map<String, dynamic>> lrsList = [];
  List<Map<String, dynamic>> invoices = [];

  String? selectedRemitterId;
  String? selectedBeneficiaryId;
  String? selectedRemittanceTypeId;
  String? selectedRemittanceSubTypeId;
  String? selectedIntermediaryId;
  String? selectedCurrencyId;
  bool isLoading = false;
  String? transactionError;

  bool educationDeclaration = false;
  String? educationDeclarationNumber;
  double educationDeclarationAmount = 0.0;

  void addLRSInfo(Map<String, dynamic> lrsInfo) {
    lrsList.add(lrsInfo);
    notifyListeners();
  }

  void addInvoice(Map<String, dynamic> invoice) {
    invoices.add(invoice);
    notifyListeners();
  }

  Future<void> loadDropdownData() async {
    isLoading = true;
    notifyListeners();

    try {
      remitters = await _repo.getRemitterList();
      beneficiaries = await _repo.getBeneficiaryList();
      remittanceTypes = await _repo.getRemittanceTypes();
      intermediaries = await _repo.getIntermediaryList();
      currencies = await _repo.getCurrencyList();
    } catch (e) {
      print("Error loading dropdowns: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSubTypes(String remittanceTypeId) async {
    selectedRemittanceSubTypeId = null;
    notifyListeners();
    try {
      subTypes = await _repo.getRemittanceSubTypes(remittanceTypeId);
    } catch (e) {
      print("Failed to load subtypes");
    } finally {
      notifyListeners();
    }
  }

  Future<void> createRemittanceTransaction(BuildContext context) async {
    isLoading = true;
    transactionError = null;
    notifyListeners();

    final isEducationType =
        selectedRemittanceTypeId == "6332c5c737a25f1236f9f841";
    List<String> missingFields = [];

    if (selectedRemitterId == null) missingFields.add("Remitter");
    if (selectedBeneficiaryId == null) missingFields.add("Beneficiary");
    if (selectedRemittanceTypeId == null) missingFields.add("Remittance Type");
    if (selectedRemittanceSubTypeId == null)
      missingFields.add("Remittance Sub-Type");
    if (selectedCurrencyId == null) missingFields.add("Currency");
    if (purpose.isEmpty) missingFields.add("Purpose");
    if (_nostroCharge.isEmpty) missingFields.add("Nostro Charge");

    if (invoices.isEmpty && !(educationDeclaration && isEducationType)) {
      missingFields.add("Invoice or Education Declaration");
    }

    if (educationDeclaration && isEducationType) {
      if (educationDeclarationNumber == null ||
          educationDeclarationNumber!.isEmpty) {
        missingFields.add("Education Declaration Number");
      }
      if (educationDeclarationAmount <= 0) {
        missingFields.add("Education Declaration Amount");
      }
    }

    if (missingFields.isNotEmpty) {
      transactionError = "Missing: ${missingFields.join(', ')}";
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(transactionError!)));
      return;
    }

    try {
      final List<Invoice> invoiceModels =
          invoices.map((invoice) {
            final double total = invoice['totalAmount'];
            final double paid = invoice['transferAmount'];
            return Invoice(
              invoiceId: invoice['invoiceId'],
              totalAmount: total,
              remainingAmount: total - paid,
              paidAmount: paid,
              reason:
                  paid < total
                      ? "Advance /Partial payment"
                      : "Completed payment",
              showReason: paid < total,
            );
          }).toList();

      final List<Lrs> lrsModels =
          lrsList.map((lrs) {
            return Lrs(
              address: lrs['address'] ?? "",
              addressPlaceHolder: lrs['addressPlaceHolder'] ?? "",
              datesPlaceHolder: lrs['datesPlaceHolder'] ?? "",
              amount: lrs['amount'] ?? "",
              dates: lrs['dates'] ?? "",
              usdAmount:
                  lrs['usdAmount'] is double
                      ? lrs['usdAmount']
                      : double.tryParse('${lrs['usdAmount']}') ?? 0,
              info: lrs['info'] ?? "",
              disabled: lrs['disabled'] ?? false,
            );
          }).toList();

      final model = TransactionCreateModel(
        remitterId: selectedRemitterId!,
        beneficiaryId: selectedBeneficiaryId!,
        remittanceTypeId: selectedRemittanceTypeId!,
        remittanceSubTypeId: selectedRemittanceSubTypeId!,
        intermediaryId: selectedIntermediaryId,
        currencyId: selectedCurrencyId!,
        amount: _amount,
        purpose: purpose,
        nostroCharge: _nostroCharge,
        invoices: invoiceModels,
        lrsList: lrsModels,
        educationDeclaration: isEducationType ? educationDeclaration : null,
        educationDeclarationNumber:
            (educationDeclaration && isEducationType)
                ? educationDeclarationNumber
                : null,
        educationDeclarationAmount:
            (educationDeclaration && isEducationType)
                ? educationDeclarationAmount
                : null,
      );

      final response = await _repo.createTransaction(model);
      final transactionId = response["_id"];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => UploadDocumentsView(
                transactionId: transactionId,
                esign: true,
              ),
        ),
      );

      print('✅ Transaction created: $response');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaction initiated successfully!")),
      );
    } catch (e) {
      print("❌ Error creating transaction: $e");
      transactionError = e.toString();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    purposeController.dispose();
    super.dispose();
  }
}
