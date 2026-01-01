import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'dart:convert';

import '../data/classes.dart';
import '../data/status.dart';
import '../data/http_connection.dart';
import '../data/preferences.dart';
import '../data/services.dart';
import '../data/trackings_active.dart';

import '../screens/tracking_detail.dart';

import '../widgets/dialog_error.dart';
import '../widgets/dialog_toast.dart';

import '../database.dart';

class TrackingFunctions {
  static void searchUpdates(BuildContext context, ItemTracking tracking) async {
    Map<int, dynamic> texts =
        Provider.of<UserPreferences>(context, listen: false).selectedLanguage;
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    Provider.of<Status>(context, listen: false).toggleCheckingStatus();
    final String userId =
        Provider.of<UserPreferences>(context, listen: false).userId;
    final Object body = {
      'userId': userId,
      'trackingData': json.encode(tracking.toMap())
    };
    final Response response =
        await HttpConnection.requestHandler('/api/user/check/', body);
    if (!context.mounted) {
      return;
    }
    final Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, context);
    Provider.of<Status>(context, listen: false).toggleCheckingStatus();
    if (response.statusCode == 500) {
      if (responseData['result']?['error']['body'] == "Service timeout") {
        DialogError.show(context, 6, tracking.service);
        return;
      }
      return responseData['error'] == "No data"
          ? DialogError.show(context, 5, tracking.service)
          : DialogError.show(context, 8, tracking.service);
    }
    final int index =
        trackingsList.indexWhere((t) => t.idMDB == tracking.idMDB);
    Provider.of<ActiveTrackings>(context, listen: false)
        .trackingDataUpdate(context, index, responseData);
    Future.delayed(const Duration(seconds: 1), () {
      BuildContext ctx = context;
      if (ctx.mounted == false) {
        return;
      }
      Provider.of<ActiveTrackings>(ctx, listen: false)
          .toggleAnimate(trackingsList, index);
    });
    if (responseData['result']['events'].isEmpty &&
        trackingsList[index].status == responseData["status"]) {
      GlobalToast.displayToast(context, texts[208]!);
    } else {
      GlobalToast.displayToast(context, texts[209]!);
    }
  }

  static void loadNotificationData(
      bool foreground, RemoteMessage message, BuildContext context) {
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    final List<dynamic> responseData = [];
    late int index;
    if (message.data['data'].isEmpty) {
      TrackingFunctions.syncronizeUserData(context, true);
    } else {
      final List<dynamic> response = json.decode(message.data['data']);
      for (dynamic item in response) {
        index = trackingsList.indexWhere((t) => t.idMDB == item['idMDB']);
        if (index != -1) {
          Provider.of<ActiveTrackings>(context, listen: false)
              .trackingDataUpdate(context, index, item);
          Future.delayed(const Duration(seconds: 1), () {
            BuildContext ctx = context;
            if (ctx.mounted == false) {
              return;
            }
            Provider.of<ActiveTrackings>(ctx, listen: false)
                .toggleAnimate(trackingsList, index);
          });
          responseData.add(item);
        }
      }
    }
    if (!foreground && responseData.length == 1) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => TrackingDetail(trackingsList[index])));
    }
    if (foreground || !foreground && responseData.length > 1) {
      final RemoteNotification notification = message.notification!;
      Provider.of<Status>(context, listen: false)
          .showNotificationOverlay(notification.title!, notification.body!);
    }
  }

  static List<Object> getTrackingEvents(
      BuildContext context,
      Map<int, dynamic> texts,
      List<ItemTracking> activeTrackings,
      bool mustSyncTrackings) {
    if (activeTrackings.isEmpty) {
      return [];
    }
    final List<Object> trackingEvents = activeTrackings.map((t) {
      return {
        'idMDB': t.idMDB,
        'eventsList': t.events,
        'status': t.status,
      };
    }).toList();
    if (mustSyncTrackings) {
      return trackingEvents;
    }
    final List<ItemTracking> sortedTrackings =
        Provider.of<UserPreferences>(context, listen: false)
            .sortTrackings(texts[206], activeTrackings);
    final Map<String, dynamic> lastEvent = sortedTrackings[0].events[0];
    final List<int> dateSplitted =
        TrackingFunctions.parseDate(lastEvent["date"]);
    final List<int> timeSplitted =
        TrackingFunctions.parseTime(lastEvent["time"]);
    final DateTime lastEventDate = DateTime(
      dateSplitted[2],
      dateSplitted[1],
      dateSplitted[0],
      timeSplitted[0],
      timeSplitted[1],
      timeSplitted.length == 3 ? timeSplitted[2] : 00,
    );
    final DateTime currentDate = DateTime.now();
    final int timeDifference =
        currentDate.difference(lastEventDate).inHours - 3;
    return timeDifference > 12 ? trackingEvents : [];
  }

  static void syncronizeUserData(
      BuildContext context, bool mustSyncTrackings) async {
    final Map<int, dynamic> texts =
        Provider.of<UserPreferences>(context, listen: false).selectedLanguage;
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    final List<ItemTracking> activeTrackings = trackingsList
        .where((t) => t.idMDB != null && t.active == true)
        .toList();
    List<Object> trackingEvents =
        getTrackingEvents(context, texts, activeTrackings, mustSyncTrackings);
    final UserData storedUserData = (await StoredData().loadUserData())[0];
    if (!context.mounted) {
      return;
    }
    final bool driveStatus =
        Provider.of<UserPreferences>(context, listen: false).gdStatus;
    final Map<String, dynamic> paymentData =
        Provider.of<UserPreferences>(context, listen: false).paymentData;
    String userId = Provider.of<UserPreferences>(context, listen: false).userId;
    Map<String, dynamic> servicesData =
        Provider.of<Services>(context, listen: false).servicesData;
    userId = userId.isEmpty
        ? storedUserData.userId
        : Provider.of<UserPreferences>(context, listen: false).userId;
    servicesData = servicesData.isEmpty
        ? storedUserData.servicesData!
        : Provider.of<Services>(context, listen: false).servicesData;
    final Object body = {
      'userId': userId,
      'token': await FirebaseMessaging.instance.getToken(),
      'trackingEvents': json.encode(trackingEvents),
      'payment': json.encode({
        'status': paymentData['status'] ?? '',
        'isValid': paymentData['isValid'] ?? '',
        'daysRemaining': paymentData['daysRemaining'] ?? "",
      }),
      'servicesCount': servicesData.keys.length.toString(),
      "servicesVersions":
          servicesData.values.map((e) => e['__v']).toList().join(""),
      'driveLoggedIn': driveStatus.toString(),
      'version': '1.2.0'
    };
    final Response response =
        await HttpConnection.requestHandler('/api/user/syncronize/', body);
    if (response.statusCode == 500) {
      if (!context.mounted) {
        return;
      }
      DialogError.show(context, 1, "");
      return;
    }
    if (!context.mounted) {
      return;
    }
    final Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, context);
    if (responseData.isEmpty) {
      return;
    }
    if (responseData['error'] == "user not found") {
      await StoredData().dropDatabase();
      if (!context.mounted) {
        return;
      }
      Phoenix.rebirth(context);
      return;
    }
    if (responseData["updatedServices"].isNotEmpty) {
      await ServicesData.store(responseData["updatedServices"]);
      if (!context.mounted) {
        return;
      }
      Phoenix.rebirth(context);
      return;
    }
    if (responseData['mercadoPago'] != null) {
      if (!context.mounted) {
        return;
      }
      Provider.of<UserPreferences>(context, listen: false)
          .setPaymentData(responseData['mercadoPago']);
      if (!context.mounted) {
        return;
      }
      Provider.of<UserPreferences>(context, listen: false)
          .checkPayment(context, responseData['mercadoPago'], texts);
    }
    if (responseData['driveStatus'] != null) {
      if (responseData['driveStatus'] == "Update required" ||
          responseData['driveStatus'] == 'Backup not found') {
        if (!context.mounted) {
          return;
        }
        await updateCreateDriveBackup(true, context);
      }
    }
    if (!context.mounted) {
      return;
    }
    if (responseData['data'].isEmpty) {
      return;
    }
    List<String> updatedItems = [];
    for (dynamic tDB in responseData['data']) {
      int index = trackingsList.indexWhere((seg) => seg.idMDB == tDB['id']);
      if (index != -1) {
        Provider.of<ActiveTrackings>(context, listen: false)
            .trackingDataUpdate(context, index, tDB);
        Future.delayed(const Duration(seconds: 1), () {
          BuildContext ctx = context;
          if (ctx.mounted == false) {
            return;
          }
          Provider.of<ActiveTrackings>(ctx, listen: false)
              .toggleAnimate(trackingsList, index);
        });
        String tracking = trackingsList[index].title!;
        updatedItems.add(tracking);
      }
    }
    if (updatedItems.isNotEmpty) {
      String message = '';
      if (updatedItems.length == 1) {
        message = updatedItems[0];
      }
      if (updatedItems.length > 1) {
        message = texts[229]!;
      }
      Provider.of<Status>(context, listen: false)
          .showNotificationOverlay(texts[230]!, message);
    }
  }

  static String formatEventDate(BuildContext context, String value) {
    final Map<int, dynamic> texts =
        Provider.of<UserPreferences>(context, listen: false).selectedLanguage;
    final List<String> splittedDate = value.split("/");
    final String year = splittedDate[2];
    final String month = texts[249][int.parse(splittedDate[1])];
    final String day = splittedDate[0];
    final String formatedDate = "$day $month, $year";
    return formatedDate;
  }

  static String formatEventDetail(Map<String, dynamic> event) {
    final List<String> keysCollection =
        event.keys.where((k) => k != "date" && k != "time").toList();
    final List<String> eventData = [];
    for (String key in keysCollection) {
      eventData.add(event[key]);
    }
    return eventData.join(" - ");
  }

  static String daysInTransit(BuildContext context, String last, String first) {
    final List<int> lastDateSplitted = parseDate(last);
    final List<int> firstDateSplitted = parseDate(first);
    DateTime lastDate = DateTime(
      lastDateSplitted.length == 3 ? lastDateSplitted[2] : DateTime.now().year,
      lastDateSplitted[1],
      lastDateSplitted[0],
    );
    DateTime firstDate = DateTime(
      firstDateSplitted.length == 3
          ? firstDateSplitted[2]
          : DateTime.now().year,
      firstDateSplitted[1],
      firstDateSplitted[0],
    );
    final int daysDifference = lastDate.difference(firstDate).inDays;
    return daysDifference.toString();
  }

  static List<int> parseDate(String date) {
    return (date.contains("/") ? date.split("/") : date.split("-"))
        .map((t) => int.parse(t))
        .toList();
  }

  static List<int> parseTime(String time) {
    return time.split(":").map((t) => int.parse(t)).toList();
  }

  static Future<dynamic> updateCreateDriveBackup(
      bool background, BuildContext context) async {
    final Map<String, dynamic> databaseData =
        await StoredData().userBackupData();
    if (!context.mounted) {
      return;
    }
    final String userId =
        Provider.of<UserPreferences>(context, listen: false).userId;
    final Object body = {
      'userId': userId,
      'userData': json.encode(databaseData)
    };
    final Response response = await HttpConnection.requestHandler(
        '/api/googledrive/createUpdate', body);
    if (!context.mounted) {
      return;
    }
    final Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, context);
    if (responseData['error'] != null) return;
    return background ? null : response;
  }
}
