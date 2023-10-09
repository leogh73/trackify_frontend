import 'package:flutter/material.dart';
import '../services/_services.dart';

class LaVelozPack {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['detail']!},
    ];
  }

  static final Image serviceLogo =
      Image.asset('assets/services/la_veloz_pack.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "387-418-1550",
      },
      {
        "type": "link",
        "title": "Contacto",
        "data": "https://www.lavelozpack.com.ar/contacto/",
      },
    ],
    "source": "https://www.lavelozpack.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "La Veloz Pack",
    "1031205-23",
  );
}
