import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/preferences.dart';
import 'dialog_toast.dart';

class DialogError {
  static void show(BuildContext context, int errorNumber, String service) {
    final Map<int, dynamic> texts =
        Provider.of<UserPreferences>(context, listen: false).selectedLanguage;

    Map<int, String> messages = {
      1: texts[125]!,
      2: texts[126]!,
      3: texts[127]!,
      4: texts[128]!,
      5: texts[129]!,
      6: texts[130]!,
      7: texts[131]!,
      8: texts[132]!,
      9: texts[133]!,
      10: texts[134]!,
      11: texts[135]!,
      12: texts[136]!,
      13: texts[137]!,
      14: texts[138]!,
      15: texts[139]!,
      16: texts[140]!,
      17: texts[141]!,
      18: texts[142]!,
      19: texts[143]!,
      20: texts[144]!,
      21: texts[145]!,
      22: texts[242]!,
    };

    ShowDialog.error(
      context,
      service.isEmpty
          ? messages[errorNumber]!
          : messages[errorNumber]!.replaceAll("service", service),
      service,
      texts,
    );
  }
}
