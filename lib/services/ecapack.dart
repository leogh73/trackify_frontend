import 'package:flutter/material.dart';
import '../services/_services.dart';

class EcaPack {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.place, "text": event['location']!},
      {"icon": Icons.description, "text": event['sign']!},
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/ecapack.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "info@ecapack.com",
      },
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+541138420078",
      },
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0810-222-2450",
      },
    ],
    "source": "https://www.instagram.com/ecapacksrl/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "EcaPack",
    "RI-0044-2505",
  );
}
