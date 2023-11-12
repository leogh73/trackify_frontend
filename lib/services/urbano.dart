import 'package:flutter/material.dart';
import '../services/_services.dart';

class Urbano {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.place, "text": event['location']!},
      {"icon": Icons.local_shipping, "text": event['status']!},
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/urbano.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0810-222-8782",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "consultasurbano@urbano.com.ar",
      },
    ],
    "source": "https://www.instagram.com/urbanoexpress.arg/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Urbano",
    "0000000043168668",
  );
}
