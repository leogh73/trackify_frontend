import 'package:flutter/material.dart';
import '_services.dart';

class ExpresoRocinante {
  List<Map<String, dynamic>> eventData(event) =>
      Services.transoftEventData(event);

  static final Image serviceLogo =
      Image.asset('assets/services/expreso_rocinante.png');

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
        "data": "+542954546202",
      },
      {
        "type": "link",
        "title": "Denuncias",
        "data": "https://forms.gle/8u7PZChmbL6rnNGu9",
      },
    ],
    "source": "https://www.expresorocinante.com/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Expreso Rocinante",
    "BB453956 ",
  );
}
