import 'package:flutter/material.dart';
import '../services/_services.dart';

class DHL {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.place, "text": event['location']!},
      {"icon": Icons.local_shipping, "text": event['description']!},
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/dhl.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "link",
        "title": "DHL Express - Contacto",
        "data":
            "https://mydhl.express.dhl/ar/es/help-and-support.html#/contact_us",
      }
    ],
    "source": "https://www.dhl.com/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "DHL",
    "2271618790",
  );
}
