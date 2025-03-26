import 'package:credbird/model/transaction_model.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  double _balance = 3576.89;
  String _userName = "User";
  bool _isBalanceVisible = true;
  final List<Transaction> _transactions = [
    Transaction(
      recipient: "Shahid Miah",
      date: "2023/09/22",
      amount: 340.00,
      isIncoming: false,
    ),
    Transaction(
      recipient: "Jonas Hopfmann",
      date: "2024/09/22",
      amount: 140.00,
      isIncoming: true,
    ),
    Transaction(
      recipient: "Martha Nielman",
      date: "2025/01/24",
      amount: 1340.00,
      isIncoming: false,
    ),
    Transaction(
      recipient: "Raman Thomas",
      date: "2025/02/21",
      amount: 1340.00,
      isIncoming: true,
    ),
    Transaction(
      recipient: "Cameron Williamson",
      date: "2023/09/22",
      amount: 240.00,
      isIncoming: true,
    ),
    Transaction(
      recipient: "Shahid Miah",
      date: "2023/09/22",
      amount: 340.00,
      isIncoming: true,
    ),
    Transaction(
      recipient: "Jonas Hopfmann",
      date: "2024/09/22",
      amount: 140.00,
      isIncoming: false,
    ),
    Transaction(
      recipient: "Martha Nielman",
      date: "2025/01/24",
      amount: 1340.00,
      isIncoming: true,
    ),
    Transaction(
      recipient: "Raman Thomas",
      date: "2025/02/21",
      amount: 1340.00,
      isIncoming: false,
    ),
    Transaction(
      recipient: "Cameron Williamson",
      date: "2023/09/22",
      amount: 240.00,
      isIncoming: false,
    ),
  ];

  double get balance => _balance;
  String get userName => _userName;
  bool get isBalanceVisible => _isBalanceVisible;
  List<Transaction> get transactions => _transactions;

  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  void updateUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  void addFunds(double amount) {
    _balance += amount;
    notifyListeners();
  }

  void requestVirtualCard(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Virtual card request initiated')),
    );
  }

  void internationalTourist(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('International tourist service started')),
    );
  }

  void showForexRates(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Displaying live forex rates')),
    );
  }

  void contactSupport(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Connecting to support...')));
  }

  void showTransactionHistory(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Transaction History'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _transactions.length,
          itemBuilder: (context, index) {
            final transaction = _transactions[index];
            return ListTile(
              leading: Icon(
                transaction.isIncoming 
                    ? Icons.arrow_downward 
                    : Icons.arrow_upward,
                color: transaction.isIncoming ? Colors.green : Colors.red,
              ),
              title: Text(transaction.recipient),
              subtitle: Text(transaction.date),
              trailing: Text(
                '${transaction.isIncoming ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: transaction.isIncoming ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
}
