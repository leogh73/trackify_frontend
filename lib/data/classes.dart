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
  String language;
  String color;
  String view;
  int sortTrackingsBy;
  bool darkMode;
  bool meLiStatus;
  String? lastSync;
  bool googleDriveStatus;
  Map<String, dynamic>? servicesData;
  bool? showAgainPaymentError;

  UserData({
    required this.id,
    required this.userId,
    required this.language,
    required this.color,
    required this.view,
    required this.sortTrackingsBy,
    required this.darkMode,
    required this.meLiStatus,
    required this.lastSync,
    required this.googleDriveStatus,
    required this.servicesData,
    required this.showAgainPaymentError,
  });

  factory UserData.fromMap(int id, Map<String, dynamic> map) {
    return UserData(
      id: id,
      userId: map['userId'],
      language: map['language'] ?? "español",
      color: map['color'],
      view: map['view'],
      sortTrackingsBy: map['sortTrackingsBy'] ?? 205,
      darkMode: map['darkMode'],
      meLiStatus: map['meLiStatus'],
      lastSync: map['lastSync'],
      googleDriveStatus: map['googleDriveStatus'],
      servicesData: map['servicesData'] ?? {},
      showAgainPaymentError: map['showAgainPaymentError'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'language': language,
      'color': color,
      'view': view,
      'sortTrackingsBy': sortTrackingsBy,
      'darkMode': darkMode,
      'meLiStatus': meLiStatus,
      'lastSync': lastSync,
      'googleDriveStatus': googleDriveStatus,
      'servicesData': servicesData,
      'showAgainPaymentError': showAgainPaymentError,
    };
  }

  edit({
    int? id,
    String? userId,
    String? language,
    String? color,
    String? view,
    int? sortTrackingsBy,
    bool? darkMode,
    bool? meLiStatus,
    String? lastSync,
    bool? googleDriveStatus,
    Map<String, dynamic>? servicesData,
    bool? showAgainPaymentError,
  }) {
    return UserData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      language: language ?? this.language,
      color: color ?? this.color,
      view: view ?? this.view,
      sortTrackingsBy: sortTrackingsBy ?? this.sortTrackingsBy,
      darkMode: darkMode ?? this.darkMode,
      meLiStatus: meLiStatus ?? this.meLiStatus,
      lastSync: lastSync ?? this.lastSync,
      googleDriveStatus: googleDriveStatus ?? this.googleDriveStatus,
      servicesData: servicesData ?? this.servicesData,
      showAgainPaymentError:
          showAgainPaymentError ?? this.showAgainPaymentError,
    );
  }
}
