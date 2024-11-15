import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_uuid/device_uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../widgets/ad_banner.dart';
import '../widgets/ad_interstitial.dart';
import '../widgets/ad_native.dart';
import '../widgets/mercado_pago_option.dart';

import '../data/preferences.dart';

class MercadoPago extends StatefulWidget {
  final AdInterstitial adInterstitial;
  MercadoPago(this.adInterstitial, {Key? key}) : super(key: key);

  @override
  State<MercadoPago> createState() => _MercadoPagoState();
}

class _MercadoPagoState extends State<MercadoPago> {
  Map<String, String> _deviceData = {};
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final DeviceUuid _deviceUuidPlugin = DeviceUuid();

  @override
  void initState() {
    super.initState();
    getDeviceData();
  }

  Future<void> getDeviceData() async {
    String uuid = '';
    try {
      uuid = await _deviceUuidPlugin.getUUID() ?? '';
    } catch (e) {
      print("Error getting UUID: $e");
    }
    Map<String, String> deviceData = {
      'userId': Provider.of<UserPreferences>(context, listen: false).userId,
      'uuid': uuid,
    };
    setState(() {
      _deviceData = deviceData;
    });
  }

  Widget paymentDetail(
      bool isPortrait, double screenWidth, Map<String, dynamic> paymentData) {
    const Map<String, IconData> statusIcon = {
      "approved": Icons.check,
      "pending": Icons.pending,
      "rejected": Icons.cancel_outlined,
      "authorized": Icons.check,
      "paused": Icons.pause,
      "cancelled": Icons.cancel,
    };
    const Map<String, String> statusText = {
      "approved": "Aprobado",
      "pending": "Pendiente",
      "rejected": "Rechazado",
      "authorized": "Autorizado",
      "paused": "Pausado",
      "cancelled": "Cancelado",
    };
    final List<List<dynamic>> dataList = [
      [
        Icons.numbers,
        statusIcon[paymentData["status"]],
        Icons.attach_money,
        Icons.calendar_month,
        Icons.timelapse,
        Icons.description_outlined,
      ],
      [
        "Operación",
        "Estado",
        "Tipo de pago",
        "Fecha",
        "Días restantes",
        "Válido"
      ],
      [
        paymentData["operationId"].toString(),
        statusText[paymentData["status"]],
        paymentData["paymentType"] == "simple" ? "Simple" : "Suscripción",
        paymentData["dateCreated"],
        paymentData["daysRemaining"].toString(),
        paymentData["isValid"].toString() == "true" ? "Si" : "No"
      ],
    ];

    return Container(
      width: isPortrait ? screenWidth * 0.8 : screenWidth * 0.6,
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: dataList[0]
                    .map((d) => Container(
                        height: 30,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(d, size: 22)],
                        )))
                    .toList(),
              ),
              Column(
                children: dataList[1]
                    .map((d) => Container(
                        height: 30,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(d,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16))
                          ],
                        )))
                    .toList(),
              ),
              Container(
                width: isPortrait ? screenWidth * 0.30 : screenWidth * 0.15,
                child: Column(
                  children: dataList[2]
                      .map((d) => Container(
                          height: 30,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(d,
                                  style: TextStyle(
                                      fontSize: 16,
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

  @override
  Widget build(BuildContext context) {
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final Map<String, dynamic> paymentData =
        Provider.of<UserPreferences>(context, listen: false).paymentData;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final Widget divider = Container(
        padding: EdgeInsets.only(right: 20, left: 20),
        child: Divider(color: Theme.of(context).primaryColor, thickness: .3));
    final Widget separator = SizedBox(height: isPortrait ? 5 : 10);
    final bool errorPremiumCheck =
        Provider.of<UserPreferences>(context).errorPaymentCheck;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Premium"),
        titleSpacing: 1.0,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!premiumUser)
              Padding(
                child: AdNative("small"),
                padding: EdgeInsets.only(top: 5, bottom: 5),
              ),
            Container(
              padding: const EdgeInsets.only(right: 20, left: 25),
              height: isPortrait ? screenWidth * 0.42 : screenWidth * 0.18,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.workspace_premium, size: 80),
                  Text(
                    "Mediante un pago mensual por dispositivo, puedes utilizar TrackeAR Premium, sin publicidades.",
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
            Container(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child:
                  Divider(color: Theme.of(context).primaryColor, thickness: 1),
            ),
            errorPremiumCheck
                ? MercadoPagoOption(
                    premiumUser,
                    widget.adInterstitial,
                    "Ocurrió un error al verficar los datos de su pago.",
                    [
                      {
                        "text": "REINTENTAR",
                        "icon": Icons.monetization_on,
                      }
                    ],
                    _deviceData,
                    context,
                  )
                : paymentData['operationId'] != null
                    ? paymentDetail(isPortrait, screenWidth, paymentData)
                    : MercadoPagoOption(
                        premiumUser,
                        widget.adInterstitial,
                        "Si ya ha realizado un pago pero reinstaló la aplicación, verifique pagos activos para su dispositivo.",
                        [
                          {
                            "text": "VERIFICAR",
                            "icon": Icons.monetization_on,
                          }
                        ],
                        _deviceData,
                        context,
                      ),
            separator,
            divider,
            MercadoPagoOption(
              premiumUser,
              widget.adInterstitial,
              'Realice un pago simple y utilice la versión Premium por 30 días. Puede renovar en cualquier momento.',
              [
                {
                  "text": "PAGO SIMPLE",
                  "icon": Icons.payments,
                }
              ],
              _deviceData,
              context,
            ),
            separator,
            divider,
            MercadoPagoOption(
              premiumUser,
              widget.adInterstitial,
              'Realice pagos automáticamente cada 30 días mediante tarjeta de débito o crédito.',
              paymentData["type"] == "subscription"
                  ? [
                      {"text": "PAUSAR", "icon": Icons.pause},
                      {"text": "CANCELAR", "icon": Icons.cancel_outlined},
                    ]
                  : [
                      {"text": "SUSCRIPCIÓN", "icon": Icons.credit_card}
                    ],
              _deviceData,
              context,
            ),
            separator,
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
