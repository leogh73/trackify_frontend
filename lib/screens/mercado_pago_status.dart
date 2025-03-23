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
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final Map<String, dynamic> paymentData =
        Provider.of<UserPreferences>(context, listen: false).paymentData;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final MaterialColor mainColor = Provider.of<UserTheme>(context).startColor;
    final Widget divider = Container(
        child: Divider(color: Theme.of(context).primaryColor, thickness: .3));
    final Widget separator = SizedBox(height: isPortrait ? 5 : 15);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Estado Premium"),
        titleSpacing: 1.0,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              child: premiumUser ? null : AdNative("small"),
              padding: EdgeInsets.only(top: 5),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25, left: 25, top: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "ESTADO: ${!premiumUser ? 'NO ' : ''}ACTIVADO",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(top: isPortrait ? 8 : 0),
                    child: Text(
                      "${premiumUser ? "Muchas gracias por su compra." : "No hay pagos válidos asociados a éste dipositivo."}",
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
                      "VERIFICAR PAGOS",
                      "Si ya ha realizado un pago, verifique pagos automáticamente.",
                      "VERIFICAR",
                      Icons.monetization_on,
                      widget.deviceData,
                      paymentData,
                      context),
                  separator,
                  divider,
                  MercadoPagoOption(
                      premiumUser,
                      widget.adInterstitial,
                      "INGRESAR PAGO",
                      "Ingrese manualmente su pago, mediante el número de operación.",
                      "INGRESAR",
                      Icons.numbers,
                      widget.deviceData,
                      paymentData,
                      context),
                  separator,
                  divider,
                  MercadoPagoOption(
                      premiumUser,
                      widget.adInterstitial,
                      "DETALLE DE PAGO",
                      "Vea los detalles del pago asociado a su dispositivo.",
                      "VER",
                      Icons.info_outline,
                      widget.deviceData,
                      paymentData,
                      context),
                  separator,
                  SizedBox(height: 5)
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
