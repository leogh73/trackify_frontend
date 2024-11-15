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
    String colorToStore = setColor[newStartColor]!;
    updateDatabase("color", colorToStore);
    notifyListeners();
  }

  bool get darkModeStatus => _darkMode;

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    updateDatabase("darkMode", _darkMode);
    notifyListeners();
  }

  static Map<String, MaterialColor> getColor = {
    "teal": Colors.teal,
    "indigo": Colors.indigo,
    "green": Colors.green,
    "pink": Colors.pink,
    "blue": Colors.blue,
    "red": Colors.red,
    "purple": Colors.purple,
    "deepOrange": Colors.deepOrange,
    "deepPurple": Colors.deepPurple,
    "blueGrey": Colors.blueGrey,
    "amber": Colors.amber,
    "lime": Colors.lime,
    "cyan": Colors.cyan,
    "yellow": Colors.yellow,
    "grey": Colors.grey,
    "lightBlue": Colors.lightBlue,
  };

  static Map<MaterialColor, String> setColor = {
    Colors.teal: "teal",
    Colors.indigo: "indigo",
    Colors.green: 'green',
    Colors.pink: 'pink',
    Colors.blue: 'blue',
    Colors.red: 'red',
    Colors.purple: 'purple',
    Colors.deepOrange: 'deepOrange',
    Colors.deepPurple: 'deepPurple',
    Colors.blueGrey: 'blueGrey',
    Colors.amber: 'amber',
    Colors.lime: 'lime',
    Colors.cyan: 'cyan',
    Colors.yellow: 'yellow',
    Colors.grey: 'grey',
    Colors.lightBlue: 'lightBlue',
  };
}
