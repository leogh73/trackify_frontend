import 'package:flutter/material.dart';

import '_services.dart';

class CooperativaSportman {
  List<Map<String, dynamic>> eventData(event) =>
      Services.eventServiceData("sisorg", event);

  static final Image serviceLogo =
      Image.asset('assets/services/cooperativa_sportman.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "link",
        "title": "Contacto",
        "data": "https://www.coopsportman.com/contacto",
      },
      {
        "type": "email",
        "title": "Cargas",
        "data": "cargas@coopsportman.com",
      },
    ],
    "source": "https://www.coopsportman.com/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Cooperativa Sportman",
    "R0035-00039276",
  );
}
