import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import '../data/preferences.dart';
import '../data/theme.dart';

import '../widgets/ad_banner.dart';
import '../widgets/ad_native.dart';

class MercadoPagoSubscription extends StatelessWidget {
  final String url;
  const MercadoPagoSubscription(this.url, {Key? key}) : super(key: key);

  void openSubscriptionUrl(BuildContext context) async {
    try {
      final int colorValue =
          Provider.of<UserTheme>(context, listen: false).startColor.value;
      await launch(
        url,
        customTabsOption: CustomTabsOption(toolbarColor: Color(colorValue)),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva suscripción"),
        titleSpacing: 1.0,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              child: premiumUser ? null : AdNative("small"),
              padding: EdgeInsets.only(top: 5, bottom: 5),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Luego de pagar, toque el botón 'Volver al sitio' y espere a ver una pantalla en blanco, para que recibamos la información sobre su suscripción:",
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: fullHD ? 17 : 16),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: .5),
                ),
                child: Image.network(
                    "https://raw.githubusercontent.com/leogh73/trackify_frontend/refs/heads/master/assets/other/mercado_pago_subscription.png"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'De lo contrario, envíe el número de transacción de su comprobante, desde la sección "INGRESAR PAGO".',
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: fullHD ? 17 : 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: 200,
                height: 45,
                child: ElevatedButton(
                  child: const Text(
                    "Aceptar y continuar",
                    style: TextStyle(fontSize: 17),
                  ),
                  onPressed: () => openSubscriptionUrl(context),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: premiumUser ? null : const AdBanner(),
    );
  }
}
