import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/classes.dart';
import '../providers/trackings_active.dart';
import '../providers/status.dart';
import '../providers/preferences.dart';
import '../providers/tracking_functions.dart';

import '../screens/form_add_edit.dart';
import '../screens/search.dart';

import '../widgets/ad_banner.dart';
import '../widgets/ad_native.dart';
import '../widgets/dialog_error.dart';
import '../widgets/drawer.dart';
import '../widgets/tracking.list.dart';
import '../widgets/options_style.dart';
import '../widgets/options_tracking.dart';

class MainScreen extends StatefulWidget {
  final String userId;
  const MainScreen(this.userId, {Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        TrackingFunctions.syncronizeUserData(context);
        final String error =
            Provider.of<Status>(context, listen: false).getStartError;
        if (error.isNotEmpty) {
          return DialogError.startError(context, error);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String error = Provider.of<Status>(context).getStartError;
    final String userId =
        Provider.of<UserPreferences>(context, listen: false).userId;
    final bool selectionMode =
        Provider.of<ActiveTrackings>(context).selectionModeStatus;
    final bool endOfList = Provider.of<Status>(context).endOfList;
    final List<ItemTracking> selection =
        Provider.of<ActiveTrackings>(context).selectionElements;
    final List<ItemTracking> trackings =
        Provider.of<ActiveTrackings>(context).trackings;
    final ItemTracking sampleTracking = ItemTracking(
      code: '',
      service: '',
      events: [],
      moreData: [],
      archived: false,
    );
    return Scaffold(
      drawer: error.isEmpty && userId.isNotEmpty ? DrawerWidget() : null,
      appBar: selectionMode
          ? AppBar(
              titleSpacing: 1.0,
              leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Provider.of<ActiveTrackings>(context, listen: false)
                        .toggleSelectionMode();
                  }),
              title: Text(
                '${selection.length}/${trackings.length}',
                style: const TextStyle(fontSize: 19),
              ),
              actions: [
                if (selection.isNotEmpty) ...[
                  OptionsTracking(
                    tracking: sampleTracking,
                    menu: false,
                    action: 'archive',
                    detail: false,
                  ),
                  OptionsTracking(
                    tracking: sampleTracking,
                    menu: false,
                    action: 'remove',
                    detail: false,
                  ),
                ],
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: () {
                    Provider.of<ActiveTrackings>(context, listen: false)
                        .selectAll();
                  },
                ),
              ],
            )
          : AppBar(
              titleSpacing: 1.0,
              title: const Text(
                'Seguimientos',
                style: TextStyle(fontSize: 19),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search),
                  iconSize: 20,
                  onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const Search(),
                      ),
                    ),
                  },
                ),
                const OptionsStyle(),
              ],
            ),
      body: Center(
        child: error.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        child: AdNative("medium"),
                        padding: EdgeInsets.only(top: 8, bottom: 50)),
                    Icon(Icons.error, size: 80),
                    SizedBox(width: 30, height: 30),
                    Text(
                      'ERROR',
                      style: TextStyle(fontSize: 24),
                    ),
                    Padding(
                        child: AdNative("medium"),
                        padding: EdgeInsets.only(top: 50, bottom: 8)),
                  ],
                ),
              )
            : TrackingList(trackings),
      ),
      floatingActionButton:
          selectionMode || endOfList || error.isNotEmpty || userId.isEmpty
              ? null
              : FloatingActionButton(
                  onPressed: () => {},
                  child: AddTracking(32),
                ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}

class AddTracking extends StatelessWidget {
  final double iconSize;
  const AddTracking(this.iconSize, {Key? key}) : super(key: key);

  void addTracking(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const FormAddEdit(
          rename: false,
          mercadoLibre: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      iconSize: iconSize,
      onPressed: () => addTracking(context),
    );
  }
}
