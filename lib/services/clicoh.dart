import 'package:flutter/material.dart';
import '../services/_services.dart';

class ClicOh {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['description']!},
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/clicoh.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "link",
        "title": "Soporte",
        "data": "https://clicoh.com/soporte/",
      },
    ],
    "source": "https://clicoh.com/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "ClicOh",
    "HWUIN94250",
  );
}
