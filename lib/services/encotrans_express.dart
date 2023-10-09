import 'package:flutter/material.dart';
import '../services/_services.dart';

class EncotransExpress {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['status']!},
    ];
  }

  static final Image serviceLogo =
      Image.asset('assets/services/encotrans_express.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "011-3966-1134",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "info@encotrans.com.ar",
      },
    ],
    "source": "http://encotrans.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Encotrans Express",
    "R-1000-00000530",
  );
}
