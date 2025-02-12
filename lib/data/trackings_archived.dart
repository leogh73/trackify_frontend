import 'package:flutter/material.dart';

import './classes.dart';
import '../database.dart';
import '../initial_data.dart';

class ArchivedTrackings with ChangeNotifier {
  StoredData storedData = StoredData();

  late List<ItemTracking> _trackings;

  ArchivedTrackings(StartData startData) {
    _trackings = [...startData.archivedTrackings];
  }

  List<ItemTracking> get trackings => [..._trackings];

  void addTracking(ItemTracking tracking) {
    storedData.newArchivedTracking(tracking);
    _trackings.insert(0, tracking);
    notifyListeners();
  }

  void removeTracking(
      List<ItemTracking> trackings, BuildContext? context, bool startError) {
    for (ItemTracking tracking in trackings) {
      storedData.removeArchivedTracking(tracking);
      _trackings.remove(tracking);
    }
    notifyListeners();
  }

  void renameTracking(Tracking tracking) async {
    int index = _trackings.indexWhere((seg) => seg.idSB == tracking.id);
    _trackings[index].title = tracking.title;
    if (tracking.title.isEmpty) {
      _trackings[index].title = _trackings[index].code;
    }
    storedData.updateArchivedTracking(_trackings[index]);
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

  void addSelected(ItemTracking tracking) {
    _selection.add(tracking);
    notifyListeners();
  }

  void removeSelected(int idRemove) {
    _selection.removeWhere((tracking) => tracking.idSB == idRemove);
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
