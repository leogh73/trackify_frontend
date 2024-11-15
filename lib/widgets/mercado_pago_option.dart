import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/http_connection.dart';
import '../screens/mercado_pago.dart';
import '../data/preferences.dart';
import '../widgets/ad_interstitial.dart';
import '../widgets/dialog_error.dart';

class MercadoPagoOption extends StatefulWidget {
  final bool premiumUser;
  final AdInterstitial adInterstitial;
  final String description;
  final List<Map<String, dynamic>> buttonsData;
  final Map<String, String> deviceData;
  final BuildContext context;
  MercadoPagoOption(this.premiumUser, this.adInterstitial, this.description,
      this.buttonsData, this.deviceData, this.context,
      {Key? key})
      : super(key: key);

  @override
  State<MercadoPagoOption> createState() => _MercadoPagoOptionState();
}

class _MercadoPagoOptionState extends State<MercadoPagoOption> {
  bool onProcess = false;

  final Map<String, String> operation = {
    "PAGO SIMPLE": "simple",
    "RENOVAR": "simple",
    "SUSCRIPCIÓN": "subscription",
    "VERIFICAR": "check",
    "REINTENTAR": "check",
    "PAUSAR": "pause",
    "CANCELAR": "cancel",
  };

  void onProcessToggle() {
    setState(() {
      onProcess = !onProcess;
    });
  }

  Future<void> paymentHandler(String buttonText) async {
    onProcessToggle();
    Object body = {
      'operation': operation[buttonText],
      'deviceData': json.encode(widget.deviceData),
    };
    if (buttonText == "REINTENTAR") {
      Provider.of<UserPreferences>(context, listen: false)
          .toggleErrorPaymentCheck(false);
    }
    if (widget.deviceData['uuid'] == "" && operation[buttonText] == "check") {
      onProcessToggle();
      DialogError.getUuidCheck(widget.context);
      return;
    }
    final Response response =
        await HttpConnection.requestHandler("/api/mercadopago/payment/", body);
    final Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, context);
    if (response.statusCode == 200) {
      if (operation[buttonText] == "check") {
        if (responseData['result'] == "payment not found") {
          DialogError.paymentNotFound(context);
        } else {
          Provider.of<UserPreferences>(context, listen: false)
              .setPaymentData(responseData['result']);
        }
      }
      if (responseData['url'] != null) {
        if (widget.deviceData['uuid'] == "") {
          DialogError.getUuidWarning(widget.context);
        }
        if (!await launchUrl(Uri.parse(responseData['url']),
            mode: LaunchMode.externalApplication)) {
          throw 'Could not launch ${responseData['url']}';
        }
      }
    } else {
      if (responseData['serverError'] == null) {
        DialogError.paymentError(context);
      }
      Provider.of<UserPreferences>(context, listen: false)
          .toggleErrorPaymentCheck(true);
    }
    onProcessToggle();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final List<Widget> buttonsList = widget.buttonsData
        .map((button) => SizedBox(
              width: 200,
              child: ElevatedButton(
                child: Row(
                  children: [
                    Icon(button["icon"]),
                    SizedBox(width: 20),
                    screenText(button["text"], fullHD),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                onPressed: () => paymentHandler(button["text"]),
              ),
            ))
        .toList();
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      height: isPortrait ? 118 : 70,
      child: onProcess
          ? Center(child: CircularProgressIndicator())
          : isPortrait
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      widget.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fullHD ? 17 : 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    ...buttonsList,
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: screenHeight * 1.2,
                          child: Text(
                            widget.description,
                            style: TextStyle(
                              fontSize: fullHD ? 17 : 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ...buttonsList
                      ],
                    ),
                  ],
                ),
    );
  }
}
