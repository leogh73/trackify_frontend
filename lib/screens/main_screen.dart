import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/screens/search.dart';
import 'package:trackify/widgets/dialog_error.dart';
import 'package:trackify/widgets/options_style.dart';
import '../widgets/ad_native.dart';

import '../providers/classes.dart';
import '../providers/trackings_active.dart';
import '../providers/status.dart';
import '../providers/preferences.dart';

import '../screens/form_add_edit.dart';

import '../widgets/drawer.dart';
import '../widgets/tracking.list.dart';
import '../widgets/options_tracking.dart';
import '../widgets/ad_banner.dart';
import '../widgets/ad_interstitial.dart';

class MainScreen extends StatefulWidget {
  final String userId;
  const MainScreen(this.userId, {Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AdInterstitial mainInterstitialAd = AdInterstitial();

  AdInterstitial drawerInterstitialAd1 = AdInterstitial();
  AdInterstitial drawerInterstitialAd2 = AdInterstitial();
  AdInterstitial drawerInterstitialAd3 = AdInterstitial();
  AdInterstitial drawerInterstitialAd4 = AdInterstitial();
  AdInterstitial drawerInterstitialAd5 = AdInterstitial();
  AdInterstitial drawerInterstitialAd6 = AdInterstitial();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        final String error =
            Provider.of<Status>(context, listen: false).getStartError;
        if (error.isNotEmpty) {
          return DialogError.startError(context, error);
        }
      },
    );
    mainInterstitialAd.createInterstitialAd();
    drawerInterstitialAd1.createInterstitialAd();
    drawerInterstitialAd2.createInterstitialAd();
    drawerInterstitialAd3.createInterstitialAd();
    drawerInterstitialAd4.createInterstitialAd();
    drawerInterstitialAd5.createInterstitialAd();
    drawerInterstitialAd6.createInterstitialAd();
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
      drawer: error.isEmpty && userId.isNotEmpty
          ? DrawerWidget(
              drawerInterstitialAd1,
              drawerInterstitialAd2,
              drawerInterstitialAd3,
              drawerInterstitialAd4,
              drawerInterstitialAd5,
              drawerInterstitialAd6,
            )
          : null,
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
                    mainInterstitialAd.showInterstitialAd(),
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
                  child: AddTracking(32, mainInterstitialAd),
                ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}

class AddTracking extends StatelessWidget {
  final double iconSize;
  final AdInterstitial interstitialAd;
  const AddTracking(this.iconSize, this.interstitialAd, {Key? key})
      : super(key: key);

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
    interstitialAd.showInterstitialAd();
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
