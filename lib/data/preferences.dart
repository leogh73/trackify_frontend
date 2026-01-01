import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../database.dart';
import '../initial_data.dart';

import '../data/classes.dart';
import '../data/http_connection.dart';
import '../data/tracking_functions.dart';
import '../data/trackings_active.dart';
import '../data/trackings_archived.dart';

import './languages.dart';

import '../widgets/dialog_error.dart';
import '../widgets/dialog_toast.dart';

class UserPreferences with ChangeNotifier {
  StoredData storedData = StoredData();

  late String userId;
  late String language;
  late String userView;
  late int sortTrackingsNumber;
  late bool mercadoLibre;
  late bool googleDrive;
  late bool showAgainPaymentError;
  late Map<String, dynamic> paymentData;

  UserPreferences(StartData startData) {
    userId = startData.userId;
    language = startData.language;
    userView = startData.startView;
    sortTrackingsNumber = startData.sortTrackingsBy;
    mercadoLibre = startData.mercadoLibre;
    googleDrive = startData.googleDrive;
    showAgainPaymentError = startData.showAgainPaymentError;
    paymentData = startData.paymentData;
  }

  Map<int, dynamic> get selectedLanguage => Languages.select[language]!;

  void changeLanguage(String newLanguage) {
    language = newLanguage;
    updateDatabase("language", newLanguage);
    notifyListeners();
  }

  updateDatabase(String type, dynamic value) async {
    UserData storedPreferences = [...await storedData.loadUserData()][0];
    late UserData newPreferences;
    if (type == "view") {
      newPreferences = storedPreferences.edit(view: value);
    }
    if (type == "language") {
      newPreferences = storedPreferences.edit(language: value);
    }
    if (type == "sortTrackings") {
      newPreferences = storedPreferences.edit(sortTrackingsBy: value);
    }
    if (type == "meLiStatus") {
      newPreferences = storedPreferences.edit(meLiStatus: value);
    }
    if (type == "googleDriveStatus") {
      newPreferences = storedPreferences.edit(googleDriveStatus: value);
    }
    if (type == "showAgainPaymentError") {
      newPreferences = storedPreferences.edit(showAgainPaymentError: value);
    }
    storedData.updatePreferences(newPreferences);
  }

  String get startList => userView;

  void loadNewView(String chosenView) {
    userView = chosenView;
    updateDatabase("view", chosenView);
    notifyListeners();
  }

  int get sortTrackingsOption => sortTrackingsNumber;

  List<ItemTracking> sortTrackings(
      String chosenSort, List<ItemTracking> trackingsList) {
    if (trackingsList.isEmpty) {
      return [];
    }

    if (chosenSort == selectedLanguage[207]) {
      trackingsList.sort((t1, t2) => t1.service.compareTo(t2.service));
      return trackingsList;
    }

    if (chosenSort == selectedLanguage[272]) {
      trackingsList.sort((t1, t2) => t1.status!.compareTo(t2.status!));
      return trackingsList;
    }

    trackingsList.sort((t1, t2) {
      List<int> date1Splitted = [];
      List<int> time1Splitted = [];
      List<int> date2Splitted = [];
      List<int> time2Splitted = [];

      if (chosenSort == selectedLanguage[206]) {
        date1Splitted = TrackingFunctions.parseDate(t1.events[0]["date"]!);
        time1Splitted = TrackingFunctions.parseTime(t1.events[0]["time"]!);
        date2Splitted = TrackingFunctions.parseDate(t2.events[0]["date"]!);
        time2Splitted = TrackingFunctions.parseTime(t2.events[0]["time"]!);
      }
      if (chosenSort == selectedLanguage[205]) {
        date1Splitted =
            TrackingFunctions.parseDate(t1.startCheck!.split(" - ")[0]);
        time1Splitted =
            TrackingFunctions.parseTime(t1.startCheck!.split(" - ")[1]);
        date2Splitted =
            TrackingFunctions.parseDate(t2.startCheck!.split(" - ")[0]);
        time2Splitted =
            TrackingFunctions.parseTime(t2.startCheck!.split(" - ")[1]);
      }
      DateTime date1 = DateTime(
        date1Splitted[2],
        date1Splitted[1],
        date1Splitted[0],
        time1Splitted[0],
        time1Splitted[1],
        time1Splitted.length == 3 ? time1Splitted[2] : 00,
      );
      DateTime date2 = DateTime(
        date2Splitted[2],
        date2Splitted[1],
        date2Splitted[0],
        time2Splitted[0],
        time2Splitted[1],
        time2Splitted.length == 3 ? time2Splitted[2] : 00,
      );
      return date2.compareTo(date1);
    });
    return trackingsList;
  }

