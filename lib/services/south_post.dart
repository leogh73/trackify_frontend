import 'package:flutter/material.dart';
import '_services.dart';

class SouthPost {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['status']!},
    ];
  }

  static final Image serviceLogo =
      Image.asset('assets/services/south_post.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0810-345-7678",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "entrega@southpost.com.ar",
      },
      {
        "type": "link",
        "title": "Contacto",
        "data": "https://forms.office.com/r/7F1sQ4zS5R",
      }
    ],
    "source": "https://www.southpost.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "South Post",
    "3372131",
  );
}
