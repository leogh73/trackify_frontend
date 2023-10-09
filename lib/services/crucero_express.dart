import 'package:flutter/material.dart';
import '../services/_services.dart';

class CruceroExpress {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['detail']!},
    ];
  }

  static final Image serviceLogo =
      Image.asset('assets/services/crucero_express.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0810-345-7787",
      },
      {
        "type": "link",
        "title": "Chat online",
        "data": "https://tawk.to/chat/5f48fe80cc6a6a5947afb02a/default",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "cotizaciones@cruceroexpress.com.ar",
      },
    ],
    "source": "https://cruceroexpress.com.ar/#contacto",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Crucero Express",
    "R-0100-00622721",
  );
}
