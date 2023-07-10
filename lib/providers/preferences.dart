import 'package:flutter/material.dart';
import 'package:trackify/providers/http_request_handler.dart';

import './classes.dart';
import '../database.dart';
import '../initial_data.dart';

import '../widgets/dialog_and_toast.dart';

class Preferences with ChangeNotifier {
  StoredData storedData = StoredData();

  late String _userView;
  late bool _mercadoLibre;
  late String _userId;

  Preferences(StartData startData) {
    _userView = startData.startView;
    _mercadoLibre = startData.mercadoLibre;
    _googleDrive = startData.googleDrive;
    _userId = startData.userId;
  }

  void updateDatabase(String type, dynamic value) async {
    UserPreferences _storedPreferences =
        [...await storedData.loadUserPreferences()][0];
    late UserPreferences _newPreferences;
    if (type == "view") {
      _newPreferences = _storedPreferences.edit(view: value);
    }
    if (type == "meLiStatus") {
      _newPreferences = _storedPreferences.edit(meLiStatus: value);
    }
    if (type == "googleDriveStatus") {
      _newPreferences = _storedPreferences.edit(googleDriveStatus: value);
    }
    storedData.updatePreferences(_newPreferences);
  }

  String get startList => _userView;

  void loadNewView(String chosenView) {
    _userView = chosenView;
    updateDatabase("view", chosenView);
    notifyListeners();
  }

  String get userId => _userId;

  void initializeMeLi(BuildContext context, String code) async {
    Object body = {
      'userId': _userId,
      'code': code,
    };
    dynamic response = await HttpRequestHandler.newRequest(
        "/api/mercadolibre/initialize/", body);
    if (response is Map)
      return ShowDialog(context).connectionServerError(false);
    if (response.statusCode == 200) {
      toggleMeLiStatus(true);
    } else {
      toggleMeLiStatus(false);
      ShowDialog(context).meLiLoginError();
    }
  }

  bool get meLiStatus => _mercadoLibre;

  void toggleMeLiStatus(bool newStatus) {
    _mercadoLibre = newStatus;
    updateDatabase("meLiStatus", newStatus);
    notifyListeners();
  }

  bool errorMeLiCheck = false;
  bool get errorCheckMeLi => errorMeLiCheck;

  void toggleMeLiErrorStatus(bool newStatus) {
    errorMeLiCheck = newStatus;
    notifyListeners();
  }

  void initializeGoogle(
      BuildContext context, String authCode, String email) async {
    Object body = {
      'userId': _userId,
      'authCode': authCode,
      'email': email,
    };
    dynamic response =
        await HttpRequestHandler.newRequest("/api/google/initialize/", body);
    if (response is Map)
      return ShowDialog(context).connectionServerError(false);
    if (response.statusCode == 200) {
      toggleGoogleStatus(true);
    } else {
      ShowDialog(context).googleLoginError();
    }
  }

  bool _googleDrive = false;
  bool get gdStatus => _googleDrive;

  void toggleGoogleStatus(bool newStatus) {
    _googleDrive = newStatus;
    updateDatabase("googleDriveStatus", newStatus);
    notifyListeners();
  }

  bool _backupGoogleDrive = false;
  bool get backupGD => _backupGoogleDrive;

  void toggleGDStatus() {
    _backupGoogleDrive = !_backupGoogleDrive;
    notifyListeners();
  }

  bool errorGDStatus = false;
  bool get errorOperationGD => errorGDStatus;

  void toggleGDErrorStatus(bool newStatus) {
    errorGDStatus = newStatus;
    notifyListeners();
  }
}
