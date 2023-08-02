import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:trackify/database.dart';
import 'package:trackify/providers/classes.dart';
import 'package:trackify/providers/http_request_handler.dart';
import 'package:trackify/widgets/services_check.dart';

import '../providers/preferences.dart';
import '../providers/theme.dart';

import '../widgets/ad_banner.dart';
import '../widgets/dialog_and_toast.dart';

class ServicesStatus extends StatelessWidget {
  const ServicesStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool fullHD = MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio >
        1079;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.0,
        title: const Text('Estado de servicios'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Dependemos de la información que proveen las empresas de transporte. Si alguna presenta fallas o demoras, es posible que, temporalmente, no se puedan agregar nuevos envíos, ni verificar los ya existentes.",
                maxLines: 14,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fullHD ? 17 : 16,
                ),
              ),
              Text(
                "El funcionamiento de cada servicio, es exclusiva responsabilidad de la empresa correspondiente.",
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[400],
                  fontSize: fullHD ? 17 : 16,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: ServicesCheck(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}
