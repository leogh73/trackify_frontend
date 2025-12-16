import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/data/http_connection.dart';
import 'package:trackify/data/preferences.dart';
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

  List<ServiceItemModel> itemModelList(bool showStores) {
    final List<ServiceItemModel> servicesItemModels = servicesData.values
        .map((service) => ServiceItemModel(
              Image.network(service["logoUrl"]),
              service['name'],
              service['exampleCode'],
            ))
        .toList();
    if (!showStores) {
      servicesItemModels
          .removeWhere((element) => element.name == "Mercado Libre");
    }
    return servicesItemModels;
  }

  ServiceItemModel? loadedService;
  ServiceItemModel? get chosenService => loadedService;
  String messageService = '';
  String get serviceMessage => messageService;

  void loadService(String serviceName, BuildContext context) {
    final ServiceItemModel selectedService =
        Provider.of<Services>(context, listen: false)
            .itemModelList(true)
            .firstWhere((element) => element.name == serviceName);
    loadedService = selectedService;
    messageService = Provider.of<Services>(context, listen: false)
            .servicesData[selectedService.name]["selectionMessage"] ??
        '';
    notifyListeners();
  }

  void clearStartService() {
    loadedService = null;
    messageService = '';
    notifyListeners();
  }

  ServiceItemModel? claimService;
  ServiceItemModel? get claimSelectedService => claimService;

  void selectClaimService(ServiceItemModel service) {
    claimService = service;
    notifyListeners();
  }

  void clearClaimService() {
    claimService = null;
  }

  List<ServiceItemModel> filteredList = [];
  List<ServiceItemModel> get getFilteredList => filteredList;

  String searchInput = "";
  String get getSearchInput => searchInput;

  void filterServicesList(
    BuildContext context,
    String value,
    List<ServiceItemModel> services,
    String code,
  ) async {
    final String searchValue = value.toLowerCase();
    filteredList.clear();
    filteredList = services
        .where((s) => s.name.toLowerCase().contains(searchValue))
        .toList();
    if (filteredList.isEmpty &&
        value.trim().isNotEmpty &&
        code.trim().isNotEmpty) {
      final String userId =
          Provider.of<UserPreferences>(context, listen: false).userId;
      final Object body = {'code': code.trim(), "service": value.trim()};
      await HttpConnection.requestHandler(
          '/api/user/$userId/serviceNotFound', body);
    }
    searchInput = value;
    notifyListeners();
  }

  void clearFilteredList() {
    searchInput = "";
    filteredList = itemModelList(false);
  }

  bool isAutodetecting = false;
  bool get getIsAutodetecting => isAutodetecting;

  void toggleIsAutodetecting(bool newStatus) {
    isAutodetecting = newStatus;
    notifyListeners();
  }

  bool isExpanded = false;
  bool get getIsExpanded => isExpanded;

  void toggleIsExpanded(bool newStatus) {
    isExpanded = newStatus;
    notifyListeners();
  }

  List<ServiceItemModel> detectedServices = [];
  List<ServiceItemModel> get getDetectedServices => detectedServices;

  void setDetectedServices(List<ServiceItemModel> servicesList) {
    detectedServices = [...servicesList];
    notifyListeners();
  }

  void clearDetectedServices() {
    detectedServices.clear();
  }
}

class ServicesData {
  static Future<void> store(Map<String, dynamic> data) async {
    StoredData storedData = StoredData();
    UserData storedPreferences = [...await storedData.loadUserData()][0];
    late UserData newPreferences;
    newPreferences = storedPreferences.edit(servicesData: data);
    storedData.updatePreferences(newPreferences);
  }
}

class ServiceItemModel {
  final Image? logo;
  final String name;
  final String exampleCode;
  ServiceItemModel(this.logo, this.name, this.exampleCode);
}
