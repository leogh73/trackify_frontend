import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart';

import '../data/http_connection.dart';
import '../data/theme.dart';
import '../data/preferences.dart';

import '../screens/premium.dart';
import '../screens/mercado_pago_subscription.dart';

import '../widgets/ad_interstitial.dart';
import '../widgets/dialog_error.dart';

class PremiumPayment extends StatefulWidget {
  final bool premiumUser;
  final AdInterstitial adInterstitial;
  final String title;
  final String description;
  final IconData buttonIcon;
  final Map<String, String> deviceData;
  final BuildContext context;
  const PremiumPayment(this.premiumUser, this.adInterstitial, this.title,
      this.description, this.buttonIcon, this.deviceData, this.context,
      {Key? key})
      : super(key: key);

  @override
  State<PremiumPayment> createState() => _PremiumPaymentState();
}

class _PremiumPaymentState extends State<PremiumPayment> {
  bool onProcess = false;

  final Map<String, String> paymentType = {
    "PAGO SIMPLE": "simple",
    "SIMPLE PAYMENT": "simple",
    "SUSCRIPCIÓN": "subscription",
    "SUBSCRIPTION": "subscription",
  };

  void onProcessToggle() {
    setState(() {
      onProcess = !onProcess;
    });
  }

  Future<void> paymentRequest(Map<int, dynamic> texts) async {
    onProcessToggle();
    final BuildContext ctx = context;
    Object body = {
      'paymentType': paymentType[widget.title],
      'deviceData': json.encode(widget.deviceData),
    };
    final Response response = await HttpConnection.requestHandler(
        "/api/mercadopago/paymentRequest/", body);
    if (!ctx.mounted) {
      return;
    }
    final Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, ctx);
    if (response.statusCode == 200) {
      if (responseData['url'] != null) {
        if (widget.deviceData['uuid'] == "") {
          DialogError.show(ctx, 15, "");
        }
        if (widget.title == texts[119]!) {
          Navigator.of(ctx).push(MaterialPageRoute(
              builder: (_) => MercadoPagoSubscription(responseData["url"])));
        } else {
          HttpConnection.customTabsLaunchUrl(responseData['url'], ctx);
        }
      }
    } else {
      if (responseData['serverError'] == null) {
        DialogError.show(ctx, 21, "");
      }
    }
    onProcessToggle();
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final MaterialColor mainColor =
        context.select((UserTheme theme) => theme.startColor);
    final Widget button = SizedBox(
      width: isPortrait ? screenWidth * 0.4 : screenWidth * 0.25,
      child: ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.buttonIcon),
            const SizedBox(width: 20),
            screenText(texts[180]!, fullHD),
          ],
        ),
        onPressed: () => paymentRequest(texts),
      ),
    );
    final Widget title = Padding(
      padding: EdgeInsets.only(top: isPortrait ? 8 : 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
          )
        ],
      ),
    );
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: isPortrait ? screenWidth * .45 : screenHeight * .3),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: onProcess
            ? Padding(
                padding: EdgeInsets.only(top: isPortrait ? 6 : 15),
                child: const Center(child: CircularProgressIndicator()),
              )
            : isPortrait
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      title,
                      const SizedBox(height: 5),
                      Text(
                        widget.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fullHD ? 17 : 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      button,
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      title,
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: screenWidth * .68,
                            child: Text(
                              widget.description,
                              style: TextStyle(
                                fontSize: fullHD ? 17 : 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(children: [button]),
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }
}
