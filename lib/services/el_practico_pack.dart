import 'package:flutter/material.dart';

import '_services.dart';

class ElPracticoPack {
  List<Map<String, dynamic>> eventData(event) =>
      Services.eventServiceData("sisorg", event);

  static final Image serviceLogo =
      Image.asset('assets/services/el_practico_pack.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "email",
        "title": "Reclamos",
        "data": "info@elpractico.com",
      },
    ],
    "source": "https://www.elpractico.com/encomiendas/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "El Práctico Pack",
    "B0278-00026104",
  );
}
