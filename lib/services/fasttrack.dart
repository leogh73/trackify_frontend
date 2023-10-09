import 'package:flutter/material.dart';
import '../services/_services.dart';

class FastTrack {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['status']!},
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/fasttrack.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "info@fasttrack.com",
      },
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+541168173006",
      },
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0810-888-3278",
      },
    ],
    "source": "https://www.facebook.com/FasttrackArg",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "FastTrack",
    "101440340",
  );
}
