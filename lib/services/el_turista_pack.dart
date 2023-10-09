import 'package:flutter/material.dart';
import '../services/_services.dart';

class ElTuristaPack {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['detail']!},
    ];
  }

  static final Image serviceLogo =
      Image.asset('assets/services/el_turista_pack.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Call Center",
        "data": "0810-888-74782",
      },
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+5493516459121",
      },
    ],
    "source": "https://www.elturista.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "El Turista Pack",
    "A-0106-00002480",
  );
}
