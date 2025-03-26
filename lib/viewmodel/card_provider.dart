import 'package:flutter/material.dart';

class CardViewModel extends ChangeNotifier {
  bool _isCardActive = true;
  bool _showFront = true;
  String _cardNumber = "4567 8912 3456 7890";
  String _cardHolder = "User Name";
  String _expiryDate = "12/25";
  String _cvv = "123";

  bool get isCardActive => _isCardActive;
  bool get showFront => _showFront;
  String get cardNumber => _cardNumber;
  String get cardHolder => _cardHolder;
  String get expiryDate => _expiryDate;
  String get cvv => _cvv;

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