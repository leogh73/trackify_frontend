import 'package:flutter/material.dart';
import '../services/_services.dart';

class Plusmar {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {
        "icon": const Icon(Icons.local_shipping, size: 20),
        "text": event['status']!
      },
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/plusmar.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Atención al cliente",
        "data": "0800-666-2993",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "atencionalcliente@plusmar.com.ar",
      },
    ],
    "source": "https://www.plusmar.com.ar/servicio-de-encomiendas.html",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Plusmar",
    "R-0473-0061",
  );
}
