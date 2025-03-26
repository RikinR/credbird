import 'package:flutter/material.dart';

class ForexRatesViewModel extends ChangeNotifier {
  String _baseCurrency = 'INR';
  String _targetCurrency = 'USD';

  String get baseCurrency => _baseCurrency;
  String get targetCurrency => _targetCurrency;

  final List<String> _currencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'AUD',
    'CAD',
    'INR',
    'SGD',
    'AED'
  ];

  List<String> get currencies => _currencies;

  void setBaseCurrency(String currency) {
    _baseCurrency = currency;
    notifyListeners();
  }

  void setTargetCurrency(String currency) {
    _targetCurrency = currency;
    notifyListeners();
  }

  double getExchangeRate() {
    
    final rates = {
      'INR': {'USD': 0.012, 'EUR': 0.011, 'GBP': 0.0096},
      'USD': {'INR': 83.12, 'EUR': 0.92, 'GBP': 0.79},
      'EUR': {'INR': 89.50, 'USD': 1.09, 'GBP': 0.86},
      'GBP': {'INR': 104.20, 'USD': 1.27, 'EUR': 1.16},
    };

    return rates[_baseCurrency]?[_targetCurrency] ?? 1.0;
  }
}