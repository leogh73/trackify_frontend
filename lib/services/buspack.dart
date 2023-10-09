import 'package:flutter/material.dart';
import '../services/_services.dart';

class Buspack {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['detail']!},
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/buspack.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "11-3990-8282",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "atencionalcliente@buspack.com.ar",
      },
      {
        "type": "link",
        "title": "Contacto",
        "data": "https://www.buspack.com.ar/contacto/",
      },
    ],
    "source": "https://www.buspack.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Buspack",
    "1031205-23",
  );
}
