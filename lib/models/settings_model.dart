import 'package:flutter/material.dart';

class SettingsModel extends ChangeNotifier {
  final Set<String> _selectedCategories = {
    'Culture',
    'Mughal',
    'Still Life',
    'Wildlife',
    'Persian',
    'Landscape',
    'Folk',
    'Hindu',
  };

  Set<String> get selectedCategories => _selectedCategories;

  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  bool isCategorySelected(String category) {
    return _selectedCategories.contains(category);
  }

  void resetToDefault() {
    _selectedCategories.clear();
    _selectedCategories.addAll([
      'Culture',
      'Mughal',
      'Still Life',
      'Wildlife',
      'Persian',
      'Landscape',
      'Folk',
      'Hindu',
    ]);
    notifyListeners();
  }
} 