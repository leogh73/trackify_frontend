import 'package:flutter/material.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:trackify/providers/http_request_handler.dart';
import 'package:trackify/providers/preferences.dart';

import '../database.dart';
import '../providers/trackings_active.dart';
import '../screens/tracking_detail.dart';
import '../widgets/dialog_and_toast.dart';
import '../widgets/data_response.dart';

import 'classes.dart';
import 'status.dart';

class TrackingFunctions {
  static void searchUpdates(BuildContext context, ItemTracking tracking) async {
    bool completedStatus =
        checkCompletedStatus(tracking.service, tracking.lastEvent!);
    if (completedStatus)
      return GlobalToast(context, "No hay actualizaciones").displayToast();
    List<ItemTracking> _trackings =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    Provider.of<Status>(context, listen: false).toggleCheckingStatus();
    String _userId = Provider.of<Preferences>(context, listen: false).userId;
    Object body = {
      'userId': _userId,
      'trackingData': json.encode(tracking.toMap())
    };
    dynamic response =
        await HttpRequestHandler.newRequest('/api/user/check/', body);
    Provider.of<Status>(context, listen: false).toggleCheckingStatus();
    if (response is Map)
      return ShowDialog(context).connectionServerError(false);
    var data = json.decode(response.body);
    int index = _trackings.indexWhere((t) => t.idMDB == tracking.idMDB);
    trackingCheckUpdate(context, index, data);
    if (response.statusCode == 200) {
      if (data['result']['events'].isEmpty) {
        GlobalToast(context, "No hay actualizaciones").displayToast();
      } else {
        trackingDataUpdate(context, index, data);
        GlobalToast(context, "Seguimiento actualizado").displayToast();
      }
    } else if (response.statusCode == 204) {
      ShowDialog(context).trackingError(_trackings[index].service);
    } else {
      ShowDialog(context).checkUpdateError();
    }
  }

  static void loadNotificationData(
      bool foreground, RemoteMessage message, BuildContext context) {
    List<ItemTracking> _trackings =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    RemoteNotification notification = message.notification!;
    List<dynamic> response = json.decode(message.data['data']);

    late int index;
    for (var item in response) {
      index = _trackings.indexWhere((t) => t.idMDB == item['idMDB']);
      if (item['result']['lastEvent'] != _trackings[index].lastEvent) {
        trackingCheckUpdate(context, index, item);
        trackingDataUpdate(context, index, item);
      }
    }
    if (!foreground && response.length == 1) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => TrackingDetail(_trackings[index])));
    }
    if (foreground || !foreground && response.length > 1) {
      Provider.of<Status>(context, listen: false)
          .showNotificationOverlay(notification.title!, notification.body!);
    }
  }

  static void trackingCheckUpdate(
      BuildContext context, int index, dynamic itemDataTracking) {
    List<ItemTracking> _trackings =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    String checkDate = itemDataTracking['checkDate'];
    String checkTime = itemDataTracking['checkTime'];
    _trackings[index].lastCheck = '$checkDate - $checkTime';
  }

  static void trackingDataUpdate(
      BuildContext context, int index, dynamic itemDataTracking) {
    StoredData storedData = StoredData();
    List<ItemTracking> _trackings =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    ItemResponseData itemResponseData = Response.dataHandler(
        itemDataTracking['service'], itemDataTracking, true);
    List<Map<String, String>>? newEventList = _trackings[index].events!;
    for (var event in itemResponseData.events!.reversed) {
      newEventList.insert(0, event);
    }
    _trackings[index].events = newEventList;
    _trackings[index].lastEvent = itemDataTracking['result']['lastEvent'];
    if (_trackings[index].service == 'DHL') {
      _trackings[index].otherData![1] = itemResponseData.otherData![1]!;
    }
    storedData.updateMainTracking(_trackings[index]);
  }

  static bool checkCompletedStatus(String service, String lastEvent) {
    List<String> words = [
      'entregado',
      'entregada',
      'entregamos',
      'devuelto',
      'entrega en',
      'devolución',
      'rehusado',
      'no pudo ser retirado',
      'entrega en sucursal',
    ];
    bool status = false;
    for (var w in words) {
      if (!status && lastEvent.toLowerCase().contains(w)) {
        status = true;
      }
    }
    return status;
  }

  static void syncronizeUserData(BuildContext context) async {
    List<ItemTracking> _trackings =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    List<Object> lastEventsList = [];
    if (_trackings.isNotEmpty) {
      for (var element in _trackings) {
        if (element.lastEvent == null) return;
        bool completedTracking =
            checkCompletedStatus(element.service, element.lastEvent!);
        Object lastEvent = {
          'idMDB': element.idMDB,
          'eventDescription': element.lastEvent
        };
        if (element.idMDB != null &&
            element.lastEvent != null &&
            !completedTracking) {
          lastEventsList.add(lastEvent);
        }
      }
    }
    // if (lastEventsList.isEmpty) return;
    var now =
        tz.TZDateTime.now(tz.getLocation("America/Argentina/Buenos_Aires"));
    bool driveStatus =
        Provider.of<Preferences>(context, listen: false).gdStatus;
    String _userId = Provider.of<Preferences>(context, listen: false).userId;
    Object body = {
      'userId': _userId,
      'token': await FirebaseMessaging.instance.getToken(),
      'lastEvents': json.encode(lastEventsList),
      'currentDate':
          "${now.day.toString().padLeft(2, "0")}/${now.month.toString().padLeft(2, "0")}/${now.year}",
      'driveLoggedIn': driveStatus.toString(),
      'version': '1.0.5'
    };
    dynamic response =
        await HttpRequestHandler.newRequest('/api/user/syncronize/', body);
    if (response is Map) return;
    var decodedData = json.decode(response.body);
    if (decodedData['error'] != null) {
      return Provider.of<Status>(context, listen: false)
          .setStartError(decodedData['error']);
    } else {
      Provider.of<Status>(context, listen: false).setStartError("");
    }
    if (decodedData['driveStatus'] == "Update required" ||
        decodedData['driveStatus'] == 'Backup not found') {
      await updateCreateDriveBackup(true, context);
    }
    if (decodedData['data'].isEmpty) return;
    List<String> updatedItems = [];
    for (var tDB in decodedData['data']) {
      int index = _trackings.indexWhere((seg) => seg.idMDB == tDB['id']);
      trackingCheckUpdate(context, index, tDB);
      trackingDataUpdate(context, index, tDB);
      String tracking = _trackings[index].title!;
      updatedItems.add(tracking);
    }
    if (updatedItems.isNotEmpty) {
      String message = '';
      if (updatedItems.length == 1) message = updatedItems[0];
      if (updatedItems.length > 1) {
        message = "Varios seguimientos actualizados";
      }
      Provider.of<Status>(context, listen: false)
          .showNotificationOverlay("Datos syncronizados", message);
    }
  }

  static Future<dynamic> updateCreateDriveBackup(
      bool background, BuildContext context) async {
    final Map<String, dynamic> databaseData =
        await StoredData().userBackupData();
    String _userId = Provider.of<Preferences>(context, listen: false).userId;
    Object body = {'userId': _userId, 'userData': json.encode(databaseData)};
    dynamic response =
        await HttpRequestHandler.newRequest('/api/google/createUpdate', body);
    if (response is Map) return;
    return background ? null : response;
  }
}
