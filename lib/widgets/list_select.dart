import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/preferences.dart';
import '../providers/classes.dart';

import 'list_view_row.dart';
import 'list_view_card.dart';
import 'list_view_grid.dart';

class TrackingList extends StatelessWidget {
  final bool selectionMode;
  final List<ItemTracking> trackingsData;
  const TrackingList(this.selectionMode, this.trackingsData, {Key? key})
      : super(key: key);
  Widget sinSeguimientos() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.local_shipping_outlined, size: 80),
          SizedBox(width: 40, height: 40),
          Text(
            'No hay seguimientos',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }

  // selectionarOrigen(String listScreen, context) {
  //   if (listScreen == "main") {
  //     return Provider.of<ActiveTrackings>(context);
  //   } else if (listScreen == "archived") {
  //     return Provider.of<ArchivedTrackings>(context);
  //   } else if (listScreen == "eliminados") {
  //     return Provider.of<SeguimientosEliminados>(context);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final listScreen = Provider.of<Seguimientos>(context).listaPantalla;
    // final trackingsData =
    //     selectionarOrigen(listScreen, context).seguimientos;
    // final selectionMode =
    //     selectionarOrigen(listScreen, context).estadoModoSelection;
    final Map<String, Widget> lists = {
      "row": ListRow(selectionMode, trackingsData),
      "card": ListCard(selectionMode, trackingsData),
      "grid": ListGrid(selectionMode, trackingsData),
      "empty": sinSeguimientos()
    };
    var startListType = Provider.of<Preferences>(context).startList;
    if (trackingsData.isEmpty) {
      startListType = "empty";
    }
    return Scaffold(
      body: lists[startListType],
    );
  }
}

class WidgetList {
  final Widget widgetList;
  final String listType;
  WidgetList(
    this.widgetList,
    this.listType,
  );
}
