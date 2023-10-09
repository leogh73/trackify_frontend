import 'package:flutter/material.dart';
import '_services.dart';

class ExpresoBibiloni {
  List<Map<String, dynamic>> eventData(event) =>
      Services.transoftEventData(event);

  static final Image serviceLogo =
      Image.asset('assets/services/expreso_bibiloni.jpg');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "whatsapp",
        "title": "Olavarria",
        "data": "+54228533361",
      },
      {
        "type": "whatsapp",
        "title": "Capital Federal",
        "data": "+541150083441",
      },
    ],
    "source": "https://www.instagram.com/expresobibiloni",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Expreso Bibiloni",
    "BA59767 ",
  );
}
