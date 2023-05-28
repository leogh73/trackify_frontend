import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:trackify/screens/contact_form.dart';
import 'package:trackify/widgets/ad_interstitial.dart';
import 'package:trackify/widgets/dialog_and_toast.dart';

import '../providers/preferences.dart';
import '../providers/trackings_active.dart';
import '../providers/trackings_archived.dart';

import '../screens/main.dart';
import '../screens/archived.dart';
// import '../screens/opciones.dart';
import '../screens/mercadolibre.dart';
import '../screens/googledrive.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  Widget optionAPI(VoidCallback openPage, Image imagen, double altura,
      double ancho, bool estadoCuenta) {
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
              estadoCuenta
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
    final AdInterstitial interstitialAd = AdInterstitial();
    interstitialAd.createInterstitialAd();
    final bool meliStatus = Provider.of<Preferences>(context).meLiStatus;
    final bool googleStatus = Provider.of<Preferences>(context).gdStatus;
    int mainAmount = Provider.of<ActiveTrackings>(context).trackings.length;
    int archivedAmount =
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
                    interstitialAd.showInterstitialAd(),
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GoogleDrive(),
                        ))
                  },
              Image.asset('assets/other/googledrive.png'),
              40,
              180,
              googleStatus),
          optionAPI(
            () => {
              interstitialAd.showInterstitialAd(),
              Navigator.pop(context),
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MercadoLibre(),
                ),
              ),
            },
            Image.asset('assets/other/mercadolibre.png'),
            38,
            155,
            meliStatus,
          ),
          DrawerOption(Icons.local_shipping, "Activos ($mainAmount)",
              const Main(), true, false, interstitialAd),
          DrawerOption(Icons.archive, "Archivados ($archivedAmount)",
              const Archived(), false, false, interstitialAd),
          DrawerOption(Icons.mail_outline, 'Contáctanos', const ContactForm(),
              false, false, interstitialAd),
          DrawerOption(Icons.info_outline, 'Acerca de ésta aplicación',
              ShowDialog(context).about, false, true, null),
        ],
      ),
    );
  }
}

class DrawerOption extends StatelessWidget {
  final dynamic icon;
  final String text;
  final dynamic destiny;
  final bool main;
  final bool about;
  final AdInterstitial? interstitialAd;

  const DrawerOption(this.icon, this.text, this.destiny, this.main, this.about,
      this.interstitialAd,
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
            interstitialAd?.showInterstitialAd(),
            if (main) Navigator.pop(context),
            if (!main && !about)
              {
                Navigator.pop(context),
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => destiny!))
              },
            if (about) destiny(),
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
