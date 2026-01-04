import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
            Image.network(service["logoUrl"]), service['name']))
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

  static String filterString(String value) {
    String searchValue = value.trim().toLowerCase();
    String withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    String withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';
    for (int i = 0; i < withDia.length; i++) {
      searchValue = searchValue.replaceAll(withDia[i], withoutDia[i]);
    }
    return searchValue;
  }

  void filterServicesList(
    BuildContext context,
    String value,
    List<Map<String, dynamic>> services,
    String code,
  ) async {
    final String filteredValue = filterString(value);
    filteredList = services
        .where((s) => s["name"].contains(filteredValue))
        .map((s) => ServiceItemModel(s["logo"], s["originalName"]))
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

  Future<void> autoDetectServices(BuildContext context, String code,
      List<ServiceItemModel> servicesList) async {
    toggleIsAutodetecting(true);
    clearDetectedServices();
    clearStartService();
    if (code.length == 4) {
      if (isAutodetecting) {
        toggleIsAutodetecting(false);
      }
      if (isExpanded) {
        toggleIsExpanded(false);
      }
      return;
    }
    final BuildContext ctx = context;
    final String userId =
        Provider.of<UserPreferences>(ctx, listen: false).userId;
    final Object body = {'code': code.trim()};
    final Response response = await HttpConnection.requestHandler(
        '/api/user/$userId/autodetect', body);
    if (!ctx.mounted) {
      return;
    }
    final Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, ctx);
    toggleIsAutodetecting(false);
    if (response.statusCode != 200) {
      return;
    }
    final List<String> detectedServices =
        List<String>.from(responseData["result"]);
    if (detectedServices.isEmpty) {
      return;
    }
    if (detectedServices.length == 1) {
      loadService(detectedServices[0], ctx);
      if (isExpanded) {
        toggleIsExpanded(false);
      }
    } else {
      final List<ServiceItemModel> detectedModelServices = detectedServices
          .map((service) => servicesList.firstWhere((s) => s.name == service))
          .toList();
      Provider.of<Services>(context, listen: false)
          .setDetectedServices(detectedModelServices);
      clearStartService();
      if (!isExpanded) {
        toggleIsExpanded(true);
      }
    }
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
  ServiceItemModel(this.logo, this.name);
}
