import 'package:flutter/material.dart';
import '_services.dart';

class TrenqueLauquenExpreso {
  List<Map<String, dynamic>> eventData(event) =>
      Services.transoftEventData(event);

  static final Image serviceLogo =
      Image.asset('assets/services/trenque_lauquen_expreso.png');

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
    "source": "https://www.trenquelauquenexpreso.com/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Trenque Lauquen Expreso",
    "BS370000 ",
  );
}
