import 'package:flutter/material.dart';
import '../services/_services.dart';

class FonoPack {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['detail']!},
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/fono_pack.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0810-888-3666",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "info@grupofonobus.com.ar",
      },
    ],
    "source": "https://fonobus.com.ar/seguimiento",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Fono Pack",
    "B-024-8019",
  );
}
