import 'package:flutter/material.dart';

import '_services.dart';

class NanduPack {
  List<Map<String, dynamic>> eventData(event) =>
      Services.eventServiceData("sisorg", event);

  static final Image serviceLogo = Image.asset('assets/services/nandupack.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Atención al cliente",
        "data": "0800-555-0579",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "info@nandudelsur.com",
      },
    ],
    "source": "https://www.nandudelsur.com/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "ÑanduPack",
    "B0278-00026104",
  );
}
