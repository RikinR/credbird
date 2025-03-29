import 'package:flutter/material.dart';

class CardViewModel extends ChangeNotifier {
  bool _isCardActive = true;
  bool _showFront = true;
  String _cardNumber = "4567 8912 3456 7890";
  String _cardHolder = "User Name";
  String _expiryDate = "12/25";
  String _cvv = "123";
  String? _selectedCountry;

  bool get isCardActive => _isCardActive;
  bool get showFront => _showFront;
  String get cardNumber => _cardNumber;
  String get cardHolder => _cardHolder;
  String get expiryDate => _expiryDate;
  String get cvv => _cvv;
  String? get selectedCountry => _selectedCountry;

  void toggleCardActivation() {
    _isCardActive = !_isCardActive;
    notifyListeners();
  }

  void toggleCardSide() { 
    _showFront = !_showFront;
    notifyListeners();
  }

  void updateCardDetails({
    String? cardNumber,
    String? cardHolder,
    String? expiryDate,
    String? cvv,
  }) {
    _cardNumber = cardNumber ?? _cardNumber;
    _cardHolder = cardHolder ?? _cardHolder;
    _expiryDate = expiryDate ?? _expiryDate;
    _cvv = cvv ?? _cvv;
    notifyListeners();
  }

  void selectCountry(String country) {
    _selectedCountry = country;
    generateVirtualCard();
    notifyListeners();
  }

  void generateVirtualCard() {
    if (_selectedCountry != null) {
      _cardNumber = _generateRandomCardNumber();
      _expiryDate = _generateExpiryDate();
      _cvv = _generateRandomCVV();
      _isCardActive = true;
      notifyListeners();
    }
  }

  String _generateRandomCardNumber() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return '${(random % 9000 + 1000).toInt()} ${(random % 9000 + 1000).toInt()} ${(random % 9000 + 1000).toInt()} ${(random % 9000 + 1000).toInt()}';
  }

  String _generateExpiryDate() {
    final now = DateTime.now();
    return '${now.month + 6}/${now.year % 100 + 1}';
  }

  String _generateRandomCVV() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return '${(random % 900 + 100).toInt()}';
  }

  void addToApplePay(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to Apple Pay')),
    );
  }

  void addToGooglePay(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to Google Pay')),
    );
  }
}