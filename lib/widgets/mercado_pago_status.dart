import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../data/preferences.dart';
import '../data/http_connection.dart';

import '../widgets/ad_interstitial.dart';
import '../widgets/dialog_error.dart';

import '../screens/mercado_pago_check.dart';
import '../screens/mercado_pago_detail.dart';

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
  bool onProcess = false;

  void onProcessToggle() {
    setState(() {
      onProcess = !onProcess;
    });
  }

  Future<void> optionHandler(
      String buttonText, Map<String, dynamic> paymentData) async {
    if (buttonText == "VERIFICAR PAGOS" &&
        paymentData['status'] == "could not be checked") {
      DialogError.show(context, 21, "");
      return;
    }
    if (buttonText == "INGRESAR PAGO") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => MercadoPagoInput()));
      return;
    }
    if (buttonText == "DETALLE DE PAGO") {
      if (paymentData["operationId"] == null) {
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

  Widget statusOption(
    bool isPortrait,
    bool onProcess,
    Map<String, dynamic> paymentData,
    String description,
    bool fullHD,
    List<Map<String, dynamic>> buttonsList,
    double screenWidth,
  ) {
    final List<Widget> buttons = buttonsList
        .map((button) => SizedBox(
              width: 232,
              child: ElevatedButton(
                child: Row(
                  children: [
                    Icon(button["icon"]),
                    SizedBox(width: 20),
                    screenText(button["text"], fullHD),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                onPressed: () => optionHandler(button["text"], paymentData),
              ),
            ))
        .toList();
    return ConstrainedBox(
      constraints: new BoxConstraints(maxHeight: isPortrait ? 275 : 145),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: onProcess
            ? Center(child: CircularProgressIndicator())
            : isPortrait
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(height: 5),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fullHD ? 17 : 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      ...buttons,
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: screenWidth * .6,
                            child: Text(
                              description,
                              style: TextStyle(
                                fontSize: fullHD ? 17 : 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(children: [...buttons]),
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final Map<String, dynamic> paymentData =
        Provider.of<UserPreferences>(context, listen: false).paymentData;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return Column(
      children: [
        paymentData['isValid'] == true
            ? Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: isPortrait ? 232 : 200,
                  child: ElevatedButton(
                    child: Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 20),
                        screenText("VER DETALLE", fullHD),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => PaymentDetail())),
                  ),
                ),
              )
            : statusOption(
                isPortrait,
                onProcess,
                paymentData,
                "No hay pagos válidos para éste dipositivo. Si ya ha realizado un pago, verifique pagos automáticamente, o ingrese el número de transacción que figura en su comprobante. Si ya asoció un pago, el mismo ya no es válido, vea los detalles.",
                fullHD,
                [
                  {
                    "text": "VERIFICAR PAGOS",
                    "icon": Icons.monetization_on,
                  },
                  {
                    "text": "INGRESAR PAGO",
                    "icon": Icons.numbers,
                  },
                  {
                    "text": "DETALLE DE PAGO",
                    "icon": Icons.info_outline,
                  }
                ],
                screenWidth,
              ),
      ],
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
