import 'package:credbird/repositories/remitence_repository/payment_repository.dart';
import 'package:flutter/material.dart';

class PaymentViewModel extends ChangeNotifier {
  final _repo = PaymentRepository();
  bool isLoading = false;
  bool linkSent = false;

  Future<void> startPayment(String transactionId) async {
    try {
      isLoading = true;
      notifyListeners();

      await _repo.initiatePayment(transactionId: transactionId);
      linkSent = true;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
