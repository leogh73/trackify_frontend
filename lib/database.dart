import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:http/http.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'data/classes.dart';
import 'data/http_connection.dart';

class AppDatabase {
  static Future<Database> get database async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'Sembast.db');
    return await databaseFactoryIo.openDatabase(dbPath);
  }
}

class StoredData {
  static Future<Database> get _db async => await AppDatabase.database;

  static const String userPreferences = "User Preferences";
  final _userPreferences = intMapStoreFactory.store(userPreferences);

  void loadStartPreferences(UserData preferences) async {
    _userPreferences.record(preferences.id).add(await _db, preferences.toMap());
  }

  void updatePreferences(UserData preferences) async {
    _userPreferences
        .record(preferences.id)
        .update(await _db, preferences.toMap());
  }

  Future<List<UserData>> loadUserData() async {
    final recordSnapshot = await _userPreferences.find(await _db);
    return recordSnapshot.map((snapshot) {
      return UserData.fromMap(snapshot.key, snapshot.value);
    }).toList();
  }

  static const String activeTrackings = "Main Trackings";
  var _activeTrackings = intMapStoreFactory.store(activeTrackings);

  void newMainTracking(ItemTracking newTracking) async {
    _activeTrackings
        .record(newTracking.idSB!)
        .add(await _db, newTracking.toMap());
  }

  void updateMainTracking(ItemTracking tracking) async {
    _activeTrackings.record(tracking.idSB!).update(await _db, tracking.toMap());
  }

  void removeMainTracking(ItemTracking tracking) async {
    _activeTrackings.record(tracking.idSB!).delete(await _db);
  }

  Future<List<ItemTracking>> loadActiveTrackings() async {
    final recordSnapshot = await _activeTrackings.find(await _db);
    return recordSnapshot.map((snapshot) {
      return ItemTracking.fromMap(snapshot.key, snapshot.value);
    }).toList();
  }

  static const String archivedTrackings = "Archived Trackings";
  var _archivedTrackings = intMapStoreFactory.store(archivedTrackings);

  void newArchivedTracking(ItemTracking newTracking) async {
    _archivedTrackings
        .record(newTracking.idSB!)
        .add(await _db, newTracking.toMap());
  }

  void updateArchivedTracking(ItemTracking tracking) async {
    _archivedTrackings
        .record(tracking.idSB!)
        .update(await _db, tracking.toMap());
  }

  void removeArchivedTracking(ItemTracking tracking) async {
    _archivedTrackings.record(tracking.idSB!).delete(await _db);
  }

  Future<List<ItemTracking>> loadArchivedTrackings() async {
    final recordSnapshot = await _archivedTrackings.find(await _db);
    return recordSnapshot.map((snapshot) {
      return ItemTracking.fromMap(snapshot.key, snapshot.value);
    }).toList();
  }

  Future<Map<String, dynamic>> userBackupData() async {
    final userPreferencesSnapshot = await _userPreferences.find(await _db);
    final activeTrackingsSnapshot = await _activeTrackings.find(await _db);
    final archivedTrackingsSnapshot = await _archivedTrackings.find(await _db);
    var now =
        tz.TZDateTime.now(tz.getLocation("America/Argentina/Buenos_Aires"));
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final Map<String, dynamic> backupData = {
      "date":
          "${now.day.toString().padLeft(2, "0")}/${now.month.toString().padLeft(2, "0")}/${now.year}",
      "time":
          "${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}",
      "preferences": userPreferencesSnapshot[0].value,
      "activeTrackings": activeTrackingsSnapshot.map((t) => t.value).toList(),
      "archivedTrackings":
          archivedTrackingsSnapshot.map((t) => t.value).toList(),
      "deviceModel": androidInfo.model,
    };
    return backupData;
  }

  Future<void> dropDatabase() async {
    await _userPreferences.drop(await _db);
    await _activeTrackings.drop(await _db);
    await _archivedTrackings.drop(await _db);
  }

  Future<void> reCreate() async {
    await _activeTrackings.drop(await _db);
    await _archivedTrackings.drop(await _db);
    _activeTrackings = intMapStoreFactory.store(activeTrackings);
    _archivedTrackings = intMapStoreFactory.store(archivedTrackings);
  }

  Future<void> restoreBackupData(BuildContext context, String backupId) async {
    UserData userPreferences = [...await StoredData().loadUserData()][0];
    String userId = userPreferences.userId;
    Object body = {
      'userId': userId,
      'backupId': backupId,
    };
    Response response =
        await HttpConnection.requestHandler('/api/googledrive/restore/', body);
    Map<String, dynamic> backupData =
        HttpConnection.responseHandler(response, context);
    if (backupData['serverError'] != null) return;
    await reCreate();
    UserData backupPreferences = UserData.fromMap(
        backupData['preferences']['id'],
        backupData['preferences'] as Map<String, dynamic>);
    UserData newUserData = backupPreferences.edit(
      id: userPreferences.id,
      userId: userPreferences.userId,
    );
    StoredData().updatePreferences(newUserData);
    List<ItemTracking> activeTrackings =
        (backupData['activeTrackings'] as List<dynamic>)
            .map((t) => ItemTracking.fromMap(t['idSB'], t))
            .toList();
    for (ItemTracking tracking in activeTrackings) {
      StoredData().newMainTracking(tracking);
    }
    List<ItemTracking> archivedTrackings =
        (backupData['archivedTrackings'] as List<dynamic>)
            .map((t) => ItemTracking.fromMap(t['idSB'], t))
            .toList();
    for (ItemTracking tracking in archivedTrackings) {
      StoredData().newArchivedTracking(tracking);
    }
  }
}
