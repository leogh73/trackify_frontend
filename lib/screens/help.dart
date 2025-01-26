import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/../data/preferences.dart';
import '../widgets/ad_banner.dart';
import '../widgets/ad_native.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    const List<Map<String, dynamic>> content = [
      {
        "question": "¿Qué es TrackeAR?",
        "answer":
            "TrackeAR es una aplicación para hacer seguimientos de envíos para Argentina.",
        'showAd': false,
      },
      {
        "question": "¿Cómo se usa?",
        "answer":
            "Toque el botón '+' en la pantalla principal, seleccione un servicio, ingrese un código, agregue opcionalmente un título (si no lo hace, el título será el código). Finalmente, toque el botón 'Agregar'. Reciba una notificación con cada nuevo movimiento. También tendrá la opción de archivarlos, renombrarlos o eliminarlos.",
        'showAd': false,
      },
      {
        "question": "¿Porqué mi seguimiento devuelve un error?",
        "answer":
            "Los errores al agregar o verificar seguimientos, pueden deberse a errores de nuestro servidor y/o el servicio seleccionado y/o el código ingresado. En cualquier caso, revise el código de seguimiento y reintente más tarde.",
        'showAd': false,
      },
      {
        "question":
            "¿Porqué al abrir la aplicación, recibo el mensaje 'Datos sincronizados'?",
        "answer":
            "Los datos de los seguimientos, se actualizan cada vez que toca una notificación de actualización de envío y entra a la aplicación. Pero, si no ha otorgado el permiso para recibir notificaciones, o las descarta sin abrir la aplicación, al iniciarla, los datos de sus seguimientos se actualizarán y se sincronizarán con los datos en nuestro servidor.",
        'showAd': true,
      },
      {
        "question": "¿Porqué tiene tanta publicidad?",
        "answer":
            "La aplicación funciona gracias a un servidor y una base de datos que no son gratuitos, deben pagarse todos los meses. Las publicidades permiten solventar dichos gastos y que la aplicación sea gratuita. Además, crear ésta aplicación, requirió cientos de horas. Los videos de publicidad, duran entre 2 y 5 segundos.",
        'showAd': false,
      },
      {
        "question": "¿Puedo pagar para usarla sin publicidades?",
        "answer":
            "Si, se admiten pagos por MercadoPago. Vea las opciones en la sección 'Premium'. Si realiza un pago, quedará asociado a su dispositivo: si reinstala la aplicación podrá actualizar su estado a Premium, pero si hace un reinicio de fábrica, deberá ingresar el número de operación para que verifiquemos su pago y actualicemos su estado.",
        'showAd': false,
      },
      {
        "question": "¿Cómo reclamo por un envío?",
        "answer":
            "Los seguimientos se realizan con la información que las empresas de transporte, ponen a disposición del público. Los creadores de ésta aplicación, no tenemos contacto exclusivo, ni relación alguna con dichas empresas. Por lo tanto, si tiene un problema con un envío, no debe contactarnos a nosotros, sino a la empresa de transporte correspondiente. Y para ello, le proveemos medios de contacto desde la opción 'Reclamar' en los seguimientos, y desde la sección 'Reclamo' en el menú lateral.",
        'showAd': false,
      },
      {
        "question": "¿Para qué sirve la sección 'Archivados'?",
        "answer":
            "Si tiene seguimientos que han finalizado pero no quiere eliminarlos, sino almacenarlos aparte, use la opción 'Archivar'. Los seguimientos se eliminarán de la pantalla principal, pero los seguirá viendo en la sección 'Archivados'. Advertencia: si archiva seguimientos activos, los mismos serán eliminados de nuestra base de datos y no se verificarán más.",
        'showAd': true,
      },
      {
        "question": "¿Para qué sirve la integración con Google Drive?",
        "answer":
            "Desde dicha sección puede iniciar sesión en su cuenta de Google y almacenar en Drive sus preferencias y seguimientos a modo de copia de seguirdad. En caso de que tenga muchos seguimientos y reinstale la aplicación, o cambie de dispositivo, puede usar esa copia de seguirdad para restaurar sus datos.",
        'showAd': false,
      },
      {
        "question": "¿Para qué sirve la integración con MercadoLibre?",
        "answer":
            "Desde dicha sección, puede iniciar sesión en su cuenta de MercadoLibre y desde allí, agregar y realizar seguimientos, tanto de sus compras, como de sus ventas.",
        'showAd': false,
      },
      {
        "question": "¿Que hago si tengo otra consulta, duda o recomendación?",
        "answer":
            "Desde la sección 'Contacto', utilice el formulario para ponerse en contacto con nosotros.",
        'showAd': false,
      },
    ];
    final List<Widget> contentList = content
        .map((item) =>
            HelpItem(item["question"]!, item["answer"]!, item["showAd"]))
        .toList();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.0,
        title: const Text(
          'Ayuda',
          style: TextStyle(fontSize: 19),
        ),
        actions: const <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!premiumUser) AdNative("small"),
            SizedBox(height: 8),
            ...contentList,
            if (!premiumUser) AdNative("small"),
          ],
        ),
      ),
      bottomNavigationBar: premiumUser ? null : const AdBanner(),
    );
  }
}

class HelpItem extends StatefulWidget {
  final String question;
  final String answer;
  final bool showAd;
  const HelpItem(this.question, this.answer, this.showAd, {super.key});

  @override
  State<HelpItem> createState() => _HelpItemState();
}

class _HelpItemState extends State<HelpItem> {
  bool expand = false;

  @override
  Widget build(BuildContext context) {
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
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
                  ? const EdgeInsets.only(right: 7, left: 7, top: 8, bottom: 8)
                  : const EdgeInsets.only(right: 2, left: 7, top: 8, bottom: 8),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          width:
                              isPortrait ? screenWidth * .79 : screenWidth * .9,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.question,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: fullHD ? 17 : 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                              expand ? Icons.expand_less : Icons.expand_more),
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
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 12, right: 8, left: 8, bottom: 8),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: isPortrait
                                    ? screenWidth - 54
                                    : screenWidth - 50,
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Text(
                                    widget.answer,
                                    style:
                                        TextStyle(fontSize: fullHD ? 17 : 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          child: premiumUser
              ? null
              : widget.showAd
                  ? const AdNative("small")
                  : null,
          padding: EdgeInsets.only(top: premiumUser ? 0 : 8, bottom: 8),
        ),
      ],
    );
  }
}
