import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_uuid/device_uuid.dart';
import 'package:http/http.dart';

import '../data/classes.dart';
import '../data/trackings_active.dart';
import '../widgets/ad_banner.dart';
import '../widgets/ad_interstitial.dart';
import '../widgets/dialog_error.dart';
import '../widgets/ad_native.dart';

import '../data/preferences.dart';
import '../data/http_connection.dart';

class MercadoPagoInput extends StatefulWidget {
  const MercadoPagoInput({super.key});

  @override
  State<MercadoPagoInput> createState() => _MercadoPagoInputState();
}

class _MercadoPagoInputState extends State<MercadoPagoInput> {
  AdInterstitial interstitialAd = AdInterstitial();
  bool checking = false;
  bool expand = false;
  final DeviceUuid _deviceUuidPlugin = DeviceUuid();

  @override
  void initState() {
    super.initState();
    interstitialAd.createInterstitialAd();
  }

  final formKey = GlobalKey<FormState>();
  final transactionId = TextEditingController();

  @override
  void dispose() {
    transactionId.dispose();
    super.dispose();
  }

  void checkPaymentId() async {
    if (formKey.currentState?.validate() == false) {
      DialogError.show(context, 3, "");
      return;
    }
    setState(() {
      checking = true;
    });
    String uuid = '';
    try {
      uuid = await _deviceUuidPlugin.getUUID() ?? '';
    } catch (e) {
      print("Error getting UUID: $e");
    }
    final String userId =
        Provider.of<UserPreferences>(context, listen: false).userId;
    Object body = {
      'userId': userId,
      'uuid': uuid,
      'transactionId': transactionId.text,
    };
    Response response = await HttpConnection.requestHandler(
        '/api/mercadopago/checkPaymentId', body);
    final Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, context);
    if (response.statusCode == 200) {
      if (responseData['result'] == "payment not found") {
        DialogError.show(context, 17, "");
      } else {
        Provider.of<UserPreferences>(context, listen: false)
            .setPaymentData(responseData['result']);
        if (responseData['result']['isValid'] == false) {
          DialogError.show(context, 19, "");
        } else {
          Navigator.of(context).pop();
        }
      }
    } else {
      if (responseData['serverError'] == null) {
        DialogError.show(context, 21, "");
      }
    }
    setState(() {
      checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ingresar pago"),
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
              checking
                  ? Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 25, bottom: 25),
                          child: const SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        Text(
                          'Verificando...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: fullHD ? 16 : 15,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                          ),
                        ),
                      ],
                    )
                  : Form(
                      key: formKey,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: Column(
                          children: [
                            Text(
                              "Busque el detalle de operación en su cuenta de MercadoPago e ingrese el número que figura en la parte superior:",
                              maxLines: 8,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: fullHD ? 17 : 16,
                              ),
                            ),
                            TextFormField(
                              focusNode: FocusNode(),
                              decoration: InputDecoration(
                                labelText: "Número de operación",
                              ),
                              controller: transactionId,
                              textInputAction: TextInputAction.next,
                              autofocus: false,
                              validator: (value) {
                                if (value == null || value.length < 5) {
                                  return 'Ingrese un número válido';
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: ElevatedButton(
                                          child: const Text(
                                            'Cancelar',
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          onPressed: () => {
                                                Navigator.pop(context),
                                                if (!premiumUser &&
                                                    trackingsList.length > 1)
                                                  interstitialAd
                                                      .showInterstitialAd(),
                                              }),
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 120,
                                      child: ElevatedButton(
                                        child: const Text(
                                          "Enviar",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        onPressed: checkPaymentId,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 50, height: 10),
                          ],
                        ),
                      ),
                    ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 5, bottom: 5),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          expand = !expand;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: .5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                        padding: isPortrait
                            ? const EdgeInsets.only(
                                right: 7, left: 7, top: 8, bottom: 8)
                            : const EdgeInsets.only(
                                right: 2, left: 7, top: 8, bottom: 8),
                        child: Column(
                          children: [
                            Container(
                              padding: isPortrait
                                  ? const EdgeInsets.only(right: 4)
                                  : !isPortrait
                                      ? const EdgeInsets.only(right: 2)
                                      : null,
                              height: 55,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    width: isPortrait
                                        ? screenWidth * .75
                                        : screenWidth * .8,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "¿Dónde encuentro el número de operación?",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: fullHD ? 17 : 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(expand
                                        ? Icons.expand_less
                                        : Icons.expand_more),
                                    onPressed: () {
                                      setState(() {
                                        expand = !expand;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            if (expand)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: screenWidth - 45,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: .5),
                                            ),
                                            child: Image.network(
                                                "https://raw.githubusercontent.com/leogh73/trackify_frontend/refs/heads/master/assets/other/mercado_pago_detail.png"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
      ),
      bottomNavigationBar: premiumUser ? null : const AdBanner(),
    );
  }
}
