import 'package:flutter/material.dart';
import '_services.dart';

class ExpresoInterprovincial {
  List<Map<String, dynamic>> eventData(event) =>
      Services.transoftEventData(event);

  static final Image serviceLogo =
      Image.asset('assets/services/expreso_interprovincial.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "link",
        "title": "Contacto",
        "data": "https://www.interprovincialsrl.com.ar/contacto/",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "presupuestos@interprovincialsrl.com.ar",
      },
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+5492915744420",
      },
    ],
    "source": "https://www.interprovincialsrl.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Expreso Interprovincial",
    "BB453956 ",
  );
}
