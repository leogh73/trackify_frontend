import 'package:flutter/material.dart';
import '_services.dart';

class ExpresoLancioni {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['detail']!},
    ];
  }

  static final Image serviceLogo =
      Image.asset('assets/services/expreso_lancioni.png');

  Image get logo => serviceLogo;

  Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Atención al cliente",
        "data": "0810-345-0579",
      },
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+5493516162000",
      },
    ],
    "source": "https://expresolancioni.com/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Expreso Lancioni",
    "181572244",
  );
}