  void sortTrackingsList(
      String chosenSort, BuildContext context, bool areActive) {
    int chosenValue = 0;
    if (chosenSort == selectedLanguage[205]) {
      chosenValue = 205;
    }
    if (chosenSort == selectedLanguage[206]) {
      chosenValue = 206;
    }
    if (chosenSort == selectedLanguage[207]) {
      chosenValue = 207;
    }
    if (chosenSort == selectedLanguage[272]) {
      chosenValue = 272;
    }

    if (areActive) {
      List<ItemTracking> activeTrackings =
          Provider.of<ActiveTrackings>(context, listen: false).trackings;
      List<ItemTracking> newActiveTrackings =
          sortTrackings(chosenSort, activeTrackings);
      Provider.of<ActiveTrackings>(context, listen: false)
          .sortedTrackings(newActiveTrackings);
    } else {
      List<ItemTracking> archivedTrackings =
          Provider.of<ArchivedTrackings>(context, listen: false).trackings;
      List<ItemTracking> newArchivedTrackings =
          sortTrackings(chosenSort, archivedTrackings);
      Provider.of<ArchivedTrackings>(context, listen: false)
          .sortedTrackings(newArchivedTrackings);
    }

    updateDatabase("sortTrackings", chosenValue);
    sortTrackingsNumber = chosenValue;

    notifyListeners();
  }

  void reverseTrackingsList(BuildContext context, bool areActive) {
    if (areActive) {
      List<ItemTracking> activeTrackings =
          Provider.of<ActiveTrackings>(context, listen: false)
              .trackings
              .reversed
              .toList();
      Provider.of<ActiveTrackings>(context, listen: false)
          .sortedTrackings(activeTrackings);
    } else {
      List<ItemTracking> archivedTrackings =
          Provider.of<ArchivedTrackings>(context, listen: false)
              .trackings
              .reversed
              .toList();
      Provider.of<ArchivedTrackings>(context, listen: false)
          .sortedTrackings(archivedTrackings);
    }
    notifyListeners();
  }

  List<String> sortOptionsList(selectedLanguage) {
    List<String> menuOptions = [
      selectedLanguage[205]!,
      selectedLanguage[206]!,
      selectedLanguage[207]!,
      selectedLanguage[272]!
    ];
    return menuOptions;
  }

  void checkPayment(BuildContext context, Map<String, dynamic> paymentData,
      Map<int, dynamic> texts) {
    final bool showPaymentErrorAgain =
        Provider.of<UserPreferences>(context, listen: false)
            .showAgainPaymentError;
    if (paymentData["status"] == "could not be checked") {
      if (showPaymentErrorAgain) {
        ShowDialog.showMessage(context, texts[231]!, "payment", texts);
      }
    } else {
      setShowPaymentErrorAgain(true);
    }
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
      if (!context.mounted) {
        return;
      }
      Map<String, dynamic> responseData =
          HttpConnection.responseHandler(response, context);
      if (responseData['serverError'] == null) {
        DialogError.show(context, 10, "");
      }
    }
    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pop();
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
      if (!context.mounted) {
        return;
      }
      Map<String, dynamic> responseData =
          HttpConnection.responseHandler(response, context);
      if (responseData['serverError'] == null) {
        DialogError.show(context, 11, "");
      }
    }
  }

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

  Map<String, dynamic> get getPaymentData => paymentData;

  void setPaymentData(Map<String, dynamic> payData) {
    paymentData = payData;
    notifyListeners();
  }

  bool get premiumStatus => paymentData['isValid'];
  bool get showPaymentErrorAgain => showAgainPaymentError;

  void setShowPaymentErrorAgain(bool newStatus) {
    showAgainPaymentError = newStatus;
    updateDatabase("showAgainPaymentError", newStatus);
    notifyListeners();
  }
}
