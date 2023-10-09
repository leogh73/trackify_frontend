import 'package:flutter/material.dart';
import '../services/_services.dart';

class PulquiPack {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['description']!},
    ];
  }

  static final Image serviceLogo =
      Image.asset('assets/services/pulqui_pack.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0810-810-9999",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "atencionalcliente@pulquipacksrl.com.ar",
      },
    ],
    "source": "https://www.pulquipacksrl.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Pulqui Pack",
    "0263-B-00004157",
  );
}
