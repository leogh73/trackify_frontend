import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/classes.dart' as segs;
import '../providers/trackings_archived.dart';

import '../widgets/menu_actions.dart';
import '../widgets/list_select.dart';
import '../widgets/ad_banner.dart';

class Archived extends StatelessWidget {
  static const routeName = "/archived";
  const Archived({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bool selectionMode =
        Provider.of<ArchivedTrackings>(context).selectionModeStatus;
    final List<segs.ItemTracking> selection =
        Provider.of<ArchivedTrackings>(context).selectionElements;
    final List<segs.ItemTracking> tracking =
        Provider.of<ArchivedTrackings>(context).trackings;

    String _textSelection() {
      String text;
      text = '${selection.length}/${tracking.length}';
      return text;
    }

    return Scaffold(
      appBar: selectionMode
          ? AppBar(
              titleSpacing: 1.0,
              leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Provider.of<ArchivedTrackings>(context, listen: false)
                        .toggleSelectionMode();
                  }),
              title: Text(
                _textSelection(),
                style: const TextStyle(fontSize: 19),
              ),
              actions: <Widget>[
                if (selection.isNotEmpty)
                  ActionsMenu(
                    tracking: segs.ItemTracking(
                        idMDB: 'idMDB',
                        code: 'code',
                        service: 'service',
                        events: [],
                        otherData: [],
                        checkError: false),
                    screen: "archived",
                    menu: false,
                    detail: false,
                    action: "remove",
                    icon: 24,
                  ),
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: () {
                    Provider.of<ArchivedTrackings>(context, listen: false)
                        .selectAll();
                  },
                ),
              ],
            )
          : AppBar(
              titleSpacing: 1.0,
              title: const Text(
                'Archivados',
                style: TextStyle(fontSize: 19),
              ),
              actions: const <Widget>[],
            ),
      body: Center(
        child: TrackingList(selectionMode, tracking),
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}
