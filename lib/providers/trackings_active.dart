import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/standalone.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:trackify/providers/preferences.dart';

import '../database.dart';
import '../initial_data.dart';

import '../screens/tracking_detail.dart';

import '../widgets/dialog_and_toast.dart';
import '../widgets/data_response.dart';

import 'classes.dart';
import 'status.dart';

class ActiveTrackings extends ChangeNotifier {
  StoredData storedData = StoredData();
  late List<ItemTracking> _trackings;

  ActiveTrackings(StartData startData) {
    _trackings = [...startData.activeTrackings];
  }

  List<ItemTracking> get trackings => [..._trackings];

  void addTracking(Tracking tracking) async {
    if (tracking.title.isEmpty) {
      tracking.title = tracking.code;
    }

    ItemTracking newTracking = ItemTracking(
      idSB: tracking.id,
      idMDB: null,
      title: tracking.title,
      code: tracking.code,
      service: tracking.service,
      search: false,
      checkError: null,
      selected: false,
      archived: false,
    );
    _trackings.insert(0, newTracking);

    notifyListeners();
  }

  void loadStartData(ItemTracking tracking, ItemResponseData itemData) {
    int trackingIndex =
        _trackings.indexWhere((element) => element.idSB == tracking.idSB);
    _trackings[trackingIndex].events = itemData.events!;
    _trackings[trackingIndex].otherData =
        itemData.otherData?.cast<List<String>>();
    _trackings[trackingIndex].lastEvent = itemData.lastEvent;
    String dateAndTime = '${itemData.checkDate} - ${itemData.checkTime}';
    _trackings[trackingIndex].startCheck = dateAndTime;
    _trackings[trackingIndex].lastCheck = dateAndTime;
    _trackings[trackingIndex].checkError = false;
    _trackings[trackingIndex].idMDB = itemData.trackingId!;
    storedData.newMainTracking(_trackings[trackingIndex]);
  }

  void retryErrorTracking(int trackingId) {
    int trackingIndex = _trackings.indexWhere((t) => t.idSB == trackingId);
    _trackings[trackingIndex].checkError = null;
    notifyListeners();
  }

  void removeTracking(
      List<ItemTracking> trackingList, BuildContext context) async {
    List<String> trackingIds = [];
    for (var tracking in trackingList) {
      _trackings.remove(tracking);
      if (!tracking.checkError!) {
        storedData.removeMainTracking(tracking);
        trackingIds.add(tracking.idMDB!);
      }
    }
    String _userId = Provider.of<Preferences>(context, listen: false).userId;
    notifyListeners();
    String url = '${dotenv.env['API_URL']}/api/user/$_userId/remove/';
    await http.Client()
        .post(Uri.parse(url), body: {'trackingIds': json.encode(trackingIds)});
  }

  void editTracking(ItemTracking tracking) {
    int index = _trackings.indexWhere((seg) => seg.idSB == tracking.idSB);
    _trackings[index].code = tracking.code;
    _trackings[index].service = tracking.service;
    _trackings[index].title = tracking.title;
    if (tracking.title == null) {
      _trackings[index].title = _trackings[index].code;
    }
    storedData.updateMainTracking(_trackings[index]);
    notifyListeners();
  }

  late ItemTracking _loadedTracking;
  ItemTracking get loadedTracking => _loadedTracking;

  void loadCurrentTracking(ItemTracking tracking) {
    _loadedTracking = tracking;
    notifyListeners();
  }

  bool selectionMode = false;
  bool get selectionModeStatus => selectionMode;

  void toggleSelectionMode() {
    selectionMode = !selectionMode;
    if (selectionMode == false) {
      for (var element in _trackings) {
        element.selected = false;
      }
      _selection.clear();
    }
    notifyListeners();
  }

  List<ItemTracking> _selection = [];
  List<ItemTracking> get selectionElements => [..._selection];

  late int startSelection;
  int get activatedSelection => startSelection;

  void activateStartSelection(ItemTracking tracking) {
    startSelection = tracking.idSB!;
    addSelected(tracking);
  }

  void addSelected(ItemTracking tracking) {
    _selection.add(tracking);
    notifyListeners();
  }

  void removeSelected(int idEliminar) {
    _selection.removeWhere((tracking) => tracking.idSB == idEliminar);
    notifyListeners();
  }

  void selectAll() {
    if (_selection.length < _trackings.length) {
      _selection.clear();
      for (var tracking in _trackings) {
        tracking.selected = true;
      }
      _selection = [..._trackings];
    } else {
      for (var tracking in _trackings) {
        tracking.selected = false;
      }
      _selection.clear();
    }
    notifyListeners();
  }

  void removeSelection(BuildContext context) {
    removeTracking(_selection, context);
    _selection.clear();
    notifyListeners();
  }

  void searchUpdates(BuildContext context, ItemTracking tracking) async {
    Provider.of<Status>(context, listen: false).toggleCheckingStatus();
    String _userId = Provider.of<Preferences>(context, listen: false).userId;
    String url = '${dotenv.env['API_URL']}/api/user/check/';
    var consult = await http.Client().post(
      Uri.parse(url),
      body: {'userId': _userId, 'trackingData': json.encode(tracking.toMap())},
    );
    var response = json.decode(consult.body);
    int index = _trackings.indexWhere((t) => t.idMDB == tracking.idMDB);
    trackingCheckUpdate(index, response);
    if (consult.statusCode == 200) {
      if (response['result']['events'].isEmpty) {
        GlobalToast(context, "No hay actualizaciones").displayToast();
      } else {
        trackingDataUpdate(index, response, false);
        GlobalToast(context, "Seguimiento actualizado").displayToast();
      }
    } else if (consult.statusCode == 204) {
      ShowDialog(context).trackingError(_trackings[index].service);
    } else {
      ShowDialog(context).checkUpdateError();
    }
    Provider.of<Status>(context, listen: false).toggleCheckingStatus();
    notifyListeners();
  }

