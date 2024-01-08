import 'package:flutter/material.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'dart:convert';

import 'http_connection.dart';
import '../widgets/dialog_error.dart';
import '../providers/preferences.dart';

import '../database.dart';
import '../providers/trackings_active.dart';
import '../screens/tracking_detail.dart';
import '../widgets/dialog_toast.dart';

import 'classes.dart';
import 'status.dart';

class TrackingFunctions {
  static void searchUpdates(BuildContext context, ItemTracking tracking) async {
    bool completedStatus =
        checkCompletedStatus(tracking.service, tracking.lastEvent!);
    if (completedStatus)
      return GlobalToast.displayToast(context, "No hay actualizaciones");
    List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    Provider.of<Status>(context, listen: false).toggleCheckingStatus();
    String userId = Provider.of<UserPreferences>(context, listen: false).userId;
    Object body = {
      'userId': userId,
      'trackingData': json.encode(tracking.toMap())
    };
    await HttpConnection.awakeAPIs();
    Response response =
        await HttpConnection.requestHandler('/api/user/check/', body);
    Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, context);
    if (response.statusCode == 500) {
      if (responseData['error'] == "No data") {
        DialogError.trackingNoDataRemoved(context, tracking.service);
      }
      if (responseData['result']['error']['body'] == "Service timeout") {
        DialogError.serviceTimeout(context, tracking.service);
      }
      return;
    }
    int index = trackingsList.indexWhere((t) => t.idMDB == tracking.idMDB);
    trackingCheckUpdate(context, index, responseData);
    Provider.of<Status>(context, listen: false).toggleCheckingStatus();
    if (responseData['result']['events'].isEmpty) {
      GlobalToast.displayToast(context, "No hay actualizaciones");
    } else {
      trackingDataUpdate(context, index, responseData['result']);
      GlobalToast.displayToast(context, "Seguimiento actualizado");
    }
  }

  static void loadNotificationData(
      bool foreground, RemoteMessage message, BuildContext context) {
    List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    RemoteNotification notification = message.notification!;
    List<dynamic> responseData = json.decode(message.data['data']);
    late int index;
    for (dynamic item in responseData) {
      index = trackingsList.indexWhere((t) => t.idMDB == item['idMDB']);
      if (item['result']['lastEvent'] != trackingsList[index].lastEvent) {
        trackingCheckUpdate(context, index, item);
        trackingDataUpdate(context, index, item['result']);
      }
    }
    if (!foreground && responseData.length == 1) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => TrackingDetail(trackingsList[index])));
    }
    if (foreground || !foreground && responseData.length > 1) {
      Provider.of<Status>(context, listen: false)
          .showNotificationOverlay(notification.title!, notification.body!);
    }
  }

  static void trackingCheckUpdate(
      BuildContext context, int index, Map<String, dynamic> itemDataTracking) {
    List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    String checkDate = itemDataTracking['checkDate'];
    String checkTime = itemDataTracking['checkTime'];
    trackingsList[index].lastCheck = '$checkDate - $checkTime';
  }

  static void trackingDataUpdate(
      BuildContext context, int index, Map<String, dynamic> itemData) {
    StoredData storedData = StoredData();
    List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    List<Map<String, String>> newEventList = trackingsList[index].events;
    for (dynamic event in itemData['events'].reversed) {
      newEventList.insert(0, Map<String, String>.from(event));
    }
    trackingsList[index].events = newEventList;
    trackingsList[index].lastEvent = itemData['lastEvent'];
    if (itemData['moreData'] != null) {
      for (Map<String, dynamic> element in itemData['moreData']) {
        int dataIndex = trackingsList[index]
            .moreData!
            .indexWhere((d) => d["title"] == element["title"]);
        trackingsList[index].moreData![dataIndex]['data'] = element["data"];
      }
    }
    storedData.updateMainTracking(trackingsList[index]);
  }

  static bool checkCompletedStatus(String service, String lastEvent) {
    List<String> words = [
      "entregado",
      "entregada",
      'entregamos',
      'devuelto',
      'entrega en',
      'devolución',
      'devuelto',
      'rehusado',
      "decomisado",
      "descomisado",
      "retenido",
      "incautado",
      'no pudo ser retirado',
      'entrega en sucursal',
    ];
    List<String> notWords = [
      'no entregada',
      'no entregado',
      'no fue entregado',
      'no fue entregada',
    ];
    String lCLastEvent = lastEvent.toLowerCase();
    bool status = false;
    for (String w in words) {
      if (lCLastEvent.contains(w)) {
        status = true;
      }
    }
    for (String w in notWords) {
      if (status && lCLastEvent.contains(w)) {
        status = false;
      }
    }
    return status;
  }

  static void syncronizeUserData(BuildContext context) async {
    List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    List<Object> lastEventsList = [];
    if (trackingsList.isNotEmpty) {
      for (ItemTracking tracking in trackingsList) {
        bool completedTracking =
            checkCompletedStatus(tracking.service, tracking.lastEvent!);
        Object lastEvent = {
          'idMDB': tracking.idMDB,
          'eventDescription': tracking.lastEvent
        };
        if (tracking.idMDB != null && !completedTracking) {
          lastEventsList.add(lastEvent);
        }
      }
    }
    // if (lastEventsList.isEmpty) return;
    tz.TZDateTime now =
        tz.TZDateTime.now(tz.getLocation("America/Argentina/Buenos_Aires"));
    bool driveStatus =
        Provider.of<UserPreferences>(context, listen: false).gdStatus;
    String userId = Provider.of<UserPreferences>(context, listen: false).userId;
    Object body = {
      'userId': userId,
      'token': await FirebaseMessaging.instance.getToken(),
      'lastEvents': json.encode(lastEventsList),
      'currentDate':
          "${now.day.toString().padLeft(2, "0")}/${now.month.toString().padLeft(2, "0")}/${now.year}",
      'driveLoggedIn': driveStatus.toString(),
      'version': '1.1.6'
    };
    Response response =
        await HttpConnection.requestHandler('/api/user/syncronize/', body);
    if (response.statusCode != 200) return;
    Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData['syncError'] != null) {
      return Provider.of<Status>(context, listen: false)
          .setStartError(responseData['syncError']);
    } else {
      Provider.of<Status>(context, listen: false).setStartError("");
    }
    final String statusMessage =
        Provider.of<UserPreferences>(context, listen: false).getStatusMessage;
    final bool showAgainStatusMessage =
        Provider.of<UserPreferences>(context, listen: false).showMessageAgain;
    if (statusMessage != responseData['statusMessage']) {
      Provider.of<UserPreferences>(context, listen: false)
          .setStatusMessage(responseData['statusMessage']);
      if (responseData['statusMessage'].isEmpty) {
        Provider.of<UserPreferences>(context, listen: false)
            .setShowMessageAgain(false);
      }
      if (responseData['statusMessage'].isNotEmpty) {
        Provider.of<UserPreferences>(context, listen: false)
            .setShowMessageAgain(true);
        DialogError.statusMessage(context, responseData['statusMessage']);
      }
      Provider.of<UserPreferences>(context, listen: false)
          .storeMessageData(responseData['statusMessage']);
    } else if (showAgainStatusMessage && statusMessage.isNotEmpty) {
      DialogError.statusMessage(context, statusMessage);
    }
    if (responseData['driveStatus'] == "Update required" ||
        responseData['driveStatus'] == 'Backup not found') {
      await updateCreateDriveBackup(true, context);
    }
    if (responseData['data'].isEmpty) return;
    List<String> updatedItems = [];
    for (dynamic tDB in responseData['data']) {
      int index = trackingsList.indexWhere((seg) => seg.idMDB == tDB['id']);
      trackingCheckUpdate(context, index, tDB);
      trackingDataUpdate(context, index, tDB['result']);
      String tracking = trackingsList[index].title!;
      updatedItems.add(tracking);
    }
    if (updatedItems.isNotEmpty) {
      String message = '';
      if (updatedItems.length == 1) message = updatedItems[0];
      if (updatedItems.length > 1) {
        message = "Varios seguimientos actualizados";
      }
      Provider.of<Status>(context, listen: false)
          .showNotificationOverlay("Datos sincronizados", message);
    }
  }

  static Future<dynamic> updateCreateDriveBackup(
      bool background, BuildContext context) async {
    final Map<String, dynamic> databaseData =
        await StoredData().userBackupData();
    String _userId =
        Provider.of<UserPreferences>(context, listen: false).userId;
    Object body = {'userId': _userId, 'userData': json.encode(databaseData)};
    Response response = await HttpConnection.requestHandler(
        '/api/googledrive/createUpdate', body);
    Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, context);
    if (responseData['error'] != null) return;
    return background ? null : response;
  }
}
