import 'package:flutter/material.dart';

import '_services.dart';

class RodriguezHermanosTransportes {
  List<Map<String, dynamic>> eventData(event) =>
      Services.eventServiceData("cristal", event);

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
    "00021-0000183489-U",
  );
}
