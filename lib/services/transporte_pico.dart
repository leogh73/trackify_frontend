import 'package:flutter/material.dart';
import '_services.dart';

class TransportePico {
  List<Map<String, dynamic>> eventData(event) =>
      Services.transoftEventData(event);

  static final Image serviceLogo =
      Image.asset('assets/services/transporte_pico.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0810-112-0775",
      },
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+5492954546202",
      },
    ],
    "source": "https://www.transportepico.com/consultas/index.php",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Transporte Pico",
    "BS370000 ",
  );
}
