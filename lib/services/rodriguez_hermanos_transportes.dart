import 'package:flutter/material.dart';
import '_services.dart';

class RodriguezHermanosTransportes {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.place, "text": event['location']!},
      {"icon": Icons.local_shipping, "text": event['detail']!},
    ];
  }

  static final Image serviceLogo =
      Image.asset('assets/services/rodriguez_hermanos_transportes.png');

  Image get logo => serviceLogo;

  Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0341-4582986",
      }
    ],
    "source":
        "https://ar.todosnegocios.com/rodriguez-hnos-transportes-s-a-0341-458-2986",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Rodríguez Hermanos Transportes",
    "0000000183489-U",
  );
}
