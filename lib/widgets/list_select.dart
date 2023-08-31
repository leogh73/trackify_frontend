import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/widgets/ad_native.dart';

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
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Padding(
              child: AdNative("medium"),
              padding: EdgeInsets.only(top: 8, bottom: 50),
            ),
            Icon(Icons.local_shipping_outlined, size: 80),
            SizedBox(width: 30, height: 30),
            Text(
              'No hay seguimientos',
              style: TextStyle(fontSize: 24),
            ),
            Padding(
              child: AdNative("medium"),
              padding: EdgeInsets.only(top: 50, bottom: 8),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
