import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:http/http.dart';

import '../database.dart';
import '../initial_data.dart';

import '../data/http_connection.dart';
import '../data/classes.dart';
import '../data/preferences.dart';

import '../widgets/dialog_error.dart';

class Status with ChangeNotifier {
  StoredData storedData = StoredData();

  late String lastSync;

  Status(StartData startData) {
    lastSync = startData.lastSyncDate;
  }

  String get getLastSyncDate => lastSync;

  void setNewSyncDate() async {
    final String newDate = DateTime.now().toString();
    lastSync = newDate;
    final UserData storedPreferences = [...await storedData.loadUserData()][0];
    final UserData newPreferences = storedPreferences.edit(lastSync: newDate);
    storedData.updatePreferences(newPreferences);
  }

  String searchInput = "";
  String get getSearchInput => searchInput;

  List<ItemTracking> searchResults = [];
  List<ItemTracking> get searchResult => searchResults;

  void clearSearchResults() {
    searchInput = '';
    notifyListeners();
  }

  String codeInput = "";
  String get getcodeInput => codeInput;

  void setCodeInput(String value) {
    codeInput = value;
    notifyListeners();
  }

  void search(context, String value, List<ItemTracking> trackingsList) {
    final String searchValue = value.toLowerCase();
    searchResult.clear();
    searchResults = trackingsList
        .where((tracking) =>
            tracking.service.toLowerCase().contains(searchValue) ||
            tracking.title!.toLowerCase().contains(searchValue) ||
            tracking.moreData.toString().toLowerCase().contains(searchValue) ||
            tracking.events.toString().toLowerCase().contains(searchValue) &&
                !tracking.checkError!)
        .toList();
    searchInput = value;
    notifyListeners();
  }

  bool checking = false;
  bool get checkingStatus => checking;

  void toggleCheckingStatus() {
    checking = !checking;
    notifyListeners();
  }

  bool listEnd = false;
  bool get endOfList => listEnd;

  void restartListEnd() {
    listEnd = false;
    notifyListeners();
  }

  void toggleListEndStatus(bool newStatus) {
    listEnd = newStatus;
    notifyListeners();
  }

  bool eventsEnd = false;
  bool get endOfEvents => eventsEnd;

  void resetEndOfEventsStatus() {
    eventsEnd = false;
    notifyListeners();
  }

  void toggleEventsEndStatus(bool newStatus) {
    eventsEnd = newStatus;
    notifyListeners();
  }

  bool loadMoreML = false;
  bool get loadMoreMLStatus => loadMoreML;

  void showNotificationOverlay(String title, String body) {
    showOverlayNotification((context) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: SafeArea(
            child: ListTile(
          leading: SizedBox.fromSize(
              size: const Size(40, 40),
              child: Image.asset("assets/icon/icon.png")),
          title: Text(title),
          subtitle: Text(body),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              OverlaySupportEntry.of(context)?.dismiss();
            },
          ),
        )),
      );
    }, duration: const Duration(milliseconds: 0));
  }

  String userEmail = '';
  String get googleEmail => userEmail;
  void setGoogleEmail(String email) {
    userEmail = email;
    notifyListeners();
  }

  List<dynamic> googleBackups = [];
  List<dynamic> get googleUserData => [];
  void loadGoogleBackups(List<dynamic> data, bool login) {
    googleBackups = data;
    if (login) {
      if (googleBackups.length == 1) {
        googleBackups.insert(1, {'date': null, 'currentDevice': false});
      }
      if (googleBackups[0]['date'] == null &&
          googleBackups[1]['date'] == null) {
        googleBackups.clear();
      }
    }
    notifyListeners();
  }

  String selectedBackupId = '';
  String get selectedBackup => selectedBackupId;
  void cleanSelectedBackup() {
    selectedBackupId = '';
  }

  void selectBackup(String id) {
    for (var backup in googleBackups) {
      backup['selected'] = false;
    }
    int index = googleBackups.indexWhere((backup) => backup['id'] == id);
    if (selectedBackupId == id) {
      selectedBackupId = "";
    } else {
      selectedBackupId = googleBackups[index]['id'];
      googleBackups[index]['selected'] = true;
    }
    loadGoogleBackups(googleBackups, false);
  }

  bool onGoogleProcess = false;
  bool get onProcessStatus => onGoogleProcess;
  toggleGoogleProcess(bool newStatus) {
    onGoogleProcess = newStatus;
    notifyListeners();
  }

  void deleteBackup(BuildContext context, String id) async {
    toggleGoogleProcess(true);
    String userId = Provider.of<UserPreferences>(context, listen: false).userId;
    Object body = {
      'userId': userId,
      'backupId': id,
    };
    Response response =
        await HttpConnection.requestHandler('/api/googledrive/remove/', body);
    if (response.statusCode == 200) {
      int index = googleBackups.indexWhere((backup) => backup['id'] == id);
      googleBackups.removeAt(index);
      if (index == 0) {
        googleBackups.insert(0, {'date': null, 'currentDevice': true});
      } else if (googleBackups.length == 1) {
        googleBackups.insert(1, {'date': null, 'currentDevice': false});
      }
      if (googleBackups[0]['date'] == null &&
          googleBackups[1]['date'] == null) {
        googleBackups.clear();
      }
      loadGoogleBackups(googleBackups, false);
    } else {
      if (!context.mounted) {
        return;
      }
      Provider.of<UserPreferences>(context, listen: false)
          .toggleGDErrorStatus(true);
      Map<String, dynamic> responseData =
          HttpConnection.responseHandler(response, context);
      if (responseData['serverError'] == null) {
        DialogError.show(context, 12, "");
      }
    }
    toggleGoogleProcess(false);
  }
}
