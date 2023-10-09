import 'package:flutter/material.dart';
import '_services.dart';

class FerrocargasDelSur {
  List<Map<String, dynamic>> eventData(event) =>
      Services.transoftEventData(event);

  static final Image serviceLogo =
      Image.asset('assets/services/ferrocargas_del_sur.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "2914142022",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "comercial@ferrocargas.com.ar",
      },
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+542914627094",
      },
    ],
    "source": "https://ferrocargas.com.ar/contacto",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Ferrocargas del Sur",
    "BA9519 ",
  );
}
