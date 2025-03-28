import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:trackify/widgets/dialog_error.dart';
import 'package:http/http.dart';

import 'services.dart';
import 'http_connection.dart';

import 'preferences.dart';
import '../database.dart';
import '../initial_data.dart';

import 'classes.dart';
import 'trackings_archived.dart';
import 'trackings_active.dart';

class Status with ChangeNotifier {
  StoredData storedData = StoredData();

  late List<String> recentSearch;

  Status(StartData startData) {
    recentSearch = [...startData.searchHistory];
  }

  String? loadedService;
  String? get chosenService => loadedService;
  String messageService = '';
  String get serviceMessage => messageService;
  String exampleCode = "Seleccione un servicio";
  String get chosenServiceCode => exampleCode;

  void loadService(ServiceItemModel service, BuildContext context) {
    loadedService = service.chosen;
    messageService = Provider.of<Services>(context, listen: false)
            .servicesData[service.chosen]["selectionMessage"] ??
        '';
    exampleCode = "Ejemplo: ${service.exampleCode}";
    notifyListeners();
  }

  void clearStartService() {
    loadedService = null;
    messageService = '';
    exampleCode = "Seleccione un servicio";
  }

  List<String> get searchRecent => [...recentSearch];

  void searchElementHandler(String action, String value) async {
    List<UserData> _storedPreferences = await storedData.loadUserData();
    List<String> _searchHistory = _storedPreferences[0].searchHistory;
    if (action == "add") {
      _searchHistory.add(value);
    }
    if (action == "remove") {
      _searchHistory.removeWhere((element) => element == value);
    }
    UserData _newPreferences =
        _storedPreferences[0].edit(searchHistory: _searchHistory);
    storedData.updatePreferences(_newPreferences);
  }

  void addSearch(String search) async {
    recentSearch.insert(0, search);
    searchElementHandler("add", search);
    notifyListeners();
  }

  void removeSearch(String search) async {
    recentSearch.removeWhere((element) => element == search);
    searchElementHandler("remove", search);
    notifyListeners();
  }

  bool recentList = false;
  bool get resultList => recentList;

  void toggleResultList(bool newStatus) {
    recentList = newStatus;
    notifyListeners();
  }

  List<ItemTracking> searchResults = [];
  List<ItemTracking> get searchResult => [...searchResults];

  void addSearchElement(ItemTracking tracking) {
    ItemTracking newTracking =
        tracking.edit(id: DateTime.now().microsecond, search: true);
    searchResults.insert(0, newTracking);
  }

  void search(context, String searchInput) {
    searchResults.clear();

    itemCheck(ItemTracking tracking) {
      String searchData = searchInput.toLowerCase();
      if (tracking.service.toLowerCase().contains(searchData) ||
          tracking.title!.toLowerCase().contains(searchData) ||
          tracking.moreData.toString().toLowerCase().contains(searchData) ||
          tracking.events.toString().toLowerCase().contains(searchData) &&
              !tracking.checkError!) return true;
    }

    Provider.of<ActiveTrackings>(context, listen: false)
        .trackings
        .forEach((element) {
      if (itemCheck(element) == true) {
        addSearchElement(element);
      }
    });
    Provider.of<ArchivedTrackings>(context, listen: false)
        .trackings
        .forEach((element) {
      if (itemCheck(element) == true) {
        addSearchElement(element);
      }
    });
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
      Provider.of<UserPreferences>(context, listen: false)
          .toggleGDErrorStatus(true);
      Map<String, dynamic> responseData =
          HttpConnection.responseHandler(response, context);
      if (responseData['serverError'] == null)
        DialogError.show(context, 12, "");
    }
    toggleGoogleProcess(false);
  }
}
