import 'package:flutter/material.dart';
import '_services.dart';

class TransDanExpress {
  List<Map<String, dynamic>> eventData(event) =>
      Services.eventServiceData("cristal", event);

  static final Image serviceLogo =
      Image.asset('assets/services/trans_dan_express.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+5491133401759",
      },
      {
        "type": "link",
        "title": "Contacto",
        "data": "https://transdanexpress.com/#contacto",
      },
    ],
    "source": "https://transdanexpress.com/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Trans Dan Express",
    "00065-000004273-U",
  );
}
