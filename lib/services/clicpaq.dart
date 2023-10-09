import 'package:flutter/material.dart';
import '_services.dart';

class Clicpaq {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.place, "text": event['location']!},
      {"icon": Icons.local_shipping, "text": event['status']!},
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/clicpaq.png');

  Image get logo => serviceLogo;

  Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "link",
        "title": "Chat online",
        "data": "https://www.clicpaq.com/",
      }
    ],
    "source": "https://www.clicpaq.com/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Clicpaq",
    "6935334",
  );
}
