import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import './classes.dart';
import '../database.dart';
import '../initial_data.dart';

import 'http_connection.dart';
import '../widgets/dialog_error.dart';

class UserPreferences with ChangeNotifier {
  StoredData storedData = StoredData();

  late String userId;
  late String userView;
  late bool mercadoLibre;
  late bool premiumUser;

  UserPreferences(StartData startData) {
    userId = startData.userId;
    userView = startData.startView;
    mercadoLibre = startData.mercadoLibre;
    googleDrive = startData.googleDrive;
    premiumUser = startData.premiumStatus;
  }

  void updateDatabase(String type, dynamic value) async {
    UserData storedPreferences = [...await storedData.loadUserData()][0];
    late UserData newPreferences;
    if (type == "view") {
      newPreferences = storedPreferences.edit(view: value);
    }
    if (type == "meLiStatus") {
      newPreferences = storedPreferences.edit(meLiStatus: value);
    }
    if (type == "googleDriveStatus") {
      newPreferences = storedPreferences.edit(googleDriveStatus: value);
    }
    if (type == "premiumStatus") {
      newPreferences = storedPreferences.edit(premiumStatus: value);
    }
    storedData.updatePreferences(newPreferences);
  }

  String get startList => userView;

  void loadNewView(String chosenView) {
    userView = chosenView;
    updateDatabase("view", chosenView);
    notifyListeners();
  }

  String get uId => userId;

  void initializeMeLi(BuildContext context, String code) async {
    Object body = {
      'userId': userId,
      'code': code,
    };
    Response response = await HttpConnection.requestHandler(
        "/api/mercadolibre/initialize/", body);
    if (response.statusCode == 200) {
      toggleMeLiStatus(true);
    } else {
      toggleMeLiStatus(false);
      Map<String, dynamic> responseData =
          HttpConnection.responseHandler(response, context);
      if (responseData['errorDisplayed'] == false)
        DialogError.meLiLoginError(context);
    }
  }

  bool get meLiStatus => mercadoLibre;

  void toggleMeLiStatus(bool newStatus) {
    mercadoLibre = newStatus;
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
      'userId': userId,
      'authCode': authCode,
      'email': email,
    };
    Response response = await HttpConnection.requestHandler(
        "/api/googledrive/initialize/", body);
    if (response.statusCode == 200) {
      toggleGoogleStatus(true);
    } else {
      Map<String, dynamic> responseData =
          HttpConnection.responseHandler(response, context);
      if (responseData['errorDisplayed'] == false)
        DialogError.googleLoginError(context);
    }
  }

  bool googleDrive = false;
  bool get gdStatus => googleDrive;

  void toggleGoogleStatus(bool newStatus) {
    googleDrive = newStatus;
    updateDatabase("googleDriveStatus", newStatus);
    notifyListeners();
  }

  bool backupGoogleDrive = false;
  bool get backupGD => backupGoogleDrive;

  void toggleGDStatus() {
    backupGoogleDrive = !backupGoogleDrive;
    notifyListeners();
  }

  bool errorGDStatus = false;
  bool get errorOperationGD => errorGDStatus;

  void toggleGDErrorStatus(bool newStatus) {
    errorGDStatus = newStatus;
    notifyListeners();
  }

  bool get premiumStatus => premiumUser;

  void togglePremiumStatus(bool newStatus) {
    premiumUser = newStatus;
    updateDatabase("premiumStatus", newStatus);
    notifyListeners();
  }
}
