import 'package:flutter/material.dart';
import 'package:trackify/screens/tracking_form.dart';
import 'package:trackify/widgets/ad_native.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/ad_banner.dart';

class Claim extends StatefulWidget {
  const Claim({Key? key}) : super(key: key);

  @override
  State<Claim> createState() => _ClaimState();
}

class _ClaimState extends State<Claim> {
  ServiceItemModel? selectedService;
  String? selectedServiceName;

  void buttonHandler(String type, String data) async {
    String prefix = '';
    if (type == "phone") prefix = "tel:";
    if (type == "email") prefix = "mailto:";
    if (type == "whatsapp") prefix = "whatsapp://send?phone=";
    String url = "$prefix$data";
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  final List<Map<String, dynamic>> servicesData = [
    {
      "image": Image.asset('assets/services/andreani.png'),
      "contact": [
        {
          "type": "phone",
          "title": "Teléfono",
          "icon": Icon(Icons.phone),
          "data": "0800-122-1112",
        },
        {
          "type": "email",
          "title": "Correo electrónico",
          "icon": Icon(Icons.email),
          "data": "atenciondigital@andreani.com",
        }
      ],
      "source": "https://www.andreani.com",
    },
    {
      "image": Image.asset('assets/services/clicoh.png'),
      "contact": [
        {
          "type": "link",
          "title": "Soporte",
          "icon": Icon(Icons.link),
          "data": "https://clicoh.com/soporte/",
        },
      ],
      "source": "https://clicoh.com",
    },
    {
      "image": Image.asset('assets/services/correoargentino.png'),
      "contact": [
        {
          "type": "phone",
          "title": "Teléfono",
          "icon": Icon(Icons.phone),
          "data": "0810-777-7787",
        },
        {
          "type": "link",
          "title": "Atención al cliente",
          "icon": Icon(Icons.link),
          "data":
              "https://www.correoargentino.com.ar/atencion-al-cliente/centros-de-atencion-al-cliente",
        },
        {
          "type": "link",
          "title": "Reclamos",
          "icon": Icon(Icons.link_rounded),
          "data":
              "https://www.correoargentino.com.ar/atencion-al-cliente/reclamos",
        },
      ],
      "source": "https://www.correoargentino.com.ar/",
    },
    {
      "image": Image.asset('assets/services/dhl.png'),
      "contact": [
        {
          "type": "link",
          "title": "DHL Express - Contacto",
          "icon": Icon(Icons.link),
          "data":
              "https://mydhl.express.dhl/ar/es/help-and-support.html#/contact_us",
        }
      ],
      "source": "https://www.dhl.com/",
    },
    {
      "image": Image.asset('assets/services/ecapack.png'),
      "contact": [
        {
          "type": "email",
          "title": "Correo electrónico",
          "icon": Icon(Icons.email),
          "data": "info@ecapack.com",
        },
        {
          "type": "whatsapp",
          "title": "WhatsApp",
          "icon": Icon(Icons.whatsapp),
          "data": "+541138420078",
        },
        {
          "type": "phone",
          "title": "Teléfono",
          "icon": Icon(Icons.phone),
          "data": "0810-222-2450",
        },
      ],
      "source": "https://www.instagram.com/ecapacksrl/",
    },
    {
      "image": Image.asset('assets/services/enviopack.png'),
      "contact": [
        {
          "type": "link",
          "title": "Contacto",
          "icon": Icon(Icons.link),
          "data": "https://www.enviopack.com/#contacto",
        },
      ],
      "source": "https://www.enviopack.com/",
    },
    {
      "image": Image.asset('assets/services/fasttrack.png'),
      "contact": [
        {
          "type": "email",
          "title": "Correo electrónico",
          "icon": Icon(Icons.email),
          "data": "info@fasttrack.com",
        },
        {
          "type": "whatsapp",
          "title": "WhatsApp",
          "icon": Icon(Icons.whatsapp),
          "data": "+541168173006",
        },
        {
          "type": "phone",
          "title": "Teléfono",
          "icon": Icon(Icons.phone),
          "data": "0810-888-3278",
        },
      ],
      "source": "https://www.facebook.com/FasttrackArg",
    },
    {
      "image": Image.asset('assets/services/mdcargas.png'),
      "contact": [
        {
          "type": "phone",
          "title": "Teléfono",
          "icon": Icon(Icons.phone),
          "data": "(011)2093-0245",
        },
        {
          "type": "whatsapp",
          "title": "WhatsApp",
          "icon": Icon(Icons.whatsapp),
          "data": "+541160388170",
        },
      ],
      "source": "https://mdcargas.com/#/contacto",
    },
    {
      "image": Image.asset('assets/services/oca.png'),
      "contact": [
        {
          "type": "phone",
          "title": "Teléfono",
          "icon": Icon(Icons.phone),
          "data": "0800-999-7700",
        },
        {
          "type": "email",
          "title": "Correo electrónico",
          "icon": Icon(Icons.email),
          "data": "atencionredes@oca.com.ar",
        },
        {
          "type": "link",
          "title": "Contacto",
          "icon": Icon(Icons.link),
          "data": "https://www.oca.com.ar/Contacto",
        },
      ],
      "source": "https://www.oca.com.ar/",
    },
    {
      "image": Image.asset('assets/services/ocasa.png'),
      "contact": [
        {
          "type": "phone",
          "title": "Teléfono",
          "icon": Icon(Icons.phone),
          "data": "0810-888-6227",
        }
      ],
      "source": "https://ocasa.com/logistica-general/es/",
    },
    {
      "image": Image.asset('assets/services/renaper.png'),
      "contact": [
        {
          "type": "email",
          "title": "Correo electrónico",
          "icon": Icon(Icons.email),
          "data": "consultas@renaper.gob.ar",
        },
        {
          "type": "whatsapp",
          "title": "WhatsApp",
          "icon": Icon(Icons.whatsapp),
          "data": "+541151261789",
        },
      ],
      "source": "https://www.argentina.gob.ar/interior/renaper/canales-renaper",
    },
    {
      "image": Image.asset('assets/services/urbano.png'),
      "contact": [
        {
          "type": "phone",
          "title": "Teléfono",
          "icon": Icon(Icons.phone),
          "data": "0810-222-8782",
        },
        {
          "type": "email",
          "title": "Correo electrónico",
          "icon": Icon(Icons.email),
          "data": "consultasurbano@urbano.com.ar",
        },
      ],
      "source": "https://www.instagram.com/urbanoexpress.arg/",
    },
    {
      "image": Image.asset('assets/services/viacargo.png'),
      "contact": [
        {
          "type": "link",
          "title": "Contacto",
          "icon": Icon(Icons.link),
          "data":
              "https://gtsviacargo.alertran.net/gts/pub/contactenos_via.seam?tacceso=DEP%20,",
        },
      ],
      "source": "https://www.viacargo.com.ar/support",
    },
  ];

  List<List<Widget>> buttonList(List<dynamic> buttonsData) {
    Widget generateButton(Map bData) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: SizedBox(
          width: 120,
          height: 100,
          child: ElevatedButton(
            child: Column(
              children: [
                bData["icon"],
                SizedBox(height: 5),
                Text(
                  bData["title"],
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (MediaQuery.of(context).size.width *
                                MediaQuery.of(context).devicePixelRatio >
                            1079)
                        ? 17
                        : 16,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            onPressed: () => buttonHandler(bData["type"], bData["data"]),
          ),
        ),
      );
    }

    List<Widget> list1 = [];
    List<Widget> list2 = [];
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    buttonsData.forEach(
      (bData) {
        isPortrait
            ? list1.length < 2
                ? list1.add(generateButton(bData))
                : list2.add(generateButton(bData))
            : list1.length < 4
                ? list1.add(generateButton(bData))
                : list2.add(generateButton(bData));
      },
    );
    return [list1, list2];
  }

  Widget claimComponent(Map serviceData) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: const BorderRadius.all(
            Radius.circular(18.0),
          ),
        ),
        // margin: EdgeInsets.only(bottom: 8),
        padding:
            const EdgeInsets.only(top: 20, left: 10, bottom: 10, right: 10),
        child: Column(
          children: [
            Row(
              children: buttonList(serviceData['contact'])[0],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            if (buttonList(serviceData['contact'])[1].isNotEmpty)
              Row(
                children: buttonList(serviceData['contact'])[1],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Fuente: ${serviceData["source"]}",
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: (MediaQuery.of(context).size.width *
                              MediaQuery.of(context).devicePixelRatio >
                          1079)
                      ? 17
                      : 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool fullHD = MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio >
        1079;
    final Map<String, Widget> servicesComponents = {
      "Andreani": claimComponent(servicesData[0]),
      "ClicOh": claimComponent(servicesData[1]),
      "Correo Argentino": claimComponent(servicesData[2]),
      "DHL": claimComponent(servicesData[3]),
      "EcaPack": claimComponent(servicesData[4]),
      "Enviopack": claimComponent(servicesData[5]),
      "FastTrack": claimComponent(servicesData[6]),
      "MDCargas": claimComponent(servicesData[7]),
      "OCA": claimComponent(servicesData[8]),
      "OCASA": claimComponent(servicesData[9]),
      "Renaper": claimComponent(servicesData[10]),
      "Urbano": claimComponent(servicesData[11]),
      "ViaCargo": claimComponent(servicesData[12]),
    };

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.0,
        title: const Text('Reclamo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                  child: AdNative("medium"),
                  padding: EdgeInsets.only(bottom: 20)),
              Text(
                "Ésta aplicación es para hacer seguimientos, a partir de la información que las empresas de transporte, ponen a disposición del público. No tenemos contacto exclusivo ni relación alguna dichas empresas.",
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[400],
                  fontSize: fullHD ? 17 : 16,
                ),
              ),
              Text(
                "Si tienes algún problema con un envío (no se actualiza, no llega a destino, etc.), selecciona a continuación la empresa y ponte en contacto con la misma.",
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fullHD ? 17 : 16,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: DropdownButton(
                  elevation: 4,
                  iconSize: 0,
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 36),
                    child: SizedBox(
                        width: 110,
                        child: ElevatedButton(
                            child: const Text(
                              'SERVICIO',
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () {})),
                  ),
                  iconEnabledColor: Theme.of(context).primaryColor,
                  value: selectedService,
                  underline: Container(),
                  onChanged: (ServiceItemModel? service) {
                    setState(() {
                      selectedService = service!;
                      selectedServiceName = service.chosen;
                    });
                  },
                  items: services.map<DropdownMenuItem<ServiceItemModel>>(
                      (ServiceItemModel service) {
                    return DropdownMenuItem<ServiceItemModel>(
                      value: service,
                      child: Container(
                        padding: const EdgeInsets.only(left: 5),
                        alignment: Alignment.center,
                        constraints:
                            BoxConstraints(maxHeight: 55, maxWidth: 180),
                        child: service.image,
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (selectedService != null)
                Padding(
                  child: servicesComponents[selectedServiceName],
                  padding: EdgeInsets.only(top: 10),
                ),
              Padding(
                  child: AdNative("medium"), padding: EdgeInsets.only(top: 10)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}
