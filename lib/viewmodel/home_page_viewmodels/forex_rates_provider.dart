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
    'AED',
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

  double getExchangeRateFor(String currency) {
    final rates = {
      'INR': {
        'USD': 0.012,
        'EUR': 0.011,
        'GBP': 0.0096,
        'JPY': 1.78,
        'AUD': 0.018,
        'CAD': 0.016,
        'SGD': 0.016,
        'AED': 0.044,
      },
      'USD': {
        'INR': 83.12,
        'EUR': 0.92,
        'GBP': 0.79,
        'JPY': 148.32,
        'AUD': 1.52,
        'CAD': 1.36,
        'SGD': 1.34,
        'AED': 3.67,
      },
      'EUR': {
        'INR': 89.50,
        'USD': 1.09,
        'GBP': 0.86,
        'JPY': 161.23,
        'AUD': 1.65,
        'CAD': 1.47,
        'SGD': 1.45,
        'AED': 4.02,
      },
      'GBP': {
        'INR': 104.20,
        'USD': 1.27,
        'EUR': 1.16,
        'JPY': 187.65,
        'AUD': 1.92,
        'CAD': 1.71,
        'SGD': 1.69,
        'AED': 4.68,
      },
    };

    return rates[_baseCurrency]?[currency] ?? 1.0;
  }
}
