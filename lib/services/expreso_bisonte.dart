import 'package:flutter/material.dart';
import '_services.dart';

class ExpresoBisonte {
  List<Map<String, dynamic>> eventData(event) =>
      Services.transoftEventData(event);

  static final Image serviceLogo =
      Image.asset('assets/services/expreso_bisonte.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "3814090139",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "jsosa@expresobisonte.com",
      },
      {
        "type": "link",
        "title": "Contacto",
        "data": "https://www.expresobisonte.com/contacto",
      },
    ],
    "source": "https://www.expresobisonte.com/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Expreso Bisonte",
    "CC90113 ",
  );
}
