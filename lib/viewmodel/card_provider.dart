import 'package:flutter/material.dart';

class CardViewModel extends ChangeNotifier {
  bool isFlipped = false;
  bool isCardActive = true;

  void toggleCardFlip() {
    isFlipped = !isFlipped;
    notifyListeners();
  }

  void toggleCardActivation() {
    isCardActive = !isCardActive;
    notifyListeners();
  }
}
