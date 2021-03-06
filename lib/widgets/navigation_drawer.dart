import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:trackify/screens/service_request.dart';
import 'package:trackify/widgets/dialog_and_toast.dart';

import '../providers/preferences.dart';
import '../providers/trackings_active.dart';
import '../providers/trackings_archived.dart';

import '../screens/main.dart';
import '../screens/archived.dart';
// import '../screens/opciones.dart';
import '../screens/mercadolibre.dart';
import '../screens/googledrive.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  Widget optionAPI(VoidCallback openPage, Image imagen, double altura,
      double ancho, bool estadoCuenta) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: InkWell(
        onTap: openPage,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade400),
            ),
          ),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: altura, width: ancho, child: imagen),
              estadoCuenta
                  ? const Icon(Icons.account_circle_rounded)
                  : const Icon(Icons.account_circle_outlined),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool estadoMercadoLibre =
        Provider.of<Preferences>(context).meLiStatus;
    final bool estadoGoogleDrive = Provider.of<Preferences>(context).gdStatus;
    int mainAmount = Provider.of<ActiveTrackings>(context).trackings.length;
    int archivedAmount =
        Provider.of<ArchivedTrackings>(context).trackings.length;
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorLight
                ]),
              ),
              child: Column(
                children: <Widget>[
                  Material(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(100.0)),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/icon/icon.png",
                          height: 84, width: 84),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Trackify',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 25.0),
                    ),
                  ),
                ],
              )),
          optionAPI(
              () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GoogleDrive(),
                        ))
                  },
              Image.asset('assets/other/googledrive.png'),
              40,
              180,
              estadoGoogleDrive),
          optionAPI(
            () => {
              Navigator.pop(context),
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MercadoLibre(),
                ),
              ),
            },
            Image.asset('assets/other/mercadolibre.png'),
            38,
            155,
            estadoMercadoLibre,
          ),
          DrawerOption(Icons.local_shipping, "Activos ($mainAmount)",
              const Main(), true, false),
          DrawerOption(Icons.archive, "Archivados ($archivedAmount)",
              const Archived(), false, false),
          const DrawerOption(Icons.tag_faces, 'Ay??danos a crecer',
              ServiceRequest(), false, false),
          DrawerOption(Icons.info_outline, 'Acerca de ??sta aplicaci??n',
              ShowDialog(context).about, false, true),
        ],
      ),
    );
  }
}

class DrawerOption extends StatelessWidget {
  final dynamic icon;
  final String text;
  final dynamic destiny;
  final bool main;
  final bool about;

  const DrawerOption(this.icon, this.text, this.destiny, this.main, this.about,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        child: InkWell(
          onTap: () => {
            if (main) Navigator.pop(context),
            if (!main && !about)
              {
                Navigator.pop(context),
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => destiny!))
              },
            if (about) destiny(),
          },
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icon),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Text(
                      text,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
