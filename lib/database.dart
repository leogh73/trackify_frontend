import 'dart:async';
import 'dart:convert';

import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/standalone.dart' as tz;

import 'providers/classes.dart';

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

  void loadStartPreferences(UserPreferences preferences) async {
    _userPreferences.record(preferences.id).add(await _db, preferences.toMap());
  }

  void updatePreferences(UserPreferences preferences) async {
    _userPreferences
        .record(preferences.id)
        .update(await _db, preferences.toMap());
  }

  Future<List<UserPreferences>> loadUserPreferences() async {
    final recordSnapshot = await _userPreferences.find(await _db);
    return recordSnapshot.map((snapshot) {
      return UserPreferences.fromMap(snapshot.key, snapshot.value);
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
    final Map<String, dynamic> backupData = {
      "date":
          "${now.day.toString().padLeft(2, "0")}/${now.month.toString().padLeft(2, "0")}/${now.year}",
      "time":
          "${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}",
      "preferences": userPreferencesSnapshot[0].value,
      "activeTrackings": activeTrackingsSnapshot.map((t) => t.value).toList(),
      "archivedTrackings":
          archivedTrackingsSnapshot.map((t) => t.value).toList(),
    };
    return backupData;
  }

  Future<void> reCreate() async {
    await _activeTrackings.drop(await _db);
    await _archivedTrackings.drop(await _db);
    _activeTrackings = intMapStoreFactory.store(activeTrackings);
    _archivedTrackings = intMapStoreFactory.store(archivedTrackings);
  }

  Future<void> restoreBackupData(String backupId) async {
    await reCreate();
    UserPreferences userPreferences =
        [...await StoredData().loadUserPreferences()][0];
    String userId = userPreferences.userId;
    var response = await http.Client()
        .post(Uri.parse("${dotenv.env['API_URL']}/api/google/restore/"), body: {
      'userId': userId,
      'backupId': backupId,
    });
    Map<String, dynamic>? backupData = json.decode(response.body);
    UserPreferences backupPreferences = UserPreferences.fromMap(
        backupData?['preferences']['id'],
        backupData?['preferences'] as Map<String, dynamic>);
    UserPreferences newUserPreferences = backupPreferences.edit(
      id: userPreferences.id,
      userId: userPreferences.userId,
    );
    StoredData().updatePreferences(newUserPreferences);
    List<ItemTracking> activeTrackings =
        (backupData?['activeTrackings'] as List<dynamic>)
            .map((t) => ItemTracking.fromMap(t['idSB'], t))
            .toList();
    for (ItemTracking tracking in activeTrackings) {
      StoredData().newMainTracking(tracking);
    }
    List<ItemTracking> archivedTrackings =
        (backupData?['archivedTrackings'] as List<dynamic>)
            .map((t) => ItemTracking.fromMap(t['idSB'], t))
            .toList();
    for (ItemTracking tracking in archivedTrackings) {
      StoredData().newArchivedTracking(tracking);
    }
  }
}
