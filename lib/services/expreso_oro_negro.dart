import 'package:flutter/material.dart';
import '_services.dart';

class ExpresoOroNegro {
  List<Map<String, dynamic>> eventData(event) =>
      Services.transoftEventData(event);

  static final Image serviceLogo =
      Image.asset('assets/services/expreso_oro_negro.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "011-5091-9000",
      },
      {
        "type": "email",
        "title": "Atención al cliente 1",
        "data": "cat1@expresooronegro.com",
      },
      {
        "type": "email",
        "title": "Atención al cliente 2",
        "data": "cat2@expresooronegro.com",
      },
    ],
    "source": "http://expresooronegro.com/pedido-cotizacion-express.php",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Expreso Oro Negro",
    "BB453956 ",
  );
}
