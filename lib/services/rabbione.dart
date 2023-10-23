import 'package:flutter/material.dart';

import '_services.dart';

class Rabbione {
  List<Map<String, dynamic>> eventData(event) =>
      Services.eventServiceData("cristal", event);

  static final Image serviceLogo = Image.asset('assets/services/rabbione.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "link",
        "title": "Contacto",
        "data": "http://www.rabbione.com.ar/pedidos",
      },
    ],
    "source": "http://www.rabbione.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Rabbione",
    "00017-0000873-U",
  );
}
