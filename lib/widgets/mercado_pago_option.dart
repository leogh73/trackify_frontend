import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import '../data/http_connection.dart';
import '../data/theme.dart';

import '../screens/mercado_pago.dart';
import '../screens/mercado_pago_subscription.dart';

import '../widgets/ad_interstitial.dart';
import '../widgets/dialog_error.dart';

class MercadoPagoOption extends StatefulWidget {
  final bool premiumUser;
  final AdInterstitial adInterstitial;
  final String title;
  final String description;
  final IconData buttonIcon;
  final Map<String, String> deviceData;
  final BuildContext context;
  MercadoPagoOption(this.premiumUser, this.adInterstitial, this.title,
      this.description, this.buttonIcon, this.deviceData, this.context,
      {Key? key})
      : super(key: key);

  @override
  State<MercadoPagoOption> createState() => _MercadoPagoOptionState();
}

class _MercadoPagoOptionState extends State<MercadoPagoOption> {
  bool onProcess = false;

  final Map<String, String> paymentType = {
    "PAGO SIMPLE": "simple",
    "SUSCRIPCIÓN": "subscription",
  };

  void onProcessToggle() {
    setState(() {
      onProcess = !onProcess;
    });
  }

  Future<void> paymentRequest() async {
    onProcessToggle();
    Object body = {
      'paymentType': paymentType[widget.title],
      'deviceData': json.encode(widget.deviceData),
    };
    final Response response = await HttpConnection.requestHandler(
        "/api/mercadopago/paymentRequest/", body);
    final Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, context);
    if (response.statusCode == 200) {
      if (responseData['url'] != null) {
        if (widget.deviceData['uuid'] == "") {
          DialogError.show(context, 15, "");
        }
        if (widget.title == "SUSCRIPCIÓN") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => MercadoPagoSubscription(responseData["url"])));
        } else
          try {
            final int colorValue =
                Provider.of<UserTheme>(context, listen: false).startColor.value;
            await launch(
              responseData['url'],
              customTabsOption:
                  CustomTabsOption(toolbarColor: Color(colorValue)),
            );
          } catch (e) {
            debugPrint(e.toString());
          }
      }
    } else {
      if (responseData['serverError'] == null) {
        DialogError.show(context, 21, "");
      }
    }
    onProcessToggle();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final MaterialColor mainColor = Provider.of<UserTheme>(context).startColor;
    final Widget button = SizedBox(
      width: 155,
      child: ElevatedButton(
        child: Row(
          children: [
            Icon(widget.buttonIcon),
            SizedBox(width: 20),
            screenText("PAGAR", fullHD),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        onPressed: () => paymentRequest(),
      ),
    );
    final Widget title = Padding(
      padding: EdgeInsets.only(top: isPortrait ? 8 : 12),
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
      constraints: new BoxConstraints(maxHeight: isPortrait ? 150 : 100),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: onProcess
            ? Center(child: CircularProgressIndicator())
            : isPortrait
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      title,
                      SizedBox(height: 5),
                      Text(
                        widget.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fullHD ? 17 : 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      button,
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      title,
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: screenWidth * .68,
                            child: Text(
                              widget.description,
                              style: TextStyle(
                                fontSize: fullHD ? 17 : 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(children: [button]),
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }
}
