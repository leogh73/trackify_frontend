import 'package:flutter/material.dart';
import '_services.dart';

class CruzDelSur {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.place, "text": event['branch']!},
      {"icon": Icons.local_shipping, "text": event['detail']!},
    ];
  }

  static final Image serviceLogo =
      Image.asset('assets/services/cruz_del_sur.png');

  Image get logo => serviceLogo;

  Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "011-4480-6666",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "atencionalcliente@cruzdelsur.com",
      },
      {
        "type": "link",
        "title": "Contacto",
        "data": "https://www.cruzdelsur.com/contacto.php",
      }
    ],
    "source": "https://www.clicpaq.com/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Cruz del Sur",
    "115209907",
  );
}
