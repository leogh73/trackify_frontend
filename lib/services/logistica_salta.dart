import 'package:flutter/material.dart';
import '_services.dart';

class LogisticaSalta {
  List<Map<String, dynamic>> eventData(event) =>
      Services.transoftEventData(event);

  static final Image serviceLogo =
      Image.asset('assets/services/logistica_salta.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "administracion@logistica-salta.com.ar",
      },
      {
        "type": "whatsapp",
        "title": "Salta",
        "data": "+5493874146057",
      },
      {
        "type": "whatsapp",
        "title": "Buenos Aires",
        "data": "+5491132919530",
      },
      {
        "type": "whatsapp",
        "title": "Santa Fe",
        "data": "+5493412686496",
      },
    ],
    "source": "http://www.logistica-salta.com.ar/index.html#contacts1-c",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Logística Salta",
    "BA75029 ",
  );
}
