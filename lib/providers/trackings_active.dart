import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:trackify/providers/http_request_handler.dart';
import 'package:trackify/providers/preferences.dart';
import 'package:trackify/widgets/dialog_and_toast.dart';

import '../database.dart';
import '../initial_data.dart';

import '../widgets/data_response.dart';

import 'classes.dart';

class ActiveTrackings extends ChangeNotifier {
  StoredData storedData = StoredData();
  late List<ItemTracking> _trackings;

  ActiveTrackings(StartData startData) {
    _trackings = [...startData.activeTrackings];
  }

  List<ItemTracking> get trackings => [..._trackings];

  void addTracking(Tracking tracking) async {
    if (tracking.title.isEmpty) {
      tracking.title = tracking.code;
    }

    ItemTracking newTracking = ItemTracking(
      idSB: tracking.id,
      idMDB: null,
      title: tracking.title,
      code: tracking.code,
      service: tracking.service,
      search: false,
      checkError: null,
      selected: false,
      archived: false,
    );
    _trackings.insert(0, newTracking);

    notifyListeners();
  }

  void loadStartData(ItemTracking tracking, ItemResponseData itemData) {
    int trackingIndex =
        _trackings.indexWhere((element) => element.idSB == tracking.idSB);
    _trackings[trackingIndex].events = itemData.events!;
    _trackings[trackingIndex].otherData =
        itemData.otherData?.cast<List<String>>();
    _trackings[trackingIndex].lastEvent = itemData.lastEvent;
    String dateAndTime = '${itemData.checkDate} - ${itemData.checkTime}';
    _trackings[trackingIndex].startCheck = dateAndTime;
    _trackings[trackingIndex].lastCheck = dateAndTime;
    _trackings[trackingIndex].checkError = false;
    _trackings[trackingIndex].idMDB = itemData.trackingId!;
    storedData.newMainTracking(_trackings[trackingIndex]);
  }

  void retryErrorTracking(int trackingId) {
    int trackingIndex = _trackings.indexWhere((t) => t.idSB == trackingId);
    _trackings[trackingIndex].checkError = null;
    notifyListeners();
  }

  void removeTracking(List<ItemTracking> trackingList, BuildContext context,
      bool startError) async {
    List<String> trackingIds = [];
    for (var tracking in trackingList) {
      _trackings.remove(tracking);
      if (!tracking.checkError!) {
        storedData.removeMainTracking(tracking);
        trackingIds.add(tracking.idMDB!);
      }
    }
    notifyListeners();
    if (startError) return;
    String _userId = Provider.of<Preferences>(context, listen: false).userId;
    Object body = {'trackingIds': json.encode(trackingIds)};
    dynamic response =
        await HttpRequestHandler.newRequest('/api/user/$_userId/remove/', body);
    if (response is Map) ShowDialog(context).connectionServerError(false);
  }

  void editTracking(ItemTracking tracking) {
    int index = _trackings.indexWhere((seg) => seg.idSB == tracking.idSB);
    _trackings[index].code = tracking.code;
    _trackings[index].service = tracking.service;
    _trackings[index].title = tracking.title;
    if (tracking.title == null) {
      _trackings[index].title = _trackings[index].code;
    }
    storedData.updateMainTracking(_trackings[index]);
    notifyListeners();
  }

  late ItemTracking _loadedTracking;
  ItemTracking get loadedTracking => _loadedTracking;

  void loadCurrentTracking(ItemTracking tracking) {
    _loadedTracking = tracking;
    notifyListeners();
  }

  bool selectionMode = false;
  bool get selectionModeStatus => selectionMode;

  void toggleSelectionMode() {
    selectionMode = !selectionMode;
    if (selectionMode == false) {
      for (var element in _trackings) {
        element.selected = false;
      }
      _selection.clear();
    }
    notifyListeners();
  }

  List<ItemTracking> _selection = [];
  List<ItemTracking> get selectionElements => [..._selection];

  late int startSelection;
  int get activatedSelection => startSelection;

  void activateStartSelection(ItemTracking tracking) {
    startSelection = tracking.idSB!;
    addSelected(tracking);
  }

  void addSelected(ItemTracking tracking) {
    _selection.add(tracking);
    notifyListeners();
  }

  void removeSelected(int idEliminar) {
    _selection.removeWhere((tracking) => tracking.idSB == idEliminar);
    notifyListeners();
  }

  void selectAll() {
    if (_selection.length < _trackings.length) {
      _selection.clear();
      for (var tracking in _trackings) {
        tracking.selected = true;
      }
      _selection = [..._trackings];
    } else {
      for (var tracking in _trackings) {
        tracking.selected = false;
      }
      _selection.clear();
    }
    notifyListeners();
  }

  void removeSelection(BuildContext context) {
    removeTracking(_selection, context, false);
    _selection.clear();
    notifyListeners();
  }
}
