import 'package:flutter/material.dart';

import '_services.dart';

class CondorEstrella {
  List<Map<String, dynamic>> eventData(event) =>
      Services.eventServiceData("plusmar", event);

  static final Image serviceLogo =
      Image.asset('assets/services/condor_entrella.png');

  Image get logo => serviceLogo;

  Map<String, dynamic> get contactData =>
      Services.contactServiceData("Plusmar");

  final ServiceItemModel itemModel = ServiceItemModel(
    serviceLogo,
    "Plusmar",
    "R-0473-0061",
  );
}
