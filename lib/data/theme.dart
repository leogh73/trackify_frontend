import 'package:flutter/material.dart';

import './classes.dart';
import '../database.dart';
import '../initial_data.dart';

class UserTheme with ChangeNotifier {
  StoredData storedData = StoredData();

  late MaterialColor _startColor;
  late bool _darkMode;

  UserTheme(StartData startData) {
    _startColor = startData.startColor;
    _darkMode = startData.darkMode;
  }

  MaterialColor get startColor => _startColor;

  void updateDatabase(String type, dynamic value) async {
    UserData _storedPreferences = [...await storedData.loadUserData()][0];
    late UserData _newPreferences;
    if (type == "color") {
      _newPreferences = _storedPreferences.edit(color: value);
    }
    if (type == "darkMode") {
      _newPreferences = _storedPreferences.edit(darkMode: value);
    }
    storedData.updatePreferences(_newPreferences);
  }

  void loadNewColor(MaterialColor newStartColor) {
    _startColor = newStartColor;
    String colorToStore = ColorItem.store(newStartColor);
    updateDatabase("color", colorToStore);
    notifyListeners();
  }

  bool get darkModeStatus => _darkMode;

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    updateDatabase("darkMode", _darkMode);
    notifyListeners();
  }
}
