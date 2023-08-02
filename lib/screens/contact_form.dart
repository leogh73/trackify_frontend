import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:trackify/database.dart';
import 'package:trackify/providers/classes.dart';
import 'package:trackify/providers/http_request_handler.dart';

import '../providers/preferences.dart';
import '../providers/theme.dart';

import '../widgets/ad_banner.dart';
import '../widgets/ad_interstitial.dart';
import '../widgets/dialog_and_toast.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({Key? key}) : super(key: key);

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  AdInterstitial interstitialAd = AdInterstitial();

  @override
  void initState() {
    super.initState();
    interstitialAd.createInterstitialAd();
  }

  int index = 0;
  late Color mainColor;

  void loadColor() async {
    mainColor =
        ColorItem.load([...await StoredData().loadUserPreferences()][0].color);
  }

  final _formKey = GlobalKey<FormState>();

  final message = TextEditingController();
  final email = TextEditingController();

  void sendingDialog(fullHD) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(right: 5, left: 5),
          content: Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 25),
                    child: const SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  Text(
                    'Enviando...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: fullHD ? 16 : 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _sendRequest(fullHD) async {
    if (_formKey.currentState?.validate() == false) {
      ShowDialog(context).formError();
    } else {
      sendingDialog(fullHD);
      var requestEmail = 'Sin datos';
      if (email.text.isNotEmpty) requestEmail = email.text;
      String userId = Provider.of<Preferences>(context, listen: false).userId;
      Object body = {
        'userId': userId,
        'message': message.text,
        'email': requestEmail,
      };
      dynamic response =
          await HttpRequestHandler.newRequest('/api/user/contact/', body);
      if (response is Map)
        return ShowDialog(context).connectionServerError(false);
      if (response.statusCode == 200) {
        setState(() {
          index = 1;
        });
      } else if (response.statusCode == 400) {
        setState(() {
          index = 2;
        });
      } else {
        setState(() {
          index = 3;
        });
      }
      Navigator.pop(context);
    }
  }

  Widget requestForm(bool fullHD) {
    MaterialColor mainColor =
        Provider.of<UserTheme>(context, listen: false).startColor;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tu opinión es muy importante para nosotros. Si necesitas asistencia, tienes dudas, sugerencias o recomendaciones, puedes utlizar el siguiente formulario para contactarnos. Por ejemplo: si necesitás hacer un seguimiento de un servicio que no ofrecemos, puedes enviarnos un código de seguimiento funcional y el nombre de dicho servicio, y de ser posible, agregaremos soporte para el mismo, en una próxima actualización. De ser necesario, nos pondremos en contacto por correo electrónico y te responderemos a la brevedad.",
                    maxLines: 14,
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
                  maxLines: 5,
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
                                  interstitialAd.showInterstitialAd(),
                                  Navigator.pop(context),
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
                                  interstitialAd.showInterstitialAd(),
                                  _sendRequest(fullHD),
                                }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
            onPressed: () => {
              success
                  ? Navigator.pop(context)
                  : setState(() {
                      index = 0;
                    })
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    Map<int, Widget> results = {
      0: requestForm(fullHD),
      1: sendResult(
          'Su mensaje fue enviado correctamente.',
          'Muchas gracias por su tiempo. Nos pondremos en contacto de ser necesario.',
          true),
      2: sendResult(
          '',
          'Ocurrió un error al enviar los datos. El correo electrónico ingresado no es válido. Verifique y vuelva a intentarlo.',
          false),
      3: sendResult(
          '',
          'Ocurrió un error al enviar los datos. Reintente más tarde. Disculpe las molestias ocasionadas.',
          false)
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
                interstitialAd.showInterstitialAd(),
                _sendRequest(fullHD),
              },
            ),
        ],
      ),
      body: results[index],
      bottomNavigationBar: const AdBanner(),
    );
  }
}
