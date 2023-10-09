import 'package:flutter/material.dart';
import '../services/_services.dart';

class Rutacargo {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['detail']!},
    ];
  }

  static final Image serviceLogo =
      Image.asset('assets/services/ruta_cargo.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "info@rutacargo.com.ar",
      },
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+541134345000",
      },
    ],
    "source": "https://rutacargo.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Rutacargo",
    "R-1194-00001646",
  );
}
