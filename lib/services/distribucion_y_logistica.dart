import 'package:flutter/material.dart';
import '_services.dart';

class DistribucionYLogistica {
  List<Map<String, dynamic>> eventData(event) =>
      Services.transoftEventData(event);

  static final Image serviceLogo =
      Image.asset('assets/services/distribucion_y_logistica.png');

  Image get logo => serviceLogo;

  final Map<String, dynamic> contactData = {
    "contact": [
      {
        "type": "phone",
        "title": "Teléfono",
        "data": "0291-4883636",
      },
      {
        "type": "email",
        "title": "Correo electrónico",
        "data": "administracion@dislog.com.ar",
      },
      {
        "type": "whatsapp",
        "title": "WhatsApp",
        "data": "+542915774449",
      },
    ],
    "source": "http://dislog.com.ar/contacto.html",
  };

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Distribución y Logística",
    "CC254965 ",
  );
}
