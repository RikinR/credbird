import 'package:flutter/material.dart';

class InternationalTouristViewModel extends ChangeNotifier {
  String _selectedFromCurrency = 'USD';
  String _selectedToCurrency = 'INR';
  double _amount = 0.0;
  double _exchangeRate = 83.12;
  String? _selectedContact;
  final List<String> _recentContacts = [
    "Jonas Hoffman",
    "Martha Richards",
    "Rakesh Thomas",
    "Sunidhi Mittal",
    "Alex Smith",
  ];
  final List<Map<String, dynamic>> _transactions = [];
  bool _hasTravelCard = false;
  String? _travelCardCurrency;
  String? _travelCardCountry;

  bool get hasTravelCard => _hasTravelCard;
  String? get travelCardCurrency => _travelCardCurrency;
  String? get travelCardCountry => _travelCardCountry;

  String get selectedFromCurrency => _selectedFromCurrency;
  String get selectedToCurrency => _selectedToCurrency;
  double get amount => _amount;
  double get exchangeRate => _exchangeRate;
  double get convertedAmount => _amount * _exchangeRate;
  String? get selectedContact => _selectedContact;
  List<String> get recentContacts => _recentContacts;
  List<Map<String, dynamic>> get transactions => _transactions;

  final List<String> _currencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'AUD',
    'CAD',
    'INR',
    'SGD',
    'AED',
  ];

  List<String> get currencies => _currencies;

  void setFromCurrency(String currency) {
    _selectedFromCurrency = currency;
    _updateExchangeRate();
    notifyListeners();
  }

  Future<void> generateTravelCard(BuildContext context, String currency, String country) async {
    _hasTravelCard = true;
    _travelCardCurrency = currency;
    _travelCardCountry = country;
    notifyListeners();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Travel card for $country generated successfully!')),
    );
  }

  void setToCurrency(String currency) {
    _selectedToCurrency = currency;
    _updateExchangeRate();
    notifyListeners();
  }

  void setAmount(double amount) {
    _amount = amount;
    notifyListeners();
  }

  void selectContact(String contact) {
    _selectedContact = contact;
    notifyListeners();
  }

  void _updateExchangeRate() {
    final rates = {
      'USD': {'INR': 83.12, 'EUR': 0.92, 'GBP': 0.79},
      'EUR': {'INR': 89.50, 'USD': 1.09, 'GBP': 0.86},
      'GBP': {'INR': 104.20, 'USD': 1.27, 'EUR': 1.16},
      'INR': {'USD': 0.012, 'EUR': 0.011, 'GBP': 0.0096},
    };

    _exchangeRate = rates[_selectedFromCurrency]?[_selectedToCurrency] ?? 1.0;
  }

  Future<void> sendInternationalPayment(BuildContext context) async {
    if (_amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid amount")),
      );
      return;
    }

    if (_selectedContact == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a contact")),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Payment"),
        content: Text(
          "Send ${_amount.toStringAsFixed(2)} $_selectedFromCurrency to $_selectedContact?",
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

    if (confirmed == true) {
      _transactions.insert(0, {
        "recipient": _selectedContact,
        "amount": _amount,
        "currency": _selectedFromCurrency,
        "date": DateTime.now().toString().substring(0, 10),
        "convertedAmount": convertedAmount,
        "toCurrency": _selectedToCurrency,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sent ${_amount.toStringAsFixed(2)} $_selectedFromCurrency to $_selectedContact',
          ),
        ),
      );
      _amount = 0.0;
      notifyListeners();
    }
  }

  Future<void> addNewContact(BuildContext context) async {
    final nameController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
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
}