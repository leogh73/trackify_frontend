import 'package:flutter/material.dart';
import '../services/_services.dart';

class Enviopack {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['detail']!},
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/enviopack.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "link",
        "title": "Contacto",
        "data": "https://www.enviopack.com/#contacto",
      },
    ],
    "source": "https://www.enviopack.com/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Enviopack",
    "5079800000001918356",
  );
}
