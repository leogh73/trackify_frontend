import 'package:flutter/material.dart';
import '../services/_services.dart';

class Epsa {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['status']!},
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/epsa.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "011-5236-5632",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "directorio@epsared.com.ar",
      },
    ],
    "source": "https://epsared.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Epsa",
    "3398289",
  );
}
