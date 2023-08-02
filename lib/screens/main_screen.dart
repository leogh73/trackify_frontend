import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/classes.dart';
import '../providers/trackings_active.dart';
import '../providers/status.dart';
import '../providers/preferences.dart';

import '../widgets/drawer.dart';
import 'tracking_form.dart';
import 'search.dart';

import '../widgets/dialog_and_toast.dart';
import '../widgets/menu_appereance.dart';
import '../widgets/list_select.dart';
import '../widgets/menu_actions.dart';
import '../widgets/ad_banner.dart';
import '../widgets/ad_interstitial.dart';

class MainScreen extends StatefulWidget {
  final String userId;
  static const routeName = "/main";

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
    Future.delayed(const Duration(seconds: 3), () {
      String error = Provider.of<Status>(context, listen: false).getStartError;
      if (error.isNotEmpty) {
        ShowDialog(context).startError(error);
      }
    });
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
    String error = Provider.of<Status>(context).getStartError;
    String userId = Provider.of<Preferences>(context, listen: false).userId;
    final bool selectionMode =
        Provider.of<ActiveTrackings>(context).selectionModeStatus;
    final bool endOfList = Provider.of<Status>(context).endOfList;
    final List<ItemTracking> selection =
        Provider.of<ActiveTrackings>(context).selectionElements;
    final List<ItemTracking> trackings =
        Provider.of<ActiveTrackings>(context).trackings;

    String _textSelection() {
      String text;
      text = '${selection.length}/${trackings.length}';
      return text;
    }

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
                _textSelection(),
                style: const TextStyle(fontSize: 19),
              ),
              actions: [
                if (selection.isNotEmpty)
                  ActionsMenu(
                    tracking: ItemTracking(
                        idMDB: 'idMDB',
                        code: 'code',
                        service: 'service',
                        events: [],
                        otherData: [],
                        checkError: false),
                    screen: "main",
                    menu: false,
                    detail: false,
                    action: "archive",
                    icon: 24,
                  ),
                if (selection.isNotEmpty)
                  ActionsMenu(
                    tracking: ItemTracking(
                        idMDB: 'idMDB',
                        code: 'code',
                        service: 'service',
                        events: [],
                        otherData: [],
                        checkError: false),
                    screen: "main",
                    menu: false,
                    detail: false,
                    action: "remove",
                    icon: 24,
                  ),
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
                // Estilo(),
                IconButton(
                  icon: const Icon(Icons.search),
                  iconSize: 20,
                  onPressed: () => {
                    mainInterstitialAd.showInterstitialAd(),
                    Provider.of<Status>(context, listen: false)
                        .loadMainController(null),
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const Search(),
                      ),
                    ),
                  },
                ),
                const AppereanceMenu(),
              ],
            ),
      body: Center(
        child: TrackingList(selectionMode, trackings),
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
  void _addTracking(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TrackingForm(
          edit: false,
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
        onPressed: () => _addTracking(context));
  }
}
