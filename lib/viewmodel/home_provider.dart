import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  double balance = 0.00;
  String userName = "User";
  bool isBalanceVisible = true;

  void toggleBalanceVisibility() {
    isBalanceVisible = !isBalanceVisible;
    notifyListeners();
  }
}
