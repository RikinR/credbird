import 'package:flutter/material.dart';

class SendMoneyViewModel extends ChangeNotifier {
  double _amount = 0.0;
  final List<String> _recentContacts = ["Jonas", "Martha", "Rakesh", "Sunidhi"];
  final List<Map<String, String>> _transactionHistory = [];
  TextEditingController amountController = TextEditingController();

  double get amount => _amount;
  List<String> get recentContacts => _recentContacts;
  List<Map<String, String>> get transactionHistory => _transactionHistory;

  void updateAmount(double newAmount) {
    _amount = newAmount;
    notifyListeners();
  }

  void sendMoney(BuildContext context, String recipient) {
    if (_amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid amount")),
      );
      return;
    }

    _transactionHistory.insert(0, {
      "recipient": recipient,
      "amount": "\$${_amount.toStringAsFixed(2)}",
    });

    _amount = 0.0;
    amountController.clear();
    notifyListeners();
  }

  void addRecipient(String name) {
    if (name.isNotEmpty && !_recentContacts.contains(name)) {
      _recentContacts.add(name);
      notifyListeners();
    }
  }
}
