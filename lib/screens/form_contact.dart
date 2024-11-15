import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'package:trackify/screens/claim.dart';
import 'package:trackify/widgets/dialog_toast.dart';

import '../database.dart';
import '../data/http_connection.dart';
import '../widgets/ad_native.dart';

import '../data/../data/preferences.dart';
import '../data/theme.dart';

import '../widgets/ad_banner.dart';
import '../widgets/ad_interstitial.dart';
import '../widgets/dialog_error.dart';

class FormContact extends StatefulWidget {
  const FormContact({Key? key}) : super(key: key);

  @override
  State<FormContact> createState() => _FormContactState();
}

class _FormContactState extends State<FormContact> {
  AdInterstitial interstitialAd = AdInterstitial();
  bool premiumUser = false;

  @override
  void initState() {
    super.initState();
    interstitialAd.createInterstitialAd();
  }

  int index = 0;
  late Color mainColor;

  void loadColor() async {
    mainColor =
        UserTheme.getColor[[...await StoredData().loadUserData()][0].color]!;
  }

  final formKey = GlobalKey<FormState>();

  final message = TextEditingController();
  final email = TextEditingController();

  @override
  void dispose() {
    message.dispose();
    email.dispose();
    super.dispose();
  }

  void sendRequest(fullHD) async {
    if (formKey.currentState?.validate() == false) {
      DialogError.formError(context);
    } else {
      ShowDialog.waiting(context, "Enviando...");
      String requestEmail = 'Sin datos';
      if (email.text.isNotEmpty) requestEmail = email.text;
      String userId =
          Provider.of<UserPreferences>(context, listen: false).userId;
      Object body = {
        'userId': userId,
        'message': message.text,
        'email': requestEmail,
      };
      Response response =
          await HttpConnection.requestHandler('/api/user/contact/', body);
      setState(() {
        index = 4;
        if (response.statusCode == 200) index = 1;
        if (response.statusCode == 403) index = 2;
        if (response.statusCode == 400) index = 3;
      });
      Navigator.pop(context);
      if (!premiumUser) interstitialAd.showInterstitialAd();
    }
  }

  Widget requestForm(bool fullHD) {
    MaterialColor mainColor =
        Provider.of<UserTheme>(context, listen: false).startColor;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            child: premiumUser ? null : AdNative("small"),
            padding: EdgeInsets.only(top: 10, bottom: 30),
          ),
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                children: [
                  if (!premiumUser)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Si tienes dudas, sugerencias o recomendaciones, puedes utlizar el siguiente formulario para contactarnos. De ser necesario, nos pondremos en contacto y te responderemos a la brevedad.",
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: fullHD ? 17 : 16,
                          ),
                        ),
                        Text(
                          "Advertencia: si haces mal uso de éste formulario, serás baneado.",
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.red[400],
                            fontSize: fullHD ? 17 : 16,
                          ),
                        ),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      maxLines: 3,
                      // focusNode: FocusNode(),
                      decoration: InputDecoration(
                          hintText: "Escriba su mensaje",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            width: 1,
                            color: mainColor,
                          ))),
                      controller: message,
                      textInputAction: TextInputAction.next,
                      autofocus: false,
                      validator: (value) {
                        if (value == null || value.length < 3) {
                          return 'Ingrese un mensage';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 5),
                        labelText: "Email de contacto",
                      ),
                      controller: email,
                      textInputAction: TextInputAction.next,
                      autofocus: false,
                      validator: (value) {
                        if (value == null || !value.contains("@")) {
                          return 'Ingrese un correo electrónico';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      if (!premiumUser)
                                        interstitialAd.showInterstitialAd(),
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
                                onPressed: () => {
                                      sendRequest(fullHD),
                                      if (!premiumUser)
                                        interstitialAd.showInterstitialAd(),
                                    }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 50, height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sendResult(String text1, String text2, bool success) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(success ? Icons.done_all : Icons.error_outline, size: 80),
        if (success)
          Padding(
            child: Text(
              text1,
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            padding: EdgeInsets.all(20),
          ),
        Padding(
          child: Text(
            text2,
            style: TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.all(20),
        ),
        SizedBox(
          width: 120,
          child: ElevatedButton(
            child: const Text(
              'Aceptar',
              style: TextStyle(fontSize: 17),
            ),
            onPressed: () {
              if (!premiumUser) interstitialAd.showInterstitialAd();
              Navigator.pop(context);
              if (index == 3)
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => Claim('')));
            },
          ),
        ),
      ],
    );
  }

  void togglePremiumStatus() {
    setState(() {
      premiumUser = !premiumUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool premiumStatus =
        Provider.of<UserPreferences>(context).premiumStatus;
    if (premiumStatus != premiumUser) {
      togglePremiumStatus();
    }
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final Map<int, Widget> results = {
      0: requestForm(fullHD),
      1: sendResult(
        'Su mensaje fue enviado correctamente.',
        'Muchas gracias por su tiempo. Nos pondremos en contacto de ser necesario.',
        true,
      ),
      2: sendResult(
        '',
        'Ocurrió un error al enviar los datos. El correo electrónico ingresado no es válido . Verifique y vuelva a intentarlo.',
        false,
      ),
      3: sendResult(
        '',
        'El formulario de contacto no es para hacer reclamos. La información que le proveemos, es la que informa la empresa de transporte. Si tiene problemas con un envío, debe comunicarse con dicha empresa. Ellos son los responsables de su encomienda',
        false,
      ),
      4: sendResult(
        '',
        'Ocurrió un error al enviar los datos. Reintente más tarde. Disculpe las molestias ocasionadas.',
        false,
      )
    };
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.0,
        title: const Text('Contáctanos'),
        actions: [
          if (index == 0)
            IconButton(
              icon: const Icon(Icons.send),
              iconSize: 26,
              onPressed: () => {
                if (!premiumUser) interstitialAd.showInterstitialAd(),
                sendRequest(fullHD),
              },
            ),
        ],
      ),
      body: results[index],
      bottomNavigationBar: premiumUser ? null : const AdBanner(),
    );
  }
}
