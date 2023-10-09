import 'package:flutter/material.dart';
import '../services/_services.dart';

class BalutExpress {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['description']!},
    ];
  }

  static final Image serviceLogo =
      Image.asset('assets/services/balut_express.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "link",
        "title": "Contacto",
        "data": "http://balutexpress.com.ar/#contact",
      },
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+5493886820299",
      },
    ],
    "source": "https://balutexpress.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Balut Express",
    "B0278-00026104",
  );
}
