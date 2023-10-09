import 'package:flutter/material.dart';
import '_services.dart';

class Andreani {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.place, "text": event['location']!},
      {"icon": Icons.local_shipping, "text": event['condition']!},
      {"icon": Icons.description, "text": event['motive']!},
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/andreani.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0800-122-1112",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "atenciondigital@andreani.com",
      }
    ],
    "source": "https://www.andreani.com/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Andreani",
    "360000070068800 ",
  );
}
