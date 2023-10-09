import 'package:flutter/material.dart';
import '_services.dart';

class AndesmarCargas {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.place, "text": event['location']!},
      {"icon": Icons.local_shipping, "text": event['description']!},
    ];
  }

  static final Image serviceLogo =
      Image.asset('assets/services/andesmar_cargas.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0810-122-4300",
      },
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+5492615577328",
      },
      {
        "type": "link",
        "title": "Link",
        "data": "https://andesmarcargas.com/contacto.html",
      }
    ],
    "source": "https://andesmarcargas.com/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Andesmar Cargas",
    "114790",
  );
}
