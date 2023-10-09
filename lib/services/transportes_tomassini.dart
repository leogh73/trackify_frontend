import 'package:flutter/material.dart';
import '_services.dart';

class TransportesTomassini {
  List<Map<String, dynamic>> eventData(event) =>
      Services.transoftEventData(event);

  static final Image serviceLogo =
      Image.asset('assets/services/transportes_tomassini.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+542916438405",
      },
    ],
    "source": "https://tomassinisrl.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Transportes Tomassini",
    "BS134386 ",
  );
}
