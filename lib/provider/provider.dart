
import 'package:flutter/material.dart';

class RewardsPrvoider extends ChangeNotifier{
  bool _isFilped = false;
  bool _isFilpedCoin = false;
  int ratingCount = 0;
  bool get isFilped => _isFilped;
  bool get isFilpedCoin => _isFilpedCoin;


  void setFlippedCard(bool value) {
    _isFilped = value;
    notifyListeners();
  }
  void setFlippedCoin(bool value) {
    _isFilpedCoin = value;
    notifyListeners();
  }

}

