import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/preferences.dart';
import '../data/theme.dart';

import '../widgets/ad_banner.dart';
import '../widgets/ad_interstitial.dart';
import '../widgets/ad_native.dart';
import '../widgets/mercado_pago_option.dart';

class MercadoPagoStatus extends StatefulWidget {
  final Map<String, String> deviceData;
  final AdInterstitial adInterstitial;
  final BuildContext context;
  const MercadoPagoStatus(this.deviceData, this.adInterstitial, this.context,
      {super.key});

  @override
  State<MercadoPagoStatus> createState() => _MercadoPagoStatusState();
}

class _MercadoPagoStatusState extends State<MercadoPagoStatus> {
  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final Map<String, dynamic> paymentData = context.select(
        (UserPreferences userPreferences) => userPreferences.paymentData);
    final MaterialColor mainColor =
        context.select((UserTheme theme) => theme.startColor);
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final Widget divider =
        Divider(color: Theme.of(context).primaryColor, thickness: .3);
    final Widget separator = SizedBox(height: isPortrait ? 5 : 15);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts[96]!),
        titleSpacing: 1.0,
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: premiumUser ? null : const AdNative("small"),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25, left: 25, top: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "${texts[97]} ${!premiumUser ? texts[98] : ''} ${texts[99]}",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(top: isPortrait ? 8 : 0),
                    child: Text(
                      premiumUser ? texts[100]! : texts[101]!,
                      maxLines: 7,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: fullHD ? 17 : 16,
                      ),
                    ),
                  ),
                  separator,
                  separator,
                  divider,
                  MercadoPagoOption(
                      premiumUser,
                      widget.adInterstitial,
                      texts[102]!,
                      texts[103]!,
                      texts[104]!,
                      Icons.monetization_on,
                      widget.deviceData,
                      paymentData,
                      context),
                  separator,
                  divider,
                  MercadoPagoOption(
                      premiumUser,
                      widget.adInterstitial,
                      texts[105]!,
                      texts[106]!,
                      texts[107]!,
                      Icons.numbers,
                      widget.deviceData,
                      paymentData,
                      context),
                  separator,
                  divider,
                  MercadoPagoOption(
                      premiumUser,
                      widget.adInterstitial,
                      texts[108]!,
                      texts[109]!,
                      texts[110]!,
                      Icons.info_outline,
                      widget.deviceData,
                      paymentData,
                      context),
                  separator,
                  const SizedBox(height: 5)
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

Text screenText(String text, bool fullHD) {
  return Text(
    text,
    maxLines: 5,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: fullHD ? 17 : 16,
    ),
  );
}
