import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart';

import '../data/http_connection.dart';
import '../data/preferences.dart';
import '../data/theme.dart';

import '../screens/mercado_pago.dart';
import '../screens/mercado_pago_check.dart';
import '../screens/mercado_pago_detail.dart';

import '../widgets/ad_interstitial.dart';
import '../widgets/dialog_error.dart';

class MercadoPagoOption extends StatefulWidget {
  final bool premiumUser;
  final AdInterstitial adInterstitial;
  final String title;
  final String description;
  final String buttonTitle;
  final IconData buttonIcon;
  final Map<String, String> deviceData;
  final Map<String, dynamic> paymentData;
  final BuildContext context;
  MercadoPagoOption(
      this.premiumUser,
      this.adInterstitial,
      this.title,
      this.description,
      this.buttonTitle,
      this.buttonIcon,
      this.deviceData,
      this.paymentData,
      this.context,
      {Key? key})
      : super(key: key);

  @override
  State<MercadoPagoOption> createState() => _MercadoPagoOptionState();
}

class _MercadoPagoOptionState extends State<MercadoPagoOption> {
  bool onProcess = false;

  void onProcessToggle() {
    setState(() {
      onProcess = !onProcess;
    });
  }

  Future<void> optionHandler() async {
    if (widget.buttonTitle == "VERIFICAR" &&
        widget.paymentData['status'] == "could not be checked") {
      DialogError.show(context, 21, "");
      return;
    }
    if (widget.buttonTitle == "INGRESAR") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => MercadoPagoInput()));
      return;
    }
    if (widget.buttonTitle == "VER") {
      if (widget.paymentData["operationId"] == null) {
        DialogError.show(context, 18, "");
        return;
      }
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => PaymentDetail()));
      return;
    }
    onProcessToggle();
    Object body = {
      'deviceData': json.encode(widget.deviceData),
    };
    if (widget.deviceData['uuid'] == "") {
      onProcessToggle();
      DialogError.show(context, 14, "");
      return;
    }
    final Response response = await HttpConnection.requestHandler(
        "/api/mercadopago/checkDeviceId/", body);
    final Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, context);
    if (response.statusCode == 200) {
      if (responseData['result'] == "payment not found") {
        DialogError.show(context, 16, "");
      } else {
        if (responseData['result']['isValid'] == false) {
          DialogError.show(context, 20, "");
        }
        Provider.of<UserPreferences>(context, listen: false)
            .setPaymentData(responseData['result']);
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
      width: 175,
      child: ElevatedButton(
        child: Row(
          children: [
            Icon(widget.buttonIcon),
            SizedBox(width: 20),
            screenText(widget.buttonTitle, fullHD),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        onPressed: optionHandler,
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
      constraints: new BoxConstraints(maxHeight: isPortrait ? 147 : 100),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: onProcess
            ? Padding(
                padding: EdgeInsets.only(top: isPortrait ? 6 : 15),
                child: Center(child: CircularProgressIndicator()),
              )
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
                            width: screenWidth * .6,
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
