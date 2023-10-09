import 'package:flutter/material.dart';
import '_services.dart';

class TransportesNandubay {
  List<Map<String, dynamic>> eventData(event) =>
      Services.transoftEventData(event);

  static final Image serviceLogo =
      Image.asset('assets/services/transportes_nandubay.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0343-4246315",
      },
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+543434646580",
      },
    ],
    "source": "https://www.transportesnandubay.com/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Transportes Ñandubay",
    "BS134386 ",
  );
}
