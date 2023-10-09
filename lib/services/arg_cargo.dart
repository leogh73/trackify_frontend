import 'package:flutter/material.dart';
import '../services/_services.dart';

class ArgCargo {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.place, "text": event['location']!},
      {"icon": Icons.local_shipping, "text": event['status']!},
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/arg_cargo.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "011-4312-9376",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "info@argcargo.com.ar",
      },
    ],
    "source": "https://argcargo.com.ar/",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Arg Cargo",
    "B-0037-00005451",
  );
}
