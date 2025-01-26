import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ad_native.dart';
import 'dialog_toast.dart';

import '../data/../data/preferences.dart';
import '../data/trackings_active.dart';
import '../data/trackings_archived.dart';

import '../screens/archived.dart';
import '../screens/claim.dart';
import '../screens/form_contact.dart';
import '../screens/google_drive.dart';
import '../screens/help.dart';
import '../screens/main_screen.dart';
import '../screens/mercado_libre.dart';
import '../screens/mercado_pago.dart';

import '../widgets/ad_interstitial.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  AdInterstitial driveInterstitialAd = AdInterstitial();
  AdInterstitial meLiInterstitialAd = AdInterstitial();
  AdInterstitial mePaInterstitialAd = AdInterstitial();

  @override
  void initState() {
    super.initState();
    driveInterstitialAd.createInterstitialAd();
    meLiInterstitialAd.createInterstitialAd();
    mePaInterstitialAd.createInterstitialAd();
  }

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
    final int archivedAmount =
        Provider.of<ArchivedTrackings>(context).trackings.length;
    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 110,
            child: DrawerHeader(
              margin: EdgeInsets.only(bottom: 1),
              padding: EdgeInsets.only(left: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorLight
                ]),
              ),
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
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Text(
                      'TrackeAR',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (premiumUser) Icon(Icons.workspace_premium, size: 50)
                ],
              ),
            ),
          ),
          optionAPI(() {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GoogleDrive(driveInterstitialAd),
                ));
          },
              Image.network(
                  'https://raw.githubusercontent.com/leogh73/trackify_frontend/refs/heads/master/assets/other/google_drive.png'),
              40,
              180,
              googleStatus),
          optionAPI(
            () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MercadoLibre(meLiInterstitialAd),
                ),
              );
            },
            Image.network(
                "https://raw.githubusercontent.com/leogh73/trackify_frontend/refs/heads/master/assets/other/mercado_libre.png"),
            38,
            155,
            meliStatus,
          ),
          DrawerOption(
            Icons.local_shipping,
            "Activos ($mainAmount)",
            MainScreen(),
            true,
            false,
          ),
          DrawerOption(
            Icons.archive,
            "Archivados ($archivedAmount)",
            const Archived(),
            false,
            false,
          ),
          DrawerOption(
            Icons.error,
            "Reclamo",
            Claim(''),
            false,
            false,
          ),
          DrawerOption(
            Icons.mail_outline,
            'Contacto',
            FormContact(),
            false,
            false,
          ),
          premiumUser
              ? DrawerOption(
                  Icons.workspace_premium,
                  'Premium',
                  MercadoPago(mePaInterstitialAd),
                  false,
                  false,
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(color: Colors.grey.shade400),
                    )),
                    height: 80,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    MercadoPago(mePaInterstitialAd)));
                      },
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
                                width: 185,
                                child: Text(
                                  "¿Demasiados anuncios? Prueba la versión Premium",
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
          if (!premiumUser)
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                padding: EdgeInsets.only(top: 8, bottom: 2.5),
                child: AdNative("small"),
              ),
            ),
          DrawerOption(Icons.help_outline, "Ayuda", Help(), false, false),
          DrawerOption(
            Icons.info_outline,
            'Acerca de ésta aplicación',
            () => ShowDialog.aboutThisApp(context, premiumUser),
            false,
            true,
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

  const DrawerOption(
      this.icon, this.text, this.destination, this.main, this.about,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: InkWell(
        onTap: () {
          if (main) Navigator.pop(context);
          if (!main && !about) {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => destination!));
          }
          if (about) destination();
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
