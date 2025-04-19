import 'package:credbird/model/remittance/transaction_model.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiveMoneyViewModel extends ChangeNotifier {
  double _amount = 0.0;
  String? _selectedContact;
  String _userId = "@user123";
  final List<String> _contacts = [
    "Jonas Hoffman",
    "Martha Richards",
    "Rakesh Thomas",
    "Sunidhi Mittal",
    "Alex Smith",
  ];
  final List<Map<String, dynamic>> _receivedHistory = [];
  TextEditingController amountController = TextEditingController();

  double get amount => _amount;
  String? get selectedContact => _selectedContact;
  String get userId => _userId;
  List<String> get contacts => _contacts;
  List<Map<String, dynamic>> get receivedHistory => _receivedHistory;

  ReceiveMoneyViewModel() {
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId') ?? "@user123";
    notifyListeners();
  }

  void updateAmount(double newAmount) {
    _amount = newAmount;
    notifyListeners();
  }

  void selectContact(String contact) {
    _selectedContact = contact;
    notifyListeners();
  }

  void requestMoney(BuildContext context) {
    final amount = _amount;
    if (amount <= 0 || _selectedContact == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid amount and select a contact"),
        ),
      );
      return;
    }

    _receivedHistory.insert(0, {
      "sender": _selectedContact,
      "amount": amount,
      "date": DateTime.now().toString(),
      "isPositive": true,
    });

    final homeProvider = Provider.of<HomeViewModel>(context, listen: false);
    homeProvider.addTransaction(
      Transaction(
        recipient: _selectedContact!,
        date: DateTime.now().toString().substring(0, 10),
        amount: amount,
        isIncoming: true,
      ),
    );
    homeProvider.addFunds(amount);

    _amount = 0.0;
    amountController.clear();
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Requested \$$amount from $_selectedContact")),
    );
  }

  void addContact(String name) {
    if (name.isNotEmpty && !_contacts.contains(name)) {
      _contacts.add(name);
      notifyListeners();
    }
  }

  Future<void> updateUserId(String newId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', newId);
    _userId = newId;
    notifyListeners();
  }
}