import 'package:flutter/material.dart';
import '../services/_services.dart';

class CorreoArgentino {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.place, "text": event['location']!},
      {"icon": Icons.local_shipping, "text": event['description']!},
      {"icon": Icons.description, "text": event['condition']!},
    ];
  }

  static final Image serviceLogo =
      Image.asset('assets/services/correo_argentino.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0810-777-7787",
      },
      {
        "type": "link",
        "title": "Atención al cliente",
        "data":
            "https://www.correoargentino.com.ar/atencion-al-cliente/centros-de-atencion-al-cliente",
      },
      {
        "type": "link",
        "title": "Reclamos",
        "data":
            "https://www.correoargentino.com.ar/atencion-al-cliente/reclamos",
      },
    ],
    "source": "https://www.correoargentino.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    Image.asset('assets/services/correo_argentino.png'),
    "Correo Argentino",
    "1627633PCMI321E001",
  );
}
