import 'package:flutter/material.dart';
import '../services/_services.dart';

class OCA {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": const Icon(Icons.place, size: 20), "text": event['location']!},
      {
        "icon": const Icon(Icons.local_shipping, size: 20),
        "text": event['status']!
      },
      {
        "icon": const Icon(Icons.description, size: 20),
        "text": event['motive']!
      },
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/oca.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0800-999-7700",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "atencionredes@oca.com.ar",
      },
      {
        "type": "link",
        "title": "Contacto",
        "data": "https://www.oca.com.ar/Contacto",
      },
    ],
    "source": "https://www.oca.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "OCA",
    "3867500000050334468",
  );
}
