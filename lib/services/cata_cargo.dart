import 'package:flutter/material.dart';
import '../services/_services.dart';

class CataCargo {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['description']!},
    ];
  }

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
