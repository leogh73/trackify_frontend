import 'package:flutter/material.dart';
import '_services.dart';

class ExpresoLoBruno {
  List<Map<String, dynamic>> eventData(event) =>
      Services.transoftEventData(event);

  static final Image serviceLogo =
      Image.asset('assets/services/expreso_lo_bruno.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "link",
        "title": "Contacto",
        "data": "https://expresolobruno.com.ar/cotacto",
      },
      {
        "type": "link",
        "title": "Reclamos",
        "data": "https://expresolobruno.com.ar/reclamos",
      },
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+5493856264696",
      },
    ],
    "source": "https://expresolobruno.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Expreso Lo Bruno",
    "BA57070868 ",
  );
}
