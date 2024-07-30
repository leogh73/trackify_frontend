import 'package:flutter/material.dart';
import 'dart:async';

import 'classes.dart';

import '../database.dart';
import '../initial_data.dart';

class Services with ChangeNotifier {
  StoredData storedData = StoredData();

  late Map<String, dynamic> servicesData;

  Services(StartData startData) {
    servicesData = startData.servicesData;
  }

  List<ServiceItemModel> itemModelList(bool mercadoLibre) {
    final List<ServiceItemModel> servicesItemModels =
        servicesData.values.map((service) {
      return ServiceItemModel(
        Image.network(service["logoUrl"]),
        service['name'],
        service['exampleCode'],
      );
    }).toList();
    if (!mercadoLibre)
      servicesItemModels.removeWhere((s) => s.chosen == "Mercado Libre");
    return servicesItemModels;
  }

  List<Map<String, dynamic>> eventData(
      String service, Map<dynamic, String> event) {
    const Map<String, IconData> iconsData = {
      "place": Icons.place,
      "location_city": Icons.location_city,
      "local_shipping": Icons.local_shipping,
      "description": Icons.description,
    };
    final List<dynamic> serviceData = servicesData[service]["event"];
    final List<Map<String, dynamic>> eventData = [];
    for (Map<String, dynamic> s in serviceData) {
      eventData.add({
        "icon": iconsData[s["iconType"]],
        "text": event[s["name"]],
      });
    }
    return eventData;
  }
}

class ServicesData {
  static Future<void> store(Map<String, dynamic> data) async {
    StoredData storedData = StoredData();
    UserData _storedPreferences = [...await storedData.loadUserData()][0];
    late UserData _newPreferences;
    _newPreferences = _storedPreferences.edit(servicesData: data);
    storedData.updatePreferences(_newPreferences);
  }
}

class ServiceItemModel {
  final Image logo;
  final String chosen;
  final String exampleCode;
  ServiceItemModel(this.logo, this.chosen, this.exampleCode);
}
