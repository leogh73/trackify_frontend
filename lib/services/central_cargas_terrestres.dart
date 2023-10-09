import 'package:flutter/material.dart';
import '../services/_services.dart';

class CentralDeCargasTerrestres {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['detail']!},
    ];
  }

  static final Image serviceLogo =
      Image.asset('assets/services/central_de_cargas_terrestres.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "011-4313-7421",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "clientes@cctsrl.com.ar",
      },
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+5491150095271",
      },
      {
        "type": "link",
        "title": "Contacto",
        "data": "https://cctsrl.com.ar/contacto/",
      },
    ],
    "source": "https://cctsrl.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Central de Cargas Terrestres",
    "R-1112-00009616",
  );
}
