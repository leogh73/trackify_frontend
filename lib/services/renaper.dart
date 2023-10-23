import 'package:flutter/material.dart';
import '../services/_services.dart';

class Renaper {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['status']!},
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/renaper.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
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
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Renaper",
    "683357040",
  );
}
