import 'package:flutter/material.dart';
import '../services/_services.dart';

class CredifinLogistica {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.place, "text": event['location']!},
      {"icon": Icons.local_shipping, "text": event['status']!},
      {"icon": Icons.description, "text": event['description']!},
    ];
  }

  static final Image serviceLogo =
      Image.asset('assets/services/credifin_logistica.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Reclamos",
        "data": "03482-424000",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "casacentral@credifinexpress.com.ar",
      },
      {
        "type": "link",
        "title": "Contacto",
        "data": "https://credifin.com.ar/",
      },
    ],
    "source": "https://credifin.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Credifin Logística",
    "111211290373251157",
  );
}
