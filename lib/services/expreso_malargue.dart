import 'package:flutter/material.dart';

import '_services.dart';

class ExpresoMalargue {
  List<Map<String, dynamic>> eventData(event) =>
      Services.eventServiceData("cristal", event);

  static final Image serviceLogo =
      Image.asset('assets/services/expreso_malargue.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+5491163622778",
      },
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0810-112-2020",
      },
    ],
    "source": "https://expresomalargue.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Expreso Malargüe",
    "0002-000000084478-U",
  );
}
