import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'data/http_connection.dart';
import 'data/classes.dart';
import 'data/theme.dart';
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
    final String defaultLocale = Platform.localeName.split("_")[0];
    final Map<String, String> languages = {"en": "english", "es": "español"};
    final UserData startPreferences = UserData(
      id: 0,
      userId: '',
      language: languages[defaultLocale] ?? "english",
      color: "teal",
      view: "row",
      sortTrackingsBy: 205,
      darkMode: false,
      meLiStatus: false,
      lastSync: DateTime.now().toString(),
      googleDriveStatus: false,
      showAgainPaymentError: true,
      servicesData: {},
    );
    final String? firebaseToken = await firebaseMessagingNotifications();
    if (firebaseToken == "BLACKLISTED") return startPreferences;
    Response response = await HttpConnection.requestHandler(
        '/api/user/initialize/', {'token': firebaseToken});
    if (response.statusCode == 200) {
      startPreferences.userId = json.decode(response.body)['userId'];
      startPreferences.servicesData =
          json.decode(response.body)['servicesData'];
      storedData.loadStartPreferences(startPreferences);
    }
    return startPreferences;
  }

  static Future<Map<String, dynamic>> startUserCheck(String userId) async {
    final Response response = await HttpConnection.requestHandler(
        '/api/user/initialize/', {'userId': userId});
    Map<String, dynamic> paymentData = {'isValid': false};
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['mercadoPagoData'] != null) {
        paymentData = responseData["mercadoPagoData"];
      }
      if (responseData['paypalData'] != null) {
        paymentData = responseData["paypalData"];
      }
    }
    return paymentData;
  }

  static String setSyncDate(UserData userPreferences) {
    final String newDate = DateTime.now().toString();
    final UserData newPreferences = userPreferences.edit(lastSync: newDate);
    storedData.updatePreferences(newPreferences);
    return newDate;
  }

  static Future<StartData> loadStartData() async {
    List<UserData> userPreferences = await storedData.loadUserData();
    if (userPreferences.isEmpty) {
      userPreferences = [await loadNewUserData()];
    }

    List<ItemTracking> activeTrackings = await storedData.loadActiveTrackings();
    List<ItemTracking> archivedTrackings =
        await storedData.loadArchivedTrackings();

    String userId = userPreferences[0].userId;
    String language = userPreferences[0].language;
    MaterialColor startColor = UserTheme.getColor[userPreferences[0].color]!;
    String startView = userPreferences[0].view;
    int sortTrackingsBy = userPreferences[0].sortTrackingsBy;
    bool startThemeDarkMode = userPreferences[0].darkMode;
    bool meliStatus = userPreferences[0].meLiStatus;
    String lastSyncDate =
        userPreferences[0].lastSync ?? setSyncDate([...userPreferences][0]);
    bool driveStatus = userPreferences[0].googleDriveStatus;
    bool showAgainPaymentError = userPreferences[0].showAgainPaymentError!;
    Map<String, dynamic> servicesData = userPreferences[0].servicesData ?? {};

    Map<String, dynamic> paymentData = userPreferences.isEmpty
        ? {'isValid': false}
        : await startUserCheck(userId);

    List<ItemTracking> startActiveTrackings =
        activeTrackings.isEmpty ? [] : [...activeTrackings.reversed];

    List<ItemTracking> startArchivedTrackings =
        archivedTrackings.isEmpty ? [] : [...archivedTrackings.reversed];

    return StartData(
      userId,
      language,
      startColor,
      startView,
      sortTrackingsBy,
      startThemeDarkMode,
      meliStatus,
      driveStatus,
      showAgainPaymentError,
      servicesData,
      paymentData,
      startActiveTrackings,
      startArchivedTrackings,
      lastSyncDate,
    );
  }
}

class StartData {
  String userId;
  String language;
  MaterialColor startColor;
  String startView;
  int sortTrackingsBy;
  bool darkMode;
  bool mercadoLibre;
  bool googleDrive;
  bool showAgainPaymentError;
  Map<String, dynamic> servicesData;
  Map<String, dynamic> paymentData;
  List<ItemTracking> activeTrackings;
  List<ItemTracking> archivedTrackings;
  String lastSyncDate;
  StartData(
    this.userId,
    this.language,
    this.startColor,
    this.startView,
    this.sortTrackingsBy,
    this.darkMode,
    this.mercadoLibre,
    this.googleDrive,
    this.showAgainPaymentError,
    this.servicesData,
    this.paymentData,
    this.activeTrackings,
    this.archivedTrackings,
    this.lastSyncDate,
  );
}
