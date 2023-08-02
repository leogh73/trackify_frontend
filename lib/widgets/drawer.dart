import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:trackify/screens/contact_form.dart';
import 'package:trackify/screens/services_status.dart';

import 'package:trackify/widgets/ad_interstitial.dart';
import 'package:trackify/widgets/dialog_and_toast.dart';

import '../providers/preferences.dart';
import '../providers/trackings_active.dart';
import '../providers/trackings_archived.dart';

import '../screens/main_screen.dart';
import '../screens/archived.dart';
// import '../screens/opciones.dart';
import '../screens/mercadolibre.dart';
import '../screens/googledrive.dart';

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

  Widget optionAPI(VoidCallback openPage, Image imagen, double altura,
      double ancho, bool accountState) {
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
              SizedBox(height: altura, width: ancho, child: imagen),
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
    final bool meliStatus = Provider.of<Preferences>(context).meLiStatus;
    final bool googleStatus = Provider.of<Preferences>(context).gdStatus;
    final int mainAmount =
        Provider.of<ActiveTrackings>(context).trackings.length;
    String userId = Provider.of<Preferences>(context, listen: false).userId;
    final int archivedAmount =
        Provider.of<ArchivedTrackings>(context).trackings.length;
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorLight
                ]),
              ),
              child: Column(
                children: <Widget>[
                  Material(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(100.0)),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/icon/icon.png",
                          height: 84, width: 84),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'TrackeAR',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 25.0),
                    ),
                  ),
                ],
              )),
          optionAPI(
              () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GoogleDrive(),
                        )),
                    drawerInterstitialAd1.showInterstitialAd()
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
              drawerInterstitialAd2.showInterstitialAd()
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
            Icons.query_stats,
            "Estado de servicios",
            const ServicesStatus(),
            false,
            false,
            drawerInterstitialAd5,
          ),
          DrawerOption(
            Icons.mail_outline,
            'Contáctanos',
            ContactForm(),
            false,
            false,
            drawerInterstitialAd6,
          ),
          DrawerOption(
            Icons.info_outline,
            'Acerca de ésta aplicación',
            ShowDialog(context).about,
            false,
            true,
            AdInterstitial(),
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
  final AdInterstitial interstitialAd;

  const DrawerOption(this.icon, this.text, this.destination, this.main,
      this.about, this.interstitialAd,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        child: InkWell(
          onTap: () => {
            interstitialAd.showInterstitialAd(),
            if (main) Navigator.pop(context),
            if (!main && !about)
              {
                Navigator.pop(context),
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => destination!))
              },
            if (about) destination(),
          },
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icon),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Text(
                      text,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
