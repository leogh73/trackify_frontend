import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'providers/http_connection.dart';
import 'providers/classes.dart';
import 'database.dart';

class Init {
  static StoredData storedData = StoredData();

  static Future<String?> firebaseMessagingNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (defaultTargetPlatform == TargetPlatform.android) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
      );
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    String? deviceToken = await FirebaseMessaging.instance.getToken();
    return deviceToken;
  }

  static Future<UserData> loadNewUserData() async {
    UserData startPreferences = UserData(
      id: 0,
      userId: '',
      color: "teal",
      view: "row",
      darkMode: false,
      searchHistory: [],
      meLiStatus: false,
      googleDriveStatus: false,
      statusMessage: '',
      showAgainStatusMessage: true,
    );
    String? firebaseToken = await firebaseMessagingNotifications();
    if (firebaseToken == "BLACKLISTED") return startPreferences;
    Response response = await HttpConnection.requestHandler(
        '/api/user/initialize/', {'token': firebaseToken});
    if (response.statusCode == 200) {
      startPreferences.userId = json.decode(response.body)['userId'];
      storedData.loadStartPreferences(startPreferences);
    }
    return startPreferences;
  }

  static Future<StartData> loadStartData() async {
    List<UserData> userPreferences = await storedData.loadUserData();
    if (userPreferences.isEmpty) {
      userPreferences = [await loadNewUserData()];
    } else if (userPreferences[0].statusMessage == null) {
      userPreferences = [
        UserData(
          id: userPreferences[0].id,
          userId: userPreferences[0].userId,
          color: userPreferences[0].color,
          view: userPreferences[0].view,
          darkMode: userPreferences[0].darkMode,
          searchHistory: userPreferences[0].searchHistory,
          meLiStatus: userPreferences[0].meLiStatus,
          googleDriveStatus: userPreferences[0].googleDriveStatus,
          statusMessage: '',
          showAgainStatusMessage: true,
        )
      ];
      storedData.loadStartPreferences(userPreferences[0]);
    }
    List<ItemTracking> activeTrackings = await storedData.loadActiveTrackings();
    List<ItemTracking> archTrackings = await storedData.loadArchivedTrackings();

    String userId = userPreferences[0].userId;
    MaterialColor startColor = ColorItem.load(userPreferences[0].color);
    String startView = userPreferences[0].view;
    bool startThemeDarkMode = userPreferences[0].darkMode;
    bool meliStatus = userPreferences[0].meLiStatus;
    bool driveStatus = userPreferences[0].googleDriveStatus;
    String statusMessage = userPreferences[0].statusMessage ?? '';
    bool showAgainStatusMessage =
        userPreferences[0].showAgainStatusMessage ?? true;

    List<String> searchHistory = [...userPreferences[0].searchHistory.reversed];

    List<ItemTracking> startActiveTrackings =
        activeTrackings.isEmpty ? [] : [...activeTrackings.reversed];

    List<ItemTracking> startArchivedTrackings =
        archTrackings.isEmpty ? [] : [...archTrackings.reversed];

    return StartData(
      userId,
      startColor,
      startView,
      startThemeDarkMode,
      meliStatus,
      driveStatus,
      statusMessage,
      showAgainStatusMessage,
      searchHistory,
      startActiveTrackings,
      startArchivedTrackings,
    );
  }
}

class StartData {
  String userId;
  MaterialColor startColor;
  String startView;
  bool darkMode;
  bool mercadoLibre;
  bool googleDrive;
  String? statusMessage;
  bool? showAgainStatusMessage;
  List<String> searchHistory;
  List<ItemTracking> activeTrackings;
  List<ItemTracking> archivedTrackings;
  StartData(
    this.userId,
    this.startColor,
    this.startView,
    this.darkMode,
    this.mercadoLibre,
    this.googleDrive,
    this.statusMessage,
    this.showAgainStatusMessage,
    this.searchHistory,
    this.activeTrackings,
    this.archivedTrackings,
  );
}
