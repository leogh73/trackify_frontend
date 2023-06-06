import 'package:trackify/widgets/services/ecapack.dart';
import 'package:trackify/widgets/services/fasttrack.dart';
import 'package:trackify/widgets/services/renaper.dart';
import 'package:trackify/widgets/services/urbano.dart';

import '../widgets/services/andreani.dart';
import '../widgets/services/clicoh.dart';
import '../widgets/services/correo_argentino.dart';
import '../widgets/services/dhl.dart';
import '../widgets/services/oca.dart';
import '../widgets/services/ocasa.dart';
import 'services/viacargo.dart';

class ServiceData {
  dynamic service;
  String chosen;
  ServiceData(this.service, this.chosen);
}

dynamic selectedService(String serviceName, dynamic data) {
  List<ServiceData> servicesData = [
    ServiceData(DataAndreani(data), "Andreani"),
    ServiceData(DataClicOh(data), "ClicOh"),
    ServiceData(DataCorreoArgentino(data), "Correo Argentino"),
    ServiceData(DataDHL(data), "DHL"),
    ServiceData(DataEcaPack(data), "EcaPack"),
    ServiceData(DataFastTrack(data), "FastTrack"),
    ServiceData(DataOCA(data), "OCA"),
    ServiceData(DataOCASA(data), "OCASA"),
    ServiceData(DataRenaper(data), "Renaper"),
    ServiceData(DataUrbano(data), "Urbano"),
    ServiceData(DataViaCargo(data), "ViaCargo")
  ];
  int serviceIndex =
      servicesData.indexWhere((service) => service.chosen == serviceName);
  return servicesData[serviceIndex].service;
}

class Response {
  static start(serviceName, data) {
    return selectedService(serviceName, data).createResponse();
  }

  static update(serviceName, data) {
    return selectedService(serviceName, data).lastEvent();
  }
}

class ItemResponseData {
  final List<Map<String, String>>? events;
  final String? lastEvent;
  final List<List<String>?>? otherData;
  final String? checkDate;
  final String? checkTime;
  final String? trackingId;

  ItemResponseData(
    this.events,
    this.lastEvent,
    this.otherData,
    this.checkDate,
    this.checkTime,
    this.trackingId,
  );
}
