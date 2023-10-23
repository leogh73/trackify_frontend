import 'package:flutter/material.dart';
import '../services/_services.dart';

class MercadoLibre {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['status']!},
      {"icon": Icons.description, "text": event['description']!},
    ];
  }

  static final Image serviceLogo = Image.asset('assets/other/mercadolibre.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "link",
        "title": "Chat Online",
        "data":
            "https://www.mercadolibre.com.ar/ayuda/chat/v2?hasCreditRestriction=false",
      },
    ],
    "source": "https://www.mercadolibre.com.ar/ayuda",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Mercado Libre",
    "42295858224",
  );
}
