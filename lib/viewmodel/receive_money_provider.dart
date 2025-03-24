import 'package:flutter/material.dart';

class ReceiveMoneyViewModel extends ChangeNotifier {
  double _amount = 0.0;
  final List<String> _contacts = ["Jonas", "Martha", "Rakesh", "Sunidhi"];
  final List<Map<String, String>> _receivedHistory = [];
  TextEditingController amountController = TextEditingController();

  double get amount => _amount;
  List<String> get contacts => _contacts;
  List<Map<String, String>> get receivedHistory => _receivedHistory;

  void updateAmount(double newAmount) {
    _amount = newAmount;
    notifyListeners();
  }

  void requestMoney(BuildContext context, String sender) {
    if (_amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid amount")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Request"),
        content: Text("Request \$${_amount.toStringAsFixed(2)} from $sender?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _receivedHistory.insert(0, {
                "sender": sender,
                "amount": "\$${_amount.toStringAsFixed(2)}"
              });

              _amount = 0.0;
              amountController.clear();
              notifyListeners();

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Request sent to $sender")),
              );
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
