import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../widgets/ad_native.dart';
import '../widgets/ad_banner.dart';
import '../data/services.dart';

class Claim extends StatelessWidget {
  final String serviceName;
  const Claim(this.serviceName, {Key? key}) : super(key: key);

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

  List<List<Widget>> buttonList(
      BuildContext context, List<dynamic> buttonsData) {
    Widget generateButton(Map<String, dynamic> bData) {
      const Map<String, IconData> icons = {
        "phone": Icons.phone,
        "email": Icons.email,
        "whatsapp": Icons.whatsapp,
        "link": Icons.link,
      };
      return Padding(
        padding: EdgeInsets.all(10),
        child: SizedBox(
          width: 120,
          height: 100,
          child: ElevatedButton(
            child: Column(
              children: [
                Icon(icons[bData["type"]], size: 30),
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

  Widget claimComponent(
      BuildContext context, Map<String, dynamic> serviceData) {
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
            ...buttonList(context, serviceData['list']).map((e) => Row(
                  children: e,
                  mainAxisAlignment: MainAxisAlignment.center,
                )),
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
    final Map<String, dynamic> servicesData =
        Provider.of<Services>(context, listen: false).servicesData;
    final bool fullHD = MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio >
        1079;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.0,
        title: const Text('Reclamar'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                child: AdNative("small"),
                padding: EdgeInsets.only(bottom: 20),
              ),
              Text(
                "Si tiene algún problema con un envío (no hay datos, no se actualiza, no llega a destino, etc.), le proveemos medios para ponerse en contacto con la empresa correspondiente:",
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fullHD ? 17 : 16,
                ),
              ),
              Padding(
                child: claimComponent(
                    context, servicesData[serviceName]["contact"]),
                padding: EdgeInsets.only(top: 10),
              ),
              Padding(
                  child: AdNative("medium"), padding: EdgeInsets.only(top: 10)),
              SizedBox(width: 50, height: 50),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}
