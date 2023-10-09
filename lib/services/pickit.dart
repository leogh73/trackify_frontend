import 'package:flutter/material.dart';
import '../services/_services.dart';

class Pickit {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['title']!},
      {"icon": Icons.description, "text": event['description']!},
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/pickit.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0800-345-3451",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "contacto.ar@pickit.net",
      },
    ],
    "source": "https://pickit.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "pickit",
    "96KOJVEJ",
  );
}
