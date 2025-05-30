class Tracking {
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
  List<Map<String, String>> events;
  List<Map<String, dynamic>>? moreData;
  String? lastEvent;
  String? lastCheck;
  String? startCheck;
  bool? checkError;
  bool? selected;
  bool? archived;

  ItemTracking({
    this.idSB,
    this.idMDB,
    this.title,
    required this.code,
    required this.service,
    required this.events,
    required this.moreData,
    this.lastEvent,
    this.lastCheck,
    this.startCheck,
    this.checkError,
    this.selected,
    this.archived,
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
      moreData: (map['moreData'] as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
      lastCheck: map['lastCheck'],
      startCheck: map['startCheck'],
      checkError: map['checkError'],
      selected: map['selected'],
      archived: map['archived'],
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
      'moreData': moreData,
      'lastCheck': lastCheck,
      'startCheck': startCheck,
      'checkError': checkError,
      'selected': selected,
      'archived': archived,
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
    List<Map<String, dynamic>>? moreData,
    String? lastCheck,
    String? startCheck,
    bool? search,
    bool? checkError,
    bool? selected,
    bool? archived,
  }) {
    return ItemTracking(
      idSB: id ?? idSB,
      idMDB: idMDB ?? this.idMDB,
      title: title ?? this.title,
      code: code ?? this.code,
      service: service ?? this.service,
      lastEvent: lastEvent ?? this.lastEvent,
      events: events ?? this.events,
      moreData: moreData ?? this.moreData,
      lastCheck: lastCheck ?? this.lastCheck,
      startCheck: startCheck ?? this.startCheck,
      checkError: checkError ?? this.checkError,
      selected: selected ?? this.selected,
      archived: archived ?? this.archived,
    );
  }
}

class UserData {
  int id;
  String userId;
  String color;
  String view;
  bool darkMode;
  List<String> searchHistory;
  bool meLiStatus;
  bool googleDriveStatus;
  String statusMessage;
  bool showAgainStatusMessage;
  bool? showAgainPaymentError;
  Map<String, dynamic>? servicesData;

  UserData({
    required this.id,
    required this.userId,
    required this.color,
    required this.view,
    required this.darkMode,
    required this.searchHistory,
    required this.meLiStatus,
    required this.googleDriveStatus,
    required this.statusMessage,
    required this.showAgainStatusMessage,
    required this.showAgainPaymentError,
    required this.servicesData,
  });

  factory UserData.fromMap(int id, Map<String, dynamic> map) {
    return UserData(
      id: id,
      userId: map['userId'],
      color: map['color'],
      view: map['view'],
      darkMode: map['darkMode'],
      searchHistory:
          (map['searchHistory'] as List).map((e) => e as String).toList(),
      meLiStatus: map['meLiStatus'],
      googleDriveStatus: map['googleDriveStatus'],
      statusMessage: map['statusMessage'] ?? '',
      showAgainStatusMessage: map['showAgainStatusMessage'] ?? true,
      showAgainPaymentError: map['showAgainPaymentError'] ?? true,
      servicesData: map['servicesData'] == null ? {} : map['servicesData'],
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
      'statusMessage': statusMessage,
      'showAgainStatusMessage': showAgainStatusMessage,
      'showAgainPaymentError': showAgainPaymentError,
      'servicesData': servicesData,
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
    String? statusMessage,
    bool? showAgainStatusMessage,
    bool? showAgainPaymentError,
    Map<String, dynamic>? servicesData,
  }) {
    return UserData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      color: color ?? this.color,
      view: view ?? this.view,
      darkMode: darkMode ?? this.darkMode,
      searchHistory: searchHistory ?? this.searchHistory,
      meLiStatus: meLiStatus ?? this.meLiStatus,
      googleDriveStatus: googleDriveStatus ?? this.googleDriveStatus,
      statusMessage: statusMessage ?? this.statusMessage,
      showAgainStatusMessage:
          showAgainStatusMessage ?? this.showAgainStatusMessage,
      showAgainPaymentError:
          showAgainPaymentError ?? this.showAgainPaymentError,
      servicesData: servicesData ?? this.servicesData,
    );
  }
}
