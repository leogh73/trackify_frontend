import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:flutter/foundation.dart';
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
    String url = "${dotenv.env['API_URL']}/api/user/initialize/";
    String? firebaseToken = await firebaseMessagingNotifications();
    var response = await http.Client().post(Uri.parse(url), body: {
      'token': firebaseToken,
    });
    String userId = json.decode(response.body)['userId'];
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
    storedData.loadStartPreferences(startPreferences);
    return startPreferences;
  }

  static Future<StartData> loadStartData() async {
    List<UserPreferences> _userPreferences =
        await storedData.loadUserPreferences();
    if (_userPreferences.isEmpty) {
      _userPreferences = [await _loadNewUserData()];
    }
    List<ItemTracking> _activeTrackings =
        await storedData.loadActiveTrackings();
    List<ItemTracking> _archTrackings =
        await storedData.loadArchivedTrackings();

    String _userId = _userPreferences[0].userId;
    MaterialColor _startColor = ColorItem.load(_userPreferences[0].color);
    String _startView = _userPreferences[0].view;
    bool _startThemeDarkMode = _userPreferences[0].darkMode;
    bool _meliStatus = _userPreferences[0].meLiStatus;
    bool _driveStatus = _userPreferences[0].googleDriveStatus;
    List<String> _searchHistory = [
      ..._userPreferences[0].searchHistory.reversed
    ];

    List<ItemTracking> _startActiveTrackings =
        _activeTrackings.isEmpty ? [] : [..._activeTrackings.reversed];

    List<ItemTracking> _startArchivedTrackings =
        _archTrackings.isEmpty ? [] : [..._archTrackings.reversed];

    return StartData(
      _userId,
      _startColor,
      _startView,
      _startThemeDarkMode,
      _meliStatus,
      _driveStatus,
      _searchHistory,
      _startActiveTrackings,
      _startArchivedTrackings,
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
