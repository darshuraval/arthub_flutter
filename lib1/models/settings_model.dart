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

  bool canToggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      // Don't allow unselecting if it would result in less than 2 categories
      return _selectedCategories.length > 2;
    }
    // Allow selecting if less than 8 categories are selected
    return _selectedCategories.length < 8;
  }

  void toggleCategory(String category) {
    if (!canToggleCategory(category)) return;

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