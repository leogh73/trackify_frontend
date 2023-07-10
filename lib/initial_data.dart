import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:trackify/providers/http_request_handler.dart';
import 'package:http/http.dart' as http;

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

  static Future<UserPreferences> _loadNewUserData() async {
    String? firebaseToken = await firebaseMessagingNotifications();
    String userId = '';
    Object body = {
      'token': firebaseToken,
    };
    dynamic response =
        await HttpRequestHandler.newRequest('/api/user/initialize/', body);
    if (response is http.Response)
      userId = json.decode(response.body)['userId'];
    print("USERID_$userId");
    UserPreferences startPreferences = UserPreferences(
      id: 0,
      userId: userId,
      color: "teal",
      view: "row",
      darkMode: false,
      searchHistory: [],
      meLiStatus: false,
      googleDriveStatus: false,
    );
    if (userId.isNotEmpty) storedData.loadStartPreferences(startPreferences);
    return startPreferences;
  }

  static Future<StartData> loadStartData() async {
    List<UserPreferences> userPreferences =
        await storedData.loadUserPreferences();
    if (userPreferences.isEmpty) {
      userPreferences = [await _loadNewUserData()];
    }
    List<ItemTracking> activeTrackings = await storedData.loadActiveTrackings();
    List<ItemTracking> archTrackings = await storedData.loadArchivedTrackings();

    String userId = userPreferences[0].userId;
    MaterialColor startColor = ColorItem.load(userPreferences[0].color);
    String startView = userPreferences[0].view;
    bool startThemeDarkMode = userPreferences[0].darkMode;
    bool meliStatus = userPreferences[0].meLiStatus;
    bool driveStatus = userPreferences[0].googleDriveStatus;
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
    this.searchHistory,
    this.activeTrackings,
    this.archivedTrackings,
  );
}
