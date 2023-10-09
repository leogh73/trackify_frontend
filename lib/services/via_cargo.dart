import 'package:flutter/material.dart';
import '../services/_services.dart';

class ViaCargo {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": const Icon(Icons.place, size: 20), "text": event['location']!},
      {
        "icon": const Icon(Icons.local_shipping, size: 20),
        "text": event['status']!
      },
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/via_cargo.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "link",
        "title": "Contacto",
        "data":
            "https://gtsviacargo.alertran.net/gts/pub/contactenos_via.seam?tacceso=DEP%20,",
      },
    ],
    "source": "https://www.viacargo.com.ar/support",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Via Cargo",
    "999015276642",
  );
}
