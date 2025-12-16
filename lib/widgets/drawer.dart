import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/classes.dart';
import '../data/services.dart';
import '../data/preferences.dart';
import '../data/trackings_active.dart';
import '../data/trackings_archived.dart';

import '../screens/archived.dart';
import '../screens/claim.dart';
import '../screens/form_contact.dart';
import '../screens/google_drive.dart';
import '../screens/help.dart';
import '../screens/main_screen.dart';
import '../screens/mercado_libre.dart';
import '../screens/premium.dart';

import '../widgets/ad_interstitial.dart';
import '../widgets/ad_native.dart';
import '../widgets/dialog_toast.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  AdInterstitial optionInterstitialAd = AdInterstitial();

  @override
  void initState() {
    super.initState();
    optionInterstitialAd.createInterstitialAd();
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
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    final bool meliStatus = context.select(
        (UserPreferences userPreferences) => userPreferences.meLiStatus);
    final bool googleStatus = context
        .select((UserPreferences userPreferences) => userPreferences.gdStatus);
    final List<ItemTracking> activeTrackings =
        context.watch<ActiveTrackings>().trackings;
    final List<ItemTracking> archivedTrackings =
        context.watch<ArchivedTrackings>().trackings;
    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 110,
            child: DrawerHeader(
              margin: const EdgeInsets.only(bottom: 1),
              padding: const EdgeInsets.only(left: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: <Color>[
                      Theme.of(context).primaryColor,
                      Colors.grey[100]!,
                      Theme.of(context).primaryColor,
                    ]),
              ),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.asset("assets/icon/icon.png",
                        height: 70, width: 70),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Text(
                      'TrackeAR',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (premiumUser) const Icon(Icons.workspace_premium, size: 50)
                ],
              ),
            ),
          ),
          optionAPI(() {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GoogleDrive(),
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
                  builder: (_) => const MercadoLibre(),
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
            "${texts[146]} (${activeTrackings.length})",
            const MainScreen(),
            true,
            false,
            false,
            optionInterstitialAd,
          ),
          DrawerOption(
            Icons.archive,
            "${texts[147]} (${archivedTrackings.length})",
            const Archived(),
            false,
            false,
            false,
            optionInterstitialAd,
          ),
          DrawerOption(
            Icons.error,
            texts[148]!,
            const ServiceClaim(""),
            false,
            false,
            true,
            optionInterstitialAd,
          ),
          DrawerOption(
            Icons.mail_outline,
            texts[149]!,
            const FormContact(),
            false,
            false,
            false,
            optionInterstitialAd,
          ),
          premiumUser
              ? DrawerOption(
                  Icons.workspace_premium,
                  'Premium',
                  const Premium(),
                  false,
                  false,
                  false,
                  optionInterstitialAd,
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const Premium()));
                        if (!premiumUser && trackingsList.isNotEmpty) {
                          optionInterstitialAd.showInterstitialAd();
                          ShowDialog.goPremiumDialog(context);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Icon(Icons.workspace_premium, size: 26),
                              const Padding(
                                padding: EdgeInsets.all(7.0),
                              ),
                              SizedBox(
                                width: 185,
                                child: Text(
                                  texts[150]!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 17),
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
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                padding: const EdgeInsets.only(top: 8, bottom: 2.5),
                child: const AdNative("small"),
              ),
            ),
          DrawerOption(
            Icons.help_outline,
            texts[151]!,
            const Help(),
            false,
            false,
            false,
            optionInterstitialAd,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(color: Colors.grey.shade400),
              )),
              height: 45,
              child: InkWell(
                onTap: () => SharePlus.instance.share(
                  ShareParams(
                    uri: Uri.parse(
                        "https://play.google.com/store/apps/details?id=com.leogh73.trackify"),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(Icons.share_outlined, size: 26),
                        const Padding(
                          padding: EdgeInsets.all(7.0),
                        ),
                        SizedBox(
                          width: 185,
                          child: Text(
                            texts[152]!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 17),
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
          DrawerOption(
            Icons.info_outline,
            texts[153]!,
            () => ShowDialog.aboutThisApp(context, premiumUser, texts),
            false,
            true,
            false,
            optionInterstitialAd,
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
  final bool claim;
  final AdInterstitial? interstitialAd;

  const DrawerOption(this.icon, this.text, this.destination, this.main,
      this.about, this.claim, this.interstitialAd,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: InkWell(
        onTap: () {
          if (main) {
            Navigator.pop(context);
          }
          if (!main && !about) {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => destination!));
          }
          if (claim) {
            Provider.of<Services>(context, listen: false).clearFilteredList();
            Provider.of<Services>(context, listen: false)
                .clearDetectedServices();
            Provider.of<Services>(context, listen: false).clearStartService();
          }
          if (about) {
            destination();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
          ),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
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
