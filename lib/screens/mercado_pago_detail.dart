import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

import '../data/http_connection.dart';
import '../data/preferences.dart';

import '../widgets/ad_banner.dart';
import '../widgets/ad_native.dart';
import '../widgets/dialog_error.dart';

class PaymentDetail extends StatefulWidget {
  const PaymentDetail({super.key});

  @override
  State<PaymentDetail> createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  bool onProcess = false;

  Widget paymentDetail(
    bool isPortrait,
    double screenWidth,
    Map<String, dynamic> paymentData,
  ) {
    const Map<String, IconData> statusIcon = {
      "approved": Icons.check,
      "pending": Icons.pending,
      "rejected": Icons.cancel_outlined,
      "authorized": Icons.check,
      "cancelled": Icons.cancel,
      "could not be checked": Icons.warning_amber,
    };
    Map<String, String> statusText = {
      "approved": "Aprobado",
      "pending": "Pendiente",
      "rejected": "Rechazado",
      "authorized": paymentData["paymentType"] == "simple"
          ? "Autorizado (no acreditado)"
          : "Autorizada",
      "paused": "Pausada",
      "cancelled": "Cancelado",
      "in_process": "En proceso",
      "in_mediation": "En mediación",
      "refunded": "Reembolsado",
      "charged_back": "Contracargo",
      "could not be checked": "No se pudo verificar"
    };
    final List<List<dynamic>> dataList = [
      [
        Icons.numbers,
        statusIcon[paymentData["status"]] ?? Icons.cancel_outlined,
        Icons.attach_money,
        Icons.calendar_month,
        paymentData["paymentType"] == "simple"
            ? Icons.timelapse
            : Icons.date_range,
        Icons.description_outlined,
      ],
      [
        "Operación",
        "Estado",
        "Tipo de pago",
        "Fecha",
        paymentData["paymentType"] == "simple"
            ? "Días restantes"
            : "Día de cobro",
        "Válido"
      ],
      [
        paymentData["operationId"].toString(),
        statusText[paymentData["status"]],
        paymentData["paymentType"] == "simple" ? "Simple" : "Suscripción",
        paymentData["dateCreated"],
        paymentData["paymentType"] == "simple"
            ? paymentData["daysRemaining"].toString()
            : paymentData["billingDay"].toString(),
        paymentData["isValid"].toString() == "true" ? "Si" : "No"
      ],
    ];

    return Container(
      width: isPortrait ? screenWidth * 0.9 : screenWidth * 0.6,
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: dataList[0]
                    .map((d) => Container(
                        height: 45,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(d, size: 24)],
                        )))
                    .toList(),
              ),
              Column(
                children: dataList[1]
                    .map((d) => Container(
                        height: 45,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(d,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17))
                          ],
                        )))
                    .toList(),
              ),
              Container(
                width: isPortrait ? screenWidth * 0.4 : screenWidth * 0.25,
                child: Column(
                  children: dataList[2]
                      .map((d) => Container(
                          height: 45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(d,
                                  style: TextStyle(
                                      fontSize: 17,
                                      overflow: TextOverflow.ellipsis))
                            ],
                          )))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onProcessToggle() {
    setState(() {
      onProcess = !onProcess;
    });
  }

  Future<void> cancelSubscription() async {
    onProcessToggle();
    final String userId =
        Provider.of<UserPreferences>(context, listen: false).userId;
    Object body = {'userId': userId};
    final Response response = await HttpConnection.requestHandler(
        "/api/mercadopago/cancelSubscription/", body);
    final Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, context);
    if (response.statusCode == 200) {
      Provider.of<UserPreferences>(context, listen: false)
          .setPaymentData(responseData['paymentData']);
    } else {
      if (responseData['serverError'] == null) {
        DialogError.show(context, 21, "");
      }
    }
    onProcessToggle();
  }

  @override
  Widget build(BuildContext context) {
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final Map<String, dynamic> paymentData =
        Provider.of<UserPreferences>(context).paymentData;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final Widget divider = Container(
        padding: EdgeInsets.only(right: 20, left: 20),
        child: Divider(color: Theme.of(context).primaryColor, thickness: .3));
    final Widget separator = SizedBox(height: isPortrait ? 10 : 15);
    final List<Widget> subscriptionOptions = paymentData['isValid'] == true &&
            paymentData['paymentType'] == "subscription"
        ? [
            separator,
            divider,
            separator,
            Padding(
              padding:
                  isPortrait ? EdgeInsets.all(0) : EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: isPortrait ? 232 : 200,
                child: ElevatedButton(
                  child: Row(
                    children: [
                      Icon(Icons.cancel_outlined),
                      SizedBox(width: 20),
                      Text(
                        "CANCELAR",
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: fullHD ? 17 : 16,
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  onPressed: () => cancelSubscription(),
                ),
              ),
            ),
          ]
        : [];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de pago"),
        titleSpacing: 1.0,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: onProcess
            ? Container(
                height: isPortrait ? screenHeight * 0.45 : screenHeight * 0.7,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text(
                        'Cancelando...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: fullHD ? 16 : 15,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  if (!premiumUser)
                    Padding(
                      child: AdNative("small"),
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      paymentDetail(isPortrait, screenWidth, paymentData),
                    ],
                  ),
                  ...subscriptionOptions,
                ],
              ),
      ),
      bottomNavigationBar: premiumUser ? null : const AdBanner(),
    );
  }
}
