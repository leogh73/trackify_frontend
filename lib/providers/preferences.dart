import 'package:flutter/material.dart';
import 'package:http/http.dart';

import './classes.dart';
import '../database.dart';
import '../initial_data.dart';

import '../providers/http_request_handler.dart';
import '../widgets/dialog_error.dart';

class UserPreferences with ChangeNotifier {
  StoredData storedData = StoredData();

  late String _userView;
  late bool _mercadoLibre;
  late String _userId;
  late bool _premiumUser;

  UserPreferences(StartData startData) {
    _userView = startData.startView;
    _mercadoLibre = startData.mercadoLibre;
    _googleDrive = startData.googleDrive;
    _userId = startData.userId;
    _premiumUser = startData.premiumStatus;
  }

  void updateDatabase(String type, dynamic value) async {
    UserData _storedPreferences = [...await storedData.loadUserData()][0];
    late UserData _newPreferences;
    if (type == "view") {
      _newPreferences = _storedPreferences.edit(view: value);
    }
    if (type == "meLiStatus") {
      _newPreferences = _storedPreferences.edit(meLiStatus: value);
    }
    if (type == "googleDriveStatus") {
      _newPreferences = _storedPreferences.edit(googleDriveStatus: value);
    }
    if (type == "premiumStatus") {
      _newPreferences = _storedPreferences.edit(premiumStatus: value);
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
    Response response = await HttpRequestHandler.newRequest(
        "/api/mercadolibre/initialize/", body);
    if (response.statusCode == 200) {
      toggleMeLiStatus(true);
    } else {
      toggleMeLiStatus(false);
      if (response.body == "Server timeout") {
        return DialogError.serverTimeout(context);
      }
      if (response.body.startsWith("error")) {
        return DialogError.serverError(context);
      }
      DialogError.meLiLoginError(context);
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
    Response response =
        await HttpRequestHandler.newRequest("/api/google/initialize/", body);
    if (response.statusCode == 200) {
      toggleGoogleStatus(true);
    } else {
      if (response.body == "Server timeout") {
        return DialogError.serverTimeout(context);
      }
      if (response.body.startsWith("error")) {
        return DialogError.serverError(context);
      }
      DialogError.googleLoginError(context);
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

  bool get premiumStatus => _premiumUser;

  void togglePremiumStatus(bool newStatus) {
    _premiumUser = newStatus;
    updateDatabase("premiumStatus", newStatus);
    notifyListeners();
  }
}
