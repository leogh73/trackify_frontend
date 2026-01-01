import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/screens/search.dart';

import '../data/classes.dart';
import '../data/../data/preferences.dart';
import '../data/trackings_archived.dart';

import '../widgets/tracking_options.dart';
import '../widgets/tracking_list.dart';
import '../widgets/ad_banner.dart';

class Archived extends StatelessWidget {
  const Archived({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final bool selectionMode = context.select(
        (ArchivedTrackings archivedTrackings) =>
            archivedTrackings.selectionMode);
    final List<ItemTracking> selection = context.select(
        (ArchivedTrackings archivedTrackings) =>
            archivedTrackings.selectionElements);
    final List<ItemTracking> trackingsList =
        context.watch<ArchivedTrackings>().trackings;
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
                '${selection.length}/${trackingsList.length}',
                style: const TextStyle(fontSize: 19),
              ),
              actions: <Widget>[
                if (selection.isNotEmpty)
                  TrackingOptions(
                    tracking: ItemTracking(
                      code: '',
                      service: '',
                      events: [],
                      moreData: [],
                      archived: true,
                    ),
                    option: "iconButtons",
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
              title: Text(
                texts[8]!,
                style: const TextStyle(fontSize: 19),
              ),
              actions: <Widget>[
                IconButton(
                  tooltip: texts[6],
                  icon: const Icon(Icons.search),
                  iconSize: 27,
                  onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const Search("archived"),
                      ),
                    ),
                  },
                ),
              ],
            ),
      body: Center(
        child: TrackingList(trackingsList),
      ),
      bottomNavigationBar: premiumUser ? null : const AdBanner(),
    );
  }
}
