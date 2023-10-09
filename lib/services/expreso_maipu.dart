import 'package:flutter/material.dart';
import '_services.dart';

class ExpresoMaipu {
  List<Map<String, dynamic>> eventData(event) =>
      Services.transoftEventData(event);

  static final Image serviceLogo =
      Image.asset('assets/services/expreso_maipu.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "011-2206-2612",
      },
      {
        "type": "link",
        "title": "Contacto",
        "data": "https://expresomaipu.com/#contacto",
      },
    ],
    "source": "https://expresomaipu.com/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Expreso Maipú",
    "BS1049384 ",
  );
}
