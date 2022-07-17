import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import "package:flutter_dotenv/flutter_dotenv.dart";

import '../providers/preferences.dart';

import '../widgets/ad_banner.dart';
import '../widgets/dialog_and_toast.dart';

class ServiceRequest extends StatefulWidget {
  const ServiceRequest({Key? key}) : super(key: key);

  @override
  State<ServiceRequest> createState() => _ServiceRequestState();
}

class _ServiceRequestState extends State<ServiceRequest> {
  bool formSuccess = false;
  int index = 0;

  final _formKey = GlobalKey<FormState>();

  final service = TextEditingController();
  final code = TextEditingController();
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
      String url = '${dotenv.env['API_URL']}/api/user/request/';
      String userId = Provider.of<Preferences>(context, listen: false).userId;
      var response = await http.Client().post(
        Uri.parse(url.toString()),
        body: {
          'userId': userId,
          'service': service.text,
          'code': code.text,
          'email': requestEmail,
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          index = 1;
          formSuccess = true;
        });
      } else {
        setState(() {
          index = 1;
          formSuccess = false;
        });
      }
      Navigator.pop(context);
    }
  }

  Widget requestForm(fullHD) {
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
                    "Sabemos que existen muchos más servicios de transporte de los que te ofrecemos. Si necesitás hacer un seguimiento de un servicio no disponible, podés completar el siguiente formulario, y de ser posible, agregaremos soporte para dicho servicio en una próxima actualización.",
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: fullHD ? 17 : 16,
                    ),
                  ),
                  Text(
                    "Advertencia: si haces mal uso de éste formulario, serás baneado.",
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.red[400],
                      fontSize: fullHD ? 17 : 16,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  focusNode: FocusNode(),
                  decoration: const InputDecoration(
                    labelText: "Nombre del servicio",
                    hintText: 'Ejemplo: "Hacha de Piedra"',
                    contentPadding: EdgeInsets.only(top: 5),
                  ),
                  controller: service,
                  textInputAction: TextInputAction.next,
                  autofocus: false,
                  validator: (value) {
                    if (value == null || value.length < 3) {
                      return 'Ingrese un nombre de servicio válido';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  focusNode: FocusNode(),
                  decoration: const InputDecoration(
                    labelText: "Código",
                    hintText: 'Asegúrate de que funcione',
                    contentPadding: EdgeInsets.only(top: 5),
                  ),
                  controller: code,
                  textInputAction: TextInputAction.next,
                  autofocus: false,
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'Ingrese un código de seguimiento válido';
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
                    labelText: "Email de contacto (opcional)",
                    hintText: "Por si hay problemas con los datos que mandes.",
                  ),
                  controller: email,
                  textInputAction: TextInputAction.next,
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
                          onPressed: () {
                            Navigator.pop(context);
                            // code.dispose();
                            // title.dispose();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          child: const Text(
                            "Enviar",
                            style: TextStyle(fontSize: 17),
                          ),
                          onPressed: () => _sendRequest(fullHD),
                        ),
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

  Widget sendingResult(fullHD) {
    return formSuccess
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.done_all, size: 80),
              const Padding(
                child: Text(
                  'Los datos fueron enviados correctamente. Muchísimas gracias por su colaboración.',
                  style: TextStyle(fontSize: 22),
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
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.error_outline, size: 80),
              const Padding(
                child: Text(
                  'Ocurrió un error al enviar los datos. Reintente más tarde. Disculpe las molestias ocasionadas.',
                  style: TextStyle(fontSize: 22),
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
                    setState(() {
                      index = 0;
                    });
                  },
                ),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    // var listView = "main";
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    List<Result> results = [
      Result(0, requestForm(fullHD)),
      Result(1, sendingResult(fullHD))
    ];
    var page = results[index].page;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.0,
        title: const Text('Ayúdanos a crecer'),
        actions: [
          if (!formSuccess)
            IconButton(
              icon: const Icon(Icons.send),
              iconSize: 26,
              onPressed: () => _sendRequest(fullHD),
            ),
        ],
      ),
      body: page,
      bottomNavigationBar: const BannerAdWidget(),
    );
  }
}

class Result {
  int index;
  Widget page;
  Result(this.index, this.page);
}
