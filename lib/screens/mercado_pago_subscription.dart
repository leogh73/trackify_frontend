import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/widgets/dialog_toast.dart';

import '../data/http_connection.dart';
import '../data/preferences.dart';

import '../widgets/ad_interstitial.dart';
import '../widgets/ad_banner.dart';
import '../widgets/ad_native.dart';

class MercadoPagoSubscription extends StatefulWidget {
  final String url;
  const MercadoPagoSubscription(this.url, {Key? key}) : super(key: key);

  @override
  State<MercadoPagoSubscription> createState() =>
      _MercadoPagoSubscriptionState();
}

class _MercadoPagoSubscriptionState extends State<MercadoPagoSubscription> {
  AdInterstitial interstitialAd = AdInterstitial();

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return Scaffold(
      appBar: AppBar(
        title: Text(texts[111]!),
        titleSpacing: 1.0,
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: premiumUser ? null : const AdNative("small"),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                texts[112]!,
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: fullHD ? 17 : 16),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: .5),
                ),
                child: Image.network(
                    "https://raw.githubusercontent.com/leogh73/trackify_frontend/refs/heads/master/assets/other/mercado_pago_subscription.png"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                texts[113]!,
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: fullHD ? 17 : 16),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                        child: Text(
                          texts[114]!,
                          style: const TextStyle(fontSize: 17),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          if (!premiumUser) {
                            interstitialAd.showInterstitialAd();
                            ShowDialog.goPremiumDialog(context);
                          }
                        }),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                        child: Text(
                          texts[115]!,
                          style: const TextStyle(fontSize: 17),
                        ),
                        onPressed: () {
                          HttpConnection.customTabsLaunchUrl(
                              widget.url, context);
                          Navigator.of(context).pop();
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: premiumUser ? null : const AdBanner(),
    );
  }
}
