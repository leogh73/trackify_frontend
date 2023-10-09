import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../screens/form_contact.dart';

import '../widgets/ad_interstitial.dart';
import '../widgets/ad_native.dart';
import 'dialog_toast.dart';

import '../providers/preferences.dart';
import '../providers/trackings_active.dart';
import '../providers/trackings_archived.dart';

import '../screens/main_screen.dart';
import '../screens/archived.dart';
import '../screens/mercadolibre.dart';
import '../screens/googledrive.dart';
import '../screens/claim.dart';

class DrawerWidget extends StatelessWidget {
  final AdInterstitial drawerInterstitialAd1;
  final AdInterstitial drawerInterstitialAd2;
  final AdInterstitial drawerInterstitialAd3;
  final AdInterstitial drawerInterstitialAd4;
  final AdInterstitial drawerInterstitialAd5;
  final AdInterstitial drawerInterstitialAd6;

  const DrawerWidget(
      this.drawerInterstitialAd1,
      this.drawerInterstitialAd2,
      this.drawerInterstitialAd3,
      this.drawerInterstitialAd4,
      this.drawerInterstitialAd5,
      this.drawerInterstitialAd6,
      {Key? key})
      : super(key: key);

  Widget optionAPI(
    VoidCallback openPage,
    Image logo,
    double height,
    double width,
    bool accountState,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: InkWell(
        onTap: openPage,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade400),
            ),
          ),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: height, width: width, child: logo),
              accountState
                  ? const Icon(Icons.account_circle_rounded)
                  : const Icon(Icons.account_circle_outlined),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    final bool meliStatus = Provider.of<UserPreferences>(context).meLiStatus;
    final bool googleStatus = Provider.of<UserPreferences>(context).gdStatus;
    final int mainAmount =
        Provider.of<ActiveTrackings>(context).trackings.length;
    String userId = Provider.of<UserPreferences>(context, listen: false).userId;
    final int archivedAmount =
        Provider.of<ArchivedTrackings>(context).trackings.length;
    final List<Widget> adsWidget = [
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: SizedBox(
          height: 80,
          child: InkWell(
            onTap: () => ShowDialog.premiumSubscription(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.workspace_premium, size: 26),
                    const Padding(
                      padding: EdgeInsets.all(7.0),
                    ),
                    Container(
                      width: 180,
                      child: Text(
                        "¿Demasiados anuncios? Suscríbete a la versión Premium",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16),
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_right),
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade400),
              bottom: BorderSide(color: Colors.grey.shade400),
            ),
          ),
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: AdNative("medium"),
        ),
      ),
    ];
    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 120,
            child: DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorLight
                ]),
              ),
              child: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: <Widget>[
                      Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100.0)),
                        // elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Image.asset("assets/icon/icon.png",
                              height: 70, width: 70),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 21, right: 13),
                        child: Text(
                          'TrackeAR',
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 25.0),
                        ),
                      ),
                      if (premiumUser) Icon(Icons.workspace_premium, size: 50)
                    ],
                  )),
            ),
          ),
          optionAPI(
              () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GoogleDrive(),
                        )),
                    if (!premiumUser) drawerInterstitialAd1.showInterstitialAd()
                  },
              Image.asset('assets/other/googledrive.png'),
              40,
              180,
              googleStatus),
          optionAPI(
            () => {
              Navigator.pop(context),
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MercadoLibre(),
                ),
              ),
              if (!premiumUser) drawerInterstitialAd2.showInterstitialAd()
            },
            Image.asset('assets/other/mercadolibre.png'),
            38,
            155,
            meliStatus,
          ),
          DrawerOption(
            Icons.local_shipping,
            "Activos ($mainAmount)",
            MainScreen(userId),
            true,
            false,
            drawerInterstitialAd3,
          ),
          DrawerOption(
            Icons.archive,
            "Archivados ($archivedAmount)",
            const Archived(),
            false,
            false,
            drawerInterstitialAd4,
          ),
          DrawerOption(
            Icons.error,
            "Reclamo",
            Claim(),
            false,
            false,
            drawerInterstitialAd5,
          ),
          DrawerOption(
            Icons.mail_outline,
            'Contacto',
            FormContact(),
            false,
            false,
            drawerInterstitialAd6,
          ),
          if (!premiumUser) ...adsWidget,
          DrawerOption(
            Icons.info_outline,
            'Acerca de ésta aplicación',
            () => ShowDialog.aboutThisApp(context, premiumUser),
            false,
            true,
            null,
          ),
        ],
      ),
    );
  }
}

class DrawerOption extends StatelessWidget {
  final dynamic icon;
  final String text;
  final dynamic destination;
  final bool main;
  final bool about;
  final AdInterstitial? interstitialAd;

  const DrawerOption(this.icon, this.text, this.destination, this.main,
      this.about, this.interstitialAd,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    // final drawerWidth = MediaQuery.of(context).size.width * 0.8;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: InkWell(
        onTap: () => {
          if (!premiumUser) interstitialAd?.showInterstitialAd(),
          if (main) Navigator.pop(context),
          if (!main && !about)
            {
              Navigator.pop(context),
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => destination!))
            },
          if (about) destination(),
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
          ),
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(icon),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  Text(
                    text,
                    style: const TextStyle(fontSize: 17),
                    maxLines: 3,
                  ),
                ],
              ),
              const Icon(Icons.arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}
