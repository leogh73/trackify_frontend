import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_uuid/device_uuid.dart';

import '../data/theme.dart';
import '../data/preferences.dart';

import '../widgets/ad_banner.dart';
import '../widgets/ad_interstitial.dart';
import '../widgets/ad_native.dart';
import '../widgets/mercado_pago_option.dart';
import '../widgets/mercado_pago_status.dart';

class MercadoPago extends StatefulWidget {
  final AdInterstitial adInterstitial;
  MercadoPago(this.adInterstitial, {Key? key}) : super(key: key);

  @override
  State<MercadoPago> createState() => _MercadoPagoState();
}

class _MercadoPagoState extends State<MercadoPago>
    with TickerProviderStateMixin {
  Map<String, String> _deviceData = {};
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

  @override
  Widget build(BuildContext context) {
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final Widget divider = Container(
        padding: EdgeInsets.only(right: 20, left: 20),
        child: Divider(color: Theme.of(context).primaryColor, thickness: .3));
    final Widget separator = SizedBox(height: isPortrait ? 5 : 15);
    final MaterialColor mainColor = Provider.of<UserTheme>(context).startColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Premium"),
        titleSpacing: 1.0,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    child: premiumUser ? null : AdNative("small"),
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 20, left: 25),
                    height:
                        isPortrait ? screenWidth * 0.36 : screenWidth * 0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.workspace_premium, size: 70),
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
                ],
              ),
            ),
            divider,
            Padding(
              padding: EdgeInsets.only(top: isPortrait ? 8 : 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ESTADO: ${premiumUser ? "ACTIVADO" : "NO ACTIVADO"}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  )
                ],
              ),
            ),
            MercadoPagoStatus(_deviceData, widget.adInterstitial, context),
            divider,
            MercadoPagoOption(
              premiumUser,
              widget.adInterstitial,
              "PAGO SIMPLE",
              'Realice un pago simple y utilice la versión Premium por 30 días. Puede renovar en cualquier momento.',
              Icons.payments,
              _deviceData,
              context,
            ),
            separator,
            divider,
            MercadoPagoOption(
              premiumUser,
              widget.adInterstitial,
              "SUSCRIPCIÓN",
              'Realice pagos automáticamente cada 30 días mediante tarjeta de débito o crédito. Puede cancelar en cualquier momento.',
              Icons.credit_card,
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
