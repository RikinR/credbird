// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:credbird/model/remittance/transaction_create_model.dart';
import 'package:credbird/model/remittance/transaction_model.dart';
import 'package:credbird/repositories/remitence_repository/remittance_repository.dart';
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
  final TextEditingController purposeController =
      TextEditingController(); 
  String _nostroCharge = 'SHA'; 

  double get amount => _amount;
  String? get selectedContact => _selectedContact;
  PaymentMethod get paymentMethod => _paymentMethod;
  List<String> get recentContacts => _recentContacts;
  String get nostroCharge => _nostroCharge;
  String get purpose =>
      purposeController.text; 
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

  Future<void> addNewContact(BuildContext context) async {
    final nameController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Add New Contact"),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Enter full name",
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Add"),
              ),
            ],
          ),
    );

    if (result == true && nameController.text.isNotEmpty) {
      addRecipient(nameController.text.trim());
    }
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

  String? selectedRemitterId;
  String? selectedBeneficiaryId;
  String? selectedRemittanceTypeId;
  String? selectedRemittanceSubTypeId;
  String? selectedIntermediaryId;
  String? selectedCurrencyId;
  bool isLoading = false;
  String? transactionError; 

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

  // Future<void> createRemittanceTransaction(BuildContext context) async {
  //   isLoading = true;
  //   transactionError = null;
  //   notifyListeners();
  //   if (selectedRemitterId == null ||
  //       selectedBeneficiaryId == null ||
  //       selectedRemittanceTypeId == null ||
  //       selectedRemittanceSubTypeId == null ||
  //       selectedCurrencyId == null ||
  //       purpose.isEmpty ||
  //       _amount <= 0 ||
  //       _nostroCharge.isEmpty) {
  //     transactionError = "Please fill in all the required fields.";
  //     isLoading = false;
  //     notifyListeners();
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text(transactionError!)));
  //     return;
  //   }
  //   final transaction = TransactionCreateModel(
  //     remitterId: selectedRemitterId!,
  //     beneficiaryId: selectedBeneficiaryId!,
  //     remittanceTypeId: selectedRemittanceTypeId!,
  //     remittanceSubTypeId: selectedRemittanceSubTypeId!,
  //     intermediaryId: selectedIntermediaryId,
  //     currencyId: selectedCurrencyId!,
  //     amount: _amount,
  //     purpose: purpose,
  //     nostroCharge: _nostroCharge,
  //     invoices: [
  //       Invoice(
  //         invoiceId: "773733",
  //         totalAmount: 2882.0,
  //         remainingAmount: 0.0,
  //         paidAmount: _amount,
  //         reason: "Advance /Partial payment",
  //         showReason: true,
  //       ),
  //     ],
  //     lrsList: [
  //       Lrs(
  //         address: "",
  //         addressPlaceHolder:
  //             "Enter comma separated Name and address of transactions done outside platform",
  //         datesPlaceHolder:
  //             "Enter comma separated dates of transactions done outside platform",
  //         amount: "",
  //         dates: "",
  //         usdAmount: 0,
  //         info: "Transaction Done outside the Pay2Remit in 23-24",
  //         disabled: false,
  //       ),
  //       Lrs(
  //         address: "",
  //         amount: "",
  //         addressPlaceHolder:
  //             "Name and address will appear automatically after transaction completed.",
  //         datesPlaceHolder:
  //             "Dates will appear automatically after transaction completed.",
  //         dates: "",
  //         usdAmount: 0,
  //         info: "Transaction Done from the Pay2Remit in 23-24",
  //         disabled: true,
  //       ),
  //     ],
  //   );
  //   try {
  //     final response = await _repo.createTransaction(transaction);
  //     print('Transaction created successfully: $response');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Transaction initiated successfully!")),
  //     );
  //   } catch (e) {
  //     print('[createRemittanceTransaction] Error: $e');
  //     if (e is Exception) {
  //       try {
  //         final responseData = jsonDecode(e.toString().split(': ')[1]);
  //         if (responseData['success'] == false &&
  //             responseData['error'] != null &&
  //             responseData['error']['msg'] ==
  //                 "Complete you kyc first to start remittance") {
  //           showDialog(
  //             context: context,
  //             builder:
  //                 (BuildContext context) => AlertDialog(
  //                   title: const Text("KYC Required"),
  //                   content: const Text(
  //                     "Complete your KYC first to create a transaction.",
  //                   ),
  //                   actions: <Widget>[
  //                     TextButton(
  //                       child: const Text("OK"),
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //           );
  //           transactionError = "KYC Required";
  //           return;
  //         } else {
  //           transactionError = e.toString();
  //           ScaffoldMessenger.of(
  //             context,
  //           ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
  //         }
  //       } catch (jsonError) {
  //         showDialog(
  //           context: context,
  //           builder:
  //               (BuildContext context) => AlertDialog(
  //                 title: const Text("KYC Required"),
  //                 content: const Text(
  //                   "Complete your KYC first to create a transaction.",
  //                 ),
  //                 actions: <Widget>[
  //                   TextButton(
  //                     child: const Text("OK"),
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                   ),
  //                 ],
  //               ),
  //         );
  //       }
  //     } else {
  //       transactionError = e.toString();
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
  //     }
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  @override
  void dispose() {
    amountController.dispose();
    purposeController.dispose();
    super.dispose();
  }
}
