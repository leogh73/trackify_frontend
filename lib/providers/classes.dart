import 'package:flutter/material.dart';

class Tracking with ChangeNotifier {
  final int id;
  String title;
  final String code;
  final String service;

  Tracking({
    required this.id,
    required this.title,
    required this.code,
    required this.service,
  });
}

class ItemTracking {
  int? idSB;
  String? idMDB;
  String? title;
  String code;
  String service;
  String? lastEvent;
  List<Map<String, String>>? events;
  List<List<String>>? otherData;
  String? lastCheck;
  String? startCheck;
  bool? search;
  bool? checkError;
  bool? selected;
  bool? archived;
  bool? fake;

  ItemTracking({
    this.idSB,
    this.idMDB,
    this.title,
    required this.code,
    required this.service,
    this.lastEvent,
    this.events,
    this.otherData,
    this.lastCheck,
    this.startCheck,
    this.search,
    this.checkError,
    this.selected,
    this.archived,
    this.fake,
  });

  factory ItemTracking.fromMap(int id, Map<String, dynamic> map) {
    return ItemTracking(
      idSB: id,
      idMDB: map['idMDB'],
      title: map['title'],
      code: map['code'],
      service: map['service'],
      lastEvent: map['lastEvent'],
      events: (map['events'] as List)
          .map((e) => Map<String, String>.from(e))
          .toList(),
      otherData: (map['otherData'] as List)
          .map((e) => (e as List).map((e) => e as String).toList())
          .toList(),
      lastCheck: map['lastCheck'],
      startCheck: map['startCheck'],
      search: map['search'],
      checkError: map['checkError'],
      selected: map['selected'],
      archived: map['archived'],
      fake: map['fake'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idSB': idSB,
      'idMDB': idMDB,
      'title': title,
      'code': code,
      'service': service,
      'lastEvent': lastEvent,
      'events': events,
      'otherData': otherData,
      'lastCheck': lastCheck,
      'startCheck': startCheck,
      'search': search,
      'checkError': checkError,
      'selected': selected,
      'archived': archived,
      'fake': fake,
    };
  }

  edit({
    int? id,
    String? idMDB,
    String? title,
    String? code,
    String? service,
    String? lastEvent,
    List<Map<String, String>>? events,
    List<List<String>>? otherData,
    String? lastCheck,
    String? startCheck,
    bool? search,
    bool? checkError,
    bool? selected,
    bool? archived,
    bool? fake,
  }) {
    return ItemTracking(
      idSB: id ?? idSB,
      idMDB: idMDB ?? this.idMDB,
      title: title ?? this.title,
      code: code ?? this.code,
      service: service ?? this.service,
      lastEvent: lastEvent ?? this.lastEvent,
      events: events ?? this.events,
      otherData: otherData ?? this.otherData,
      lastCheck: lastCheck ?? this.lastCheck,
      startCheck: startCheck ?? this.startCheck,
      search: search ?? this.search,
      checkError: checkError ?? this.checkError,
      selected: selected ?? this.selected,
      archived: archived ?? this.archived,
      fake: fake ?? this.fake,
    );
  }
}

class UserPreferences {
  int id;
  String userId;
  String color;
  String view;
  bool darkMode;
  List<String> searchHistory;
  bool meLiStatus;
  bool googleDriveStatus;

  UserPreferences({
    required this.id,
    required this.userId,
    required this.color,
    required this.view,
    required this.darkMode,
    required this.searchHistory,
    required this.meLiStatus,
    required this.googleDriveStatus,
  });

  factory UserPreferences.fromMap(int id, Map<String, dynamic> map) {
    return UserPreferences(
      id: id,
      userId: map['userId'],
      color: map['color'],
      view: map['view'],
      darkMode: map['darkMode'],
      searchHistory:
          (map['searchHistory'] as List).map((e) => e as String).toList(),
      meLiStatus: map['meLiStatus'],
      googleDriveStatus: map['googleDriveStatus'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'color': color,
      'view': view,
      'darkMode': darkMode,
      'searchHistory': searchHistory,
      'meLiStatus': meLiStatus,
      'googleDriveStatus': googleDriveStatus,
    };
  }

  edit({
    int? id,
    String? userId,
    String? color,
    String? view,
    bool? darkMode,
    List<String>? searchHistory,
    bool? meLiStatus,
    bool? googleDriveStatus,
  }) {
    return UserPreferences(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      color: color ?? this.color,
      view: view ?? this.view,
      darkMode: darkMode ?? this.darkMode,
      searchHistory: searchHistory ?? this.searchHistory,
      meLiStatus: meLiStatus ?? this.meLiStatus,
      googleDriveStatus: googleDriveStatus ?? this.googleDriveStatus,
    );
  }
}

class ColorItem {
  static load(String color) {
    if (color == "teal") return Colors.teal;
    if (color == "indigo") return Colors.indigo;
    if (color == "green") return Colors.green;
    if (color == "pink") return Colors.pink;
    if (color == "blue") return Colors.blue;
    if (color == "red") return Colors.red;
    if (color == "purple") return Colors.purple;
    if (color == "deepOrange") return Colors.deepOrange;
    if (color == "deepPurple") return Colors.deepPurple;
    if (color == "blueGrey") return Colors.blueGrey;
    if (color == "amber") return Colors.amber;
    if (color == "lime") return Colors.lime;
    if (color == "cyan") return Colors.cyan;
    if (color == "yellow") return Colors.yellow;
    if (color == "grey") return Colors.grey;
    if (color == "lightBlue") return Colors.lightBlue;
  }

  static store(MaterialColor color) {
    if (color == Colors.teal) return "teal";
    if (color == Colors.indigo) return "indigo";
    if (color == Colors.green) return 'green';
    if (color == Colors.pink) return 'pink';
    if (color == Colors.blue) return 'blue';
    if (color == Colors.red) return 'red';
    if (color == Colors.purple) return 'purple';
    if (color == Colors.deepOrange) return 'deepOrange';
    if (color == Colors.deepPurple) return 'deepPurple';
    if (color == Colors.blueGrey) return 'blueGrey';
    if (color == Colors.amber) return 'amber';
    if (color == Colors.lime) return 'lime';
    if (color == Colors.cyan) return 'cyan';
    if (color == Colors.yellow) return 'yellow';
    if (color == Colors.grey) return 'grey';
    if (color == Colors.lightBlue) return 'lightBlue';
  }
}