  void loadNotificationData(bool foreground, RemoteMessage message,
      NavigatorState? navigatorState, BuildContext? context) {
    RemoteNotification notification = message.notification!;
    List<dynamic> response = json.decode(message.data['data']);

    late int index;
    for (var item in response) {
      index = _trackings.indexWhere((t) => t.idMDB == item['idMDB']);
      if (item['result']['lastEvent'] != _trackings[index].lastEvent) {
        trackingCheckUpdate(index, item);
        trackingDataUpdate(index, item, false);
      }
    }
    if (!foreground) {
      if (response.length == 1) {
        navigatorState!.push(MaterialPageRoute(
            builder: (_) => TrackingDetail(_trackings[index])));
      }
      if (response.length > 1) {
        Provider.of<Status>(context!, listen: false)
            .showNotificationOverlay(notification.title!, notification.body!);
      }
    }
    if (foreground) {
      Provider.of<Status>(context!, listen: false)
          .showNotificationOverlay(notification.title!, notification.body!);
    }
    notifyListeners();
  }

  void trackingCheckUpdate(int index, dynamic itemDataTracking) {
    String checkDate = itemDataTracking['checkDate'];
    String checkTime = itemDataTracking['checkTime'];
    _trackings[index].lastCheck = '$checkDate - $checkTime';
  }

  void trackingDataUpdate(
      int index, dynamic itemDataTracking, bool syncronization) {
    ItemResponseData itemResponseData =
        Response.update(itemDataTracking['service'], itemDataTracking);
    List<Map<String, String>> newEventList = [];
    for (var newEvent in itemResponseData.events!) {
      newEventList.add(newEvent);
    }
    if (syncronization == false) {
      for (var event in _trackings[index].events!) {
        newEventList.add(event);
      }
    }
    _trackings[index].events = newEventList;
    _trackings[index].lastEvent = itemDataTracking['result']['lastEvent'];
    if (_trackings[index].service == 'DHL') {
      _trackings[index].otherData![1] = itemResponseData.otherData![1]!;
    }
    storedData.updateMainTracking(_trackings[index]);
  }

  String startError = '';
  String get loadStartError => startError;

  void changeStartError(String newError) {
    startError = newError;
    notifyListeners();
  }

  void sincronizeUserData(BuildContext? context) async {
    String url = "${dotenv.env['API_URL']}/api/user/sincronize/";
    List<Object> lastEventsList = [];
    if (_trackings.isNotEmpty) {
      for (var element in _trackings) {
        Object lastEvent = {
          'idMDB': element.idMDB,
          'eventDescription': element.lastEvent
        };
        if (element.idMDB != null && element.lastEvent != null) {
          lastEventsList.add(lastEvent);
        }
      }
    }
    var now =
        tz.TZDateTime.now(tz.getLocation("America/Argentina/Buenos_Aires"));
    bool driveStatus =
        Provider.of<Preferences>(context!, listen: false).gdStatus;
    String _userId = Provider.of<Preferences>(context, listen: false).userId;
    var response = await http.Client().post(
      Uri.parse(url.toString()),
      body: {
        'userId': _userId,
        'token': await FirebaseMessaging.instance.getToken(),
        'lastEvents': json.encode(lastEventsList),
        'currentDate':
            "${now.day.toString().padLeft(2, "0")}/${now.month.toString().padLeft(2, "0")}/${now.year}",
        'driveLoggedIn': driveStatus.toString(),
        'version': '1.0.2'
      },
    );
    var decodedData = json.decode(response.body);
    if (decodedData['error'] == "User not found") {
      return changeStartError("User not found");
    }
    if (decodedData['driveStatus'] == "Update required" ||
        decodedData['driveStatus'] == 'Backup not found') {
      await updateCreateDriveBackup(true, context);
    }
    print("SYNCRONIZATION");
    if (decodedData['data'].isEmpty) return;
    List<String> updatedItems = [];
    for (var tDB in decodedData['data']) {
      int index = _trackings.indexWhere((seg) => seg.idMDB == tDB['_id']);
      trackingCheckUpdate(index, tDB);
      trackingDataUpdate(index, tDB, true);
      String tracking = trackings[index].title!;
      updatedItems.add(tracking);
    }
    if (updatedItems.isNotEmpty) {
      String message = '';
      if (updatedItems.length == 1) message = updatedItems[0];
      if (updatedItems.length > 1) message = "Varios seguimientos actualizados";
      Provider.of<Status>(context, listen: false)
          .showNotificationOverlay("Datos sincronizados", message);
    }
    notifyListeners();
  }

  Future<dynamic> updateCreateDriveBackup(
      bool background, BuildContext context) async {
    Map<String, dynamic> databaseData = await StoredData().userBackupData();
    String _userId = Provider.of<Preferences>(context, listen: false).userId;
    var response = await http.Client().post(
        Uri.parse("${dotenv.env['API_URL']}/api/google/createUpdate"),
        body: {
          'userId': _userId,
          'userData': json.encode(databaseData),
        });
    return background ? null : response;
  }
}
