
import 'package:flutter/material.dart';
class SingleNotifier extends ChangeNotifier {
  String _currentCountry = 'USA';
  SingleNotifier();
  String get currentCountry => _currentCountry;
  updateCountry(String value) {
    if (value != _currentCountry) {
      _currentCountry = value;
      notifyListeners();
    }
  }
}