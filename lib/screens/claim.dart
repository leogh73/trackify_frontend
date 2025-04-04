import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../data/classes.dart';
import '../data/preferences.dart';
import '../data/services.dart';
import '../data/trackings_active.dart';

import '../widgets/ad_native.dart';
import '../widgets/ad_banner.dart';

class Claim extends StatefulWidget {
  final String serviceName;
  const Claim(this.serviceName, {Key? key}) : super(key: key);

  @override
  State<Claim> createState() => _ClaimState();
}

class _ClaimState extends State<Claim> {
  ServiceItemModel? selectedService;
  String? selectedServiceName;
  late List<ServiceItemModel> services;

  @override
  void initState() {
    super.initState();
    services =
        Provider.of<Services>(context, listen: false).itemModelList(true);
    if (widget.serviceName.isNotEmpty) {
      selectedServiceName = widget.serviceName;
      selectedService = services
          .firstWhere((element) => element.chosen == widget.serviceName);
    }
  }

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
            ...buttonList(context, serviceData['contact']['list'])
                .map((e) => Row(
                      children: e,
                      mainAxisAlignment: MainAxisAlignment.center,
                    )),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Fuente: ${serviceData["contact"]["source"]}",
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
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    final Map<String, dynamic> servicesData =
        Provider.of<Services>(context, listen: false).servicesData;
    final bool fullHD = MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio >
        1079;
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context).trackings;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.0,
        title: const Text('Reclamo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              child: premiumUser ? null : AdNative("small"),
              padding: EdgeInsets.only(top: 10, bottom: 10),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                children: [
                  Text(
                    "Los seguimientos se realizan con la información que las empresas de transporte, ponen a disposición del público. Los creadores de ésta aplicación, no tenemos contacto exclusivo, ni relación alguna con dichas empresas.",
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[400],
                      fontSize: fullHD ? 17 : 16,
                    ),
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
                    padding: EdgeInsets.only(top: 20),
                    child: DropdownButton<ServiceItemModel>(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      elevation: 4,
                      iconSize: 0,
                      hint: Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: SizedBox(
                          width: 150,
                          height: 80,
                          child: ElevatedButton(
                            child: const Text(
                              'Seleccionar servicio',
                              style: TextStyle(fontSize: 17),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {},
                          ),
                        ),
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
                            padding: const EdgeInsets.only(top: 1, bottom: 1),
                            width: 200,
                            child: service.logo,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (selectedService != null)
                    Padding(
                      child: claimComponent(
                          context, servicesData[selectedServiceName]),
                      padding: EdgeInsets.only(top: 10),
                    ),
                  if (!premiumUser && trackingsList.isNotEmpty)
                    Padding(
                      child: premiumUser ? null : AdNative("medium"),
                      padding: EdgeInsets.only(top: 20),
                    ),
                  SizedBox(width: 50, height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: premiumUser ? null : const AdBanner(),
    );
  }
}
