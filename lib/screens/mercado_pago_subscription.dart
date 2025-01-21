import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';
import '../widgets/ad_banner.dart';
import '../widgets/ad_native.dart';

import '../data/preferences.dart';

class MercadoPagoSubscription extends StatelessWidget {
  final String url;
  const MercadoPagoSubscription(this.url, {Key? key}) : super(key: key);

  void openSubscriptionUrl(BuildContext context) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
    Navigator.of(context).pop();
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
        Provider.of<UserPreferences>(context, listen: false).paymentData;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final Widget divider = Container(
        padding: EdgeInsets.only(right: 20, left: 20),
        child: Divider(color: Theme.of(context).primaryColor, thickness: .3));
    final Widget separator = SizedBox(height: isPortrait ? 5 : 15);
    // final bool errorPremiumOperation =
    //     Provider.of<UserPreferences>(context).errorPaymentOperation;
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
                "Luego de pagar, toque el botón 'Volver al sitio' y espere a ver una pantalla en blanco, para que podamos recibir información sobre su suscripción:",
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fullHD ? 18 : 17,
                ),
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
                    "https://images4.imagebam.com/cd/db/8b/MEYWKQE_o.png"),
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
                    "https://images4.imagebam.com/97/96/a9/MEYWKKR_o.png"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Si no lo hace, luego de efectuar su pago, deberá ingresarlo manualmente.",
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fullHD ? 17 : 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
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
