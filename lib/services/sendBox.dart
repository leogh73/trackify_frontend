import 'package:flutter/material.dart';
import '../services/_services.dart';

class SendBox {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.place, "text": event['locaton']! ?? "Sin datos"},
      {
        "icon": Icons.local_shipping,
        "text": event['status']! ?? event['description']!
      },
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/sendbox.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0810-999-0284",
      },
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+5491162028685",
      },
      {
        "type": "link",
        "title": "Contacto",
        "data": "https://www.sendbox.com.ar/contacto/",
      },
    ],
    "source": "https://www.sendbox.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "SendBox",
    "0126-00060635-220805",
  );
}
