import 'package:flutter/material.dart';
import '../services/_services.dart';

class OCASA {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['detail']!},
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/ocasa.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0810-888-6227",
      }
    ],
    "source": "https://ocasa.com/logistica-general/es/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "OCASA",
    "EC2FQ31777987",
  );
}
