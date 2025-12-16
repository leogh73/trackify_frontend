import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
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
    // final bool completedStatus =
    //     checkCompletedStatus(tracking.service, tracking.lastEvent!, texts);
    // if (completedStatus) {
    //   return GlobalToast.displayToast(context, texts[208]!);
    // };
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
        return DialogError.show(context, 6, tracking.service);
      }
      return responseData['error'] == "No data"
          ? DialogError.show(context, 5, tracking.service)
          : DialogError.show(context, 8, tracking.service);
    }
    int index = trackingsList.indexWhere((t) => t.idMDB == tracking.idMDB);
    trackingCheckUpdate(context, index, responseData);
    if (responseData['result']['events'].isEmpty) {
      GlobalToast.displayToast(context, texts[208]!);
    } else {
      trackingDataUpdate(context, index, responseData['result']);
      GlobalToast.displayToast(context, texts[209]!);
    }
  }

  static void loadNotificationData(
      bool foreground, RemoteMessage message, BuildContext context) {
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    final List<dynamic> response = json.decode(message.data['data']);
    final List<dynamic> responseData = [];
    late int index;
    for (dynamic item in response) {
      index = trackingsList.indexWhere((t) => t.idMDB == item['idMDB']);
      if (index != -1 &&
          item['result']['lastEvent'] != trackingsList[index].lastEvent) {
        trackingCheckUpdate(context, index, item);
        trackingDataUpdate(context, index, item['result']);
        responseData.add(item);
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
    Provider.of<Status>(context, listen: false).setNewSyncDate();
  }

  static void trackingCheckUpdate(
      BuildContext context, int index, Map<String, dynamic> itemDataTracking) {
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    final String checkDate = itemDataTracking['checkDate'];
    final String checkTime = itemDataTracking['checkTime'];
    trackingsList[index].lastCheck = '$checkDate - $checkTime';
  }

  static void trackingDataUpdate(
      BuildContext context, int index, Map<String, dynamic> itemData) {
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    final List<Map<String, String>> newEventList = trackingsList[index].events;
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
    final StoredData storedData = StoredData();
    storedData.updateActiveTracking(trackingsList[index]);
  }

  static void syncronizeUserData(BuildContext context) async {
    final String lastSync =
        Provider.of<Status>(context, listen: false).getLastSyncDate;
    final DateTime lastSyncDate = DateTime.parse(lastSync);
    final DateTime currentDate = DateTime.now();
    final int dateDifference = currentDate.difference(lastSyncDate).inHours;
    if (dateDifference < 8) {
      return;
    }
    final Map<int, dynamic> texts =
        Provider.of<UserPreferences>(context, listen: false).selectedLanguage;
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    final List<Object> lastEventsList = [];
    if (trackingsList.isNotEmpty) {
      for (ItemTracking tracking in trackingsList) {
        if (tracking.idMDB != null) {
          lastEventsList.add({
            'idMDB': tracking.idMDB,
            'eventDescription': tracking.lastEvent
          });
        }
      }
    }
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
      'lastEvents': json.encode(lastEventsList),
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
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData.isEmpty) return;

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
      checkPayment(context, responseData['mercadoPago'], texts);
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
    Provider.of<Status>(context, listen: false).setNewSyncDate();
    if (responseData['data'].isEmpty) {
      return;
    }
    List<String> updatedItems = [];
    for (dynamic tDB in responseData['data']) {
      int index = trackingsList.indexWhere((seg) => seg.idMDB == tDB['id']);
      if (index != -1) {
        trackingCheckUpdate(context, index, tDB);
        trackingDataUpdate(context, index, tDB['result']);
        String tracking = trackingsList[index].title!;
        updatedItems.add(tracking);
      }
    }
    if (updatedItems.isNotEmpty) {
      String message = '';
      if (updatedItems.length == 1) message = updatedItems[0];
      if (updatedItems.length > 1) {
        message = texts[229]!;
      }
      Provider.of<Status>(context, listen: false)
          .showNotificationOverlay(texts[230]!, message);
    }
  }

  static void checkPayment(BuildContext context,
      Map<String, dynamic> paymentData, Map<int, dynamic> texts) {
    final bool showPaymentErrorAgain =
        Provider.of<UserPreferences>(context, listen: false)
            .showAgainPaymentError;
    if (paymentData["status"] == "could not be checked") {
      if (showPaymentErrorAgain) {
        ShowDialog.showMessage(context, texts[231]!, "payment", texts);
      }
    } else {
      Provider.of<UserPreferences>(context, listen: false)
          .setShowPaymentErrorAgain(true);
    }
  }

  static String formatEventDate(
      BuildContext context, String value, bool dateOnly) {
    final Map<int, dynamic> texts =
        Provider.of<UserPreferences>(context, listen: false).selectedLanguage;
    String year = "";
    String month = "";
    String day = "";
    final String lastEventDate = dateOnly ? value : value.split(" - ")[0];
    if (lastEventDate.contains(" de ")) {
      final List<String> splittedDate = lastEventDate.split(", ");
      final List<String> splittedDayMonth = splittedDate[0].split(" de ");
      year = splittedDate[1];
      day = splittedDayMonth[0];
      month = splittedDayMonth[1];
    } else {
      final List<String> splittedDate =
          dateOnly ? value.split("/") : value.split(" - ")[0].split("/");
      year = splittedDate[2];
      month = texts[249][int.parse(splittedDate[1])];
      day = splittedDate[0];
    }
    final String formatedDate = "$day $month, $year";
    if (dateOnly) {
      return formatedDate;
    }
    List<String> splittedLastEvent = value.split(" - ");
    splittedLastEvent.replaceRange(0, 1, [formatedDate]);
    final String formattedLastEvent = splittedLastEvent.join(" - ");
    return formattedLastEvent;
  }

  static String daysInTransit(BuildContext context, String last, String first) {
    Map<int, dynamic> texts =
        Provider.of<UserPreferences>(context, listen: false).selectedLanguage;
    final List<int> lastDateSplitted = parseDate(texts[248], last);
    final List<int> firstDateSplitted = parseDate(texts[248], first);
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

  static List<int> parseDate(Map<String, int> language, String date) {
    if (date.toLowerCase().contains(" de ")) {
      final List<String> splittedDate =
          date.toLowerCase().split(" de ").map((d) => d.toString()).toList();
      final String yearString = splittedDate[1].split(", ")[1];
      final String monthString = splittedDate[1].split(", ")[0];
      final int monthNumber = language[monthString]!;
      return [int.parse(splittedDate[0]), monthNumber, int.parse(yearString)];
    }
    return (date.contains("/") ? date.split("/") : date.split("-"))
        .map((t) => int.parse(t))
        .toList();
  }

  static List<int> parseTime(String time) {
    if (time.contains("AM") || time.contains("PM")) {
      final DateTime dateTime = DateFormat("hh:mm a").parse(time);
      final String twentyFourHourTime = DateFormat("HH:mm").format(dateTime);
      return twentyFourHourTime.split(":").map((t) => int.parse(t)).toList();
    }
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
