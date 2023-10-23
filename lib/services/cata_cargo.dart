import 'package:flutter/material.dart';

import '_services.dart';

class CataCargo {
  List<Map<String, dynamic>> eventData(event) =>
      Services.eventServiceData("sisorg", event);

  static final Image serviceLogo =
      Image.asset('assets/services/cata_cargo.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "link",
        "title": "Contacto",
        "data": "http://catacargo.com/cargasyencomiendas/#contacto",
      },
      {
        "type": "whatsapp",
        "title": "Sanchez Marisa",
        "data": "+5492612483720",
      },
    ],
    "source": "http://catacargo.com/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Cata Cargo",
    "B1017-00006319",
  );
}
