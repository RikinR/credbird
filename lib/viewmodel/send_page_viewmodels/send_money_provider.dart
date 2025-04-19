// ignore_for_file: use_build_context_synchronously

import 'package:credbird/model/transaction_model.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/home_provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/beneficiary_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum PaymentMethod { contact, beneficiary }

class SendMoneyViewModel extends ChangeNotifier {
  double _amount = 0.0;
  String? _selectedContact;
  PaymentMethod _paymentMethod = PaymentMethod.contact;
  final List<String> _recentContacts = [
    "Jonas Hoffman",
    "Martha Richards",
    "Rakesh Thomas",
    "Sunidhi Mittal",
    "Alex Smith",
  ];
  final TextEditingController amountController = TextEditingController();

  double get amount => _amount;
  String? get selectedContact => _selectedContact;
  PaymentMethod get paymentMethod => _paymentMethod;
  List<String> get recentContacts => _recentContacts;

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

  Future<bool> sendMoney(BuildContext context) async {
    if (_amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid amount")),
      );
      return false;
    }

    String recipient;
    String? recipientDetails;

    if (_paymentMethod == PaymentMethod.contact) {
      if (_selectedContact == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a contact")),
        );
        return false;
      }
      recipient = _selectedContact!;
    } else {
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
      recipientDetails =
          "${beneficiary.bankName} • ${beneficiary.accountNumber}";
    }

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

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}
