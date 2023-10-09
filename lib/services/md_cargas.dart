import 'package:flutter/material.dart';
import '../services/_services.dart';

class MDCargas {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {
        "icon": const Icon(Icons.local_shipping, size: 20),
        "text": event['status']!
      },
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/md_cargas.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "011-2093-0245",
      },
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+541160388170",
      },
    ],
    "source": "https://mdcargas.com/#/contacto",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "MD Cargas",
    "R-0505-00020601",
  );
}
