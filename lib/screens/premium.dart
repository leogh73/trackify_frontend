import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_uuid/device_uuid.dart';

import '../data/theme.dart';
import '../data/preferences.dart';

import '../widgets/ad_banner.dart';
import '../widgets/ad_interstitial.dart';
import '../widgets/ad_native.dart';
import '../widgets/mercado_pago_payment.dart';
import 'mercado_pago_status.dart';

class Premium extends StatefulWidget {
  const Premium({Key? key}) : super(key: key);

  @override
  State<Premium> createState() => _MercadoPagoState();
}

class _MercadoPagoState extends State<Premium> with TickerProviderStateMixin {
  AdInterstitial adInterstitial = AdInterstitial();
  Map<String, String> _deviceData = {};
  final DeviceUuid _deviceUuidPlugin = DeviceUuid();

  @override
  void initState() {
    super.initState();
    adInterstitial.createInterstitialAd();
    getDeviceData();
  }

  Future<void> getDeviceData() async {
    final BuildContext ctx = context;
    String uuid = '';
    try {
      uuid = await _deviceUuidPlugin.getUUID() ?? '';
    } catch (e) {
      // print("Error getting UUID: $e");
    }
    if (!ctx.mounted) {
      return;
    }
    Map<String, String> deviceData = {
      'userId': Provider.of<UserPreferences>(ctx, listen: false).userId,
      'uuid': uuid,
    };
    setState(() {
      _deviceData = deviceData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final MaterialColor mainColor =
        context.select((UserTheme theme) => theme.startColor);
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final Widget divider = Container(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Divider(color: Theme.of(context).primaryColor, thickness: .3));
    final Widget separator = SizedBox(height: isPortrait ? 5 : 15);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Premium"),
        titleSpacing: 1.0,
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: premiumUser ? null : const AdNative("small"),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 20, left: 25),
                    height:
                        isPortrait ? screenWidth * 0.4 : screenHeight * 0.36,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.workspace_premium, size: 70),
                        const SizedBox(height: 10),
                        Text(
                          texts[116]!,
                          maxLines: 7,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: fullHD ? 17 : 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            separator,
            divider,
            PremiumPayment(
              premiumUser,
              adInterstitial,
              texts[117]!,
              texts[118]!,
              Icons.payments,
              _deviceData,
              context,
            ),
            separator,
            divider,
            PremiumPayment(
              premiumUser,
              adInterstitial,
              texts[119]!,
              texts[120]!,
              Icons.credit_card,
              _deviceData,
              context,
            ),
            separator,
            divider,
            separator,
            Padding(
              padding: const EdgeInsets.only(
                  left: 25, right: 25, top: 10, bottom: 10),
              child: InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MercadoPagoStatus(
                        _deviceData, adInterstitial, context))),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  ),
                  child: Row(
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
                      const Icon(Icons.arrow_right),
                    ],
                  ),
                ),
              ),
            ),
            separator,
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
