import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:trackify/providers/http_request_handler.dart';
import 'package:trackify/providers/preferences.dart';

import '../database.dart';
import '../initial_data.dart';
import '../screens/tracking_form.dart';

import '../widgets/ad_interstitial.dart';
import '../widgets/dialog_and_toast.dart';

import 'classes.dart';
import 'trackings_archived.dart';
import 'trackings_active.dart';

class Status with ChangeNotifier {
  StoredData storedData = StoredData();

  String startError = '';
  String get getStartError => startError;

  void setStartError(String newError) {
    startError = newError;
    notifyListeners();
  }

  AdInterstitial interstitialAd = AdInterstitial();
  AdInterstitial get getInterstitialAd => interstitialAd;

  late List<String> recentSearch;

  Status(StartData startData) {
    recentSearch = [...startData.searchHistory];
  }

  late String? loadedService;
  String? get chosenService => loadedService;
  String exampleCode = "Seleccione un servicio";
  String get chosenServiceCode => exampleCode;

  void loadService(ServiceItemModel service, BuildContext context) {
    loadedService = service.chosen;
    exampleCode = "Ejemplo: ${service.exampleCode}";
    if (service.chosen == "Correo Argentino") {
      ShowDialog(context).serviceCAWarning();
    }
    notifyListeners();
  }

  void clearStartService() {
    loadedService = null;
    exampleCode = "Seleccione un servicio";
  }

  List<String> get searchRecent => [...recentSearch];

  void searchElementHandler(String action, String value) async {
    List<UserPreferences> _storedPreferences =
        await storedData.loadUserPreferences();
    List<String> _searchHistory = _storedPreferences[0].searchHistory;
    if (action == "add") {
      _searchHistory.add(value);
    }
    if (action == "remove") {
      _searchHistory.removeWhere((element) => element == value);
    }
    UserPreferences _newPreferences =
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

  late TextEditingController mainController;
  TextEditingController get primaryController => mainController;

  void loadMainController(String? startText) {
    if (startText == null) {
      mainController = TextEditingController();
    } else {
      mainController = TextEditingController(text: startText);
    }
    notifyListeners();
  }

  void cleanMainController() {
    mainController.clear();
    notifyListeners();
  }

  void removeMainController() {
    mainController.dispose();
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
          tracking.otherData.toString().toLowerCase().contains(searchData) ||
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
  List<dynamic> get googleUserData => [...googleBackups];
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
    String userId = [...await StoredData().loadUserPreferences()][0].userId;
    Object body = {
      'userId': userId,
      'backupId': id,
    };
    dynamic response =
        await HttpRequestHandler.newRequest('/api/google/remove/', body);
    if (response is Map)
      return ShowDialog(context).connectionServerError(false);
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
      Provider.of<Preferences>(context, listen: false)
          .toggleGDErrorStatus(true);
      ShowDialog(context).googleDriveError();
    }
    toggleGoogleProcess(false);
  }
}
