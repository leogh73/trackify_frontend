import 'package:flutter/material.dart';

import '_services.dart';

class IntegralPack {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.place, "text": event['location']},
      {"icon": Icons.location_city, "text": event['branch']},
      {"icon": Icons.local_shipping, "text": event['description']},
    ];
  }

  static final Image serviceLogo =
      Image.asset('assets/services/integral_pack.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0810-810-7225",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "clientes@integralexpress.com",
      },
    ],
    "source": "https://www.integralpack.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Integral Pack",
    "7982-B-253377",
  );
}
