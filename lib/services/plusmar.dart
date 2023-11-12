import 'package:flutter/material.dart';
import '../services/_services.dart';

class Plusmar {
  List<Map<String, dynamic>> eventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['status']!},
    ];
  }

  static final Image serviceLogo = Image.asset('assets/services/plusmar.png');

  Image get logo => serviceLogo;

  Map<String, dynamic> get contactData =>
      Services.contactServiceData("Plusmar");

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Plusmar",
    "R-0473-0061",
  );
}
