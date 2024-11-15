import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:trackify/screens/mercado_pago.dart';

import '../data/classes.dart';
import '../data/trackings_active.dart';
import '../data/status.dart';
import '../data/../data/preferences.dart';
import '../data/tracking_functions.dart';

import '../screens/form_add_edit.dart';
import '../screens/search.dart';

import '../widgets/ad_banner.dart';
import '../widgets/ad_interstitial.dart';
import '../widgets/ad_native.dart';
import '../widgets/drawer.dart';
import '../widgets/tracking_list.dart';
import '../widgets/options_style.dart';
import '../widgets/options_tracking.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AdInterstitial mePaInterstitialAd = AdInterstitial();

  @override
  void initState() {
    super.initState();
    mePaInterstitialAd.createInterstitialAd();
    Future.delayed(
      const Duration(seconds: 3),
      () => TrackingFunctions.syncronizeUserData(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    final String userId = Provider.of<UserPreferences>(context).userId;
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
    return userId.isEmpty
        ? Scaffold(
            appBar: AppBar(title: Text("ERROR")),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!premiumUser)
                    Padding(
                      child: AdNative("medium"),
                      padding: EdgeInsets.only(top: 8, bottom: 30),
                    ),
                  Icon(Icons.error, size: 80),
                  SizedBox(height: 20),
                  Text(
                    'ERROR',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    child: Text(
                      'Ocurrió un error de conexión, debido al cual, la aplicación se instaló incorrectamente y no la podrá utilizar. Verifique su conexión a internet. Reinicie para reintentar.',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                  ),
                  SizedBox(
                    width: 145,
                    height: 45,
                    child: ElevatedButton(
                      child: Text(
                        'REINTENTAR',
                        style: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () => Phoenix.rebirth(context),
                    ),
                  ),
                  if (!premiumUser)
                    Padding(
                      child: AdNative("medium"),
                      padding: EdgeInsets.only(top: 30, bottom: 8),
                    ),
                ],
              ),
            ),
          )
        : Scaffold(
            drawer: DrawerWidget(),
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
                      if (!premiumUser)
                        IconButton(
                          icon: const Icon(Icons.workspace_premium),
                          iconSize: 22,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) =>
                                      MercadoPago(mePaInterstitialAd))),
                        ),
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
            body: TrackingList(trackings),
            floatingActionButton: selectionMode || endOfList
                ? null
                : FloatingActionButton(
                    onPressed: () => {},
                    child: AddTracking(32),
                  ),
            bottomNavigationBar: premiumUser ? null : const AdBanner(),
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
