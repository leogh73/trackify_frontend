import 'package:flutter/material.dart';
import '_services.dart';

class SerPaq {
  List<Map<String, dynamic>> eventData(event) =>
      Services.transoftEventData(event);

  static final Image serviceLogo = Image.asset('assets/services/serpaq.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "whatsapp",
        "title": "Rosario",
        "data": "+543416494049",
      },
      {
        "type": "whatsapp",
        "title": "Santa Fe",
        "data": "+543425458202",
      },
      {
        "type": "whatsapp",
        "title": "Paraná",
        "data": "+543425458202",
      },
      {
        "type": "link",
        "title": "Contacto",
        "data": "https://www.serpaq.com/#contacto",
      },
    ],
    "source": "https://www.serpaq.com/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "SerPaq",
    "CC129137 ",
  );
}
