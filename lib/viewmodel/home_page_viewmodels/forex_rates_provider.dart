import 'package:credbird/model/user_models/forex_rate_model.dart';
import 'package:credbird/repositories/user_repository/forex_rate_repository.dart';
import 'package:flutter/material.dart';

class ForexRatesViewModel extends ChangeNotifier {
  String _baseCurrency = 'INR';
  String _targetCurrency = 'USD';
  List<ForexRate> _forexRates = [];
  bool _isLoading = false;
  String? _error;

  String get baseCurrency => _baseCurrency;
  String get targetCurrency => _targetCurrency;
  List<ForexRate> get forexRates => _forexRates;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<String> get currencies {
    final codes = _forexRates.map((rate) => rate.currencyCode).toList();
    codes.add('INR'); 
    return codes.toSet().toList()..sort();
  }

  final ForexRateRepository _repository = ForexRateRepository();

  Future<void> fetchForexRates() async {
    try {
      _isLoading = true;
      notifyListeners();

      _forexRates = await _repository.getLiveRates();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setBaseCurrency(String currency) {
    _baseCurrency = currency;
    notifyListeners();
  }

  void setTargetCurrency(String currency) {
    _targetCurrency = currency;
    notifyListeners();
  }

  double getExchangeRate() {
    if (_baseCurrency == 'INR') {
      final rate = _forexRates.firstWhere(
        (rate) => rate.currencyCode == _targetCurrency,
        orElse:
            () =>
                ForexRate(currencyCode: _targetCurrency, inrBuy: 0, inrSell: 0),
      );
      return 1 / rate.inrBuy;
    } else if (_targetCurrency == 'INR') {
      final rate = _forexRates.firstWhere(
        (rate) => rate.currencyCode == _baseCurrency,
        orElse:
            () => ForexRate(currencyCode: _baseCurrency, inrBuy: 0, inrSell: 0),
      );
      return rate.inrBuy;
    } else {
      final baseToInr =
          _forexRates
              .firstWhere(
                (rate) => rate.currencyCode == _baseCurrency,
                orElse:
                    () => ForexRate(
                      currencyCode: _baseCurrency,
                      inrBuy: 0,
                      inrSell: 0,
                    ),
              )
              .inrBuy;

      final targetToInr =
          _forexRates
              .firstWhere(
                (rate) => rate.currencyCode == _targetCurrency,
                orElse:
                    () => ForexRate(
                      currencyCode: _targetCurrency,
                      inrBuy: 0,
                      inrSell: 0,
                    ),
              )
              .inrBuy;

      return baseToInr / targetToInr;
    }
  }

  double getExchangeRateFor(String currency) {
    if (_baseCurrency == 'INR') {
      final rate = _forexRates.firstWhere(
        (rate) => rate.currencyCode == currency,
        orElse: () => ForexRate(currencyCode: currency, inrBuy: 0, inrSell: 0),
      );
      return 1 / rate.inrBuy;
    } else {
      final baseToInr =
          _forexRates
              .firstWhere(
                (rate) => rate.currencyCode == _baseCurrency,
                orElse:
                    () => ForexRate(
                      currencyCode: _baseCurrency,
                      inrBuy: 0,
                      inrSell: 0,
                    ),
              )
              .inrBuy;

      if (currency == 'INR') {
        return baseToInr;
      } else {
        final targetToInr =
            _forexRates
                .firstWhere(
                  (rate) => rate.currencyCode == currency,
                  orElse:
                      () => ForexRate(
                        currencyCode: currency,
                        inrBuy: 0,
                        inrSell: 0,
                      ),
                )
                .inrBuy;
        return baseToInr / targetToInr;
      }
    }
  }
}
