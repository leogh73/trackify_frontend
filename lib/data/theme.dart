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
    UserData storedPreferences = [...await storedData.loadUserData()][0];
    late UserData newPreferences;
    if (type == "color") {
      newPreferences = storedPreferences.edit(color: value);
    }
    if (type == "darkMode") {
      newPreferences = storedPreferences.edit(darkMode: value);
    }
    storedData.updatePreferences(newPreferences);
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
    "pink": Colors.pink,
    "blue": Colors.blue,
    "purple": Colors.purple,
    "blueGrey": Colors.blueGrey,
    "deepPurple": Colors.deepOrange,
    "green": Colors.green,
    "brown": Colors.brown,
    "amber": Colors.amber,
    "cyan": Colors.cyan,
    "orange": Colors.orange,
    "grey": Colors.grey,
    "deepOrange": Colors.deepPurple,
    "red": Colors.red,
    "lightBlue": Colors.lightBlue,
  };

  static Map<MaterialColor, String> setColor = {
    Colors.teal: "teal",
    Colors.indigo: "indigo",
    Colors.pink: 'pink',
    Colors.blue: 'blue',
    Colors.purple: 'purple',
    Colors.blueGrey: 'blueGrey',
    Colors.deepOrange: 'deepOrange',
    Colors.green: 'green',
    Colors.brown: 'brown',
    Colors.amber: 'amber',
    Colors.cyan: 'cyan',
    Colors.orange: 'orange',
    Colors.grey: 'grey',
    Colors.deepPurple: 'deepPurple',
    Colors.red: 'red',
    Colors.lightBlue: 'lightBlue',
  };
}
