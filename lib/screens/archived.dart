import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/classes.dart';
import '../providers/trackings_archived.dart';

import '../widgets/options_tracking.dart';
import '../widgets/tracking.list.dart';
import '../widgets/ad_banner.dart';

class Archived extends StatelessWidget {
  const Archived({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bool selectionMode =
        Provider.of<ArchivedTrackings>(context).selectionModeStatus;
    final List<ItemTracking> selection =
        Provider.of<ArchivedTrackings>(context).selectionElements;
    final List<ItemTracking> trackings =
        Provider.of<ArchivedTrackings>(context).trackings;
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
                '${selection.length}/${trackings.length}',
                style: const TextStyle(fontSize: 19),
              ),
              actions: <Widget>[
                if (selection.isNotEmpty)
                  OptionsTracking(
                    tracking: ItemTracking(
                      code: '',
                      service: '',
                      events: [],
                      moreData: [],
                      archived: true,
                    ),
                    menu: false,
                    action: 'remove',
                    detail: false,
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
        child: TrackingList(trackings),
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}
