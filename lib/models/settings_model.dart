import 'package:flutter/material.dart';

class SettingsModel extends ChangeNotifier {
  final Set<String> _selectedProductIds = <String>{};

  Set<String> get selectedProductIds => _selectedProductIds;

  void toggleProduct(String productId) {
    if (_selectedProductIds.contains(productId)) {
      _selectedProductIds.remove(productId);
    } else {
      _selectedProductIds.add(productId);
    }
    notifyListeners();
  }

  bool isProductSelected(String productId) {
    return _selectedProductIds.contains(productId);
  }
} 