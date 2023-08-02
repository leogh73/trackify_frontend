import '../services/andreani.dart';
import '../services/clicoh.dart';
import '../services/correo_argentino.dart';
import '../services/dhl.dart';
import '../services/ecapack.dart';
import '../services/enviopack.dart';
import '../services/fasttrack.dart';
import '../services/mdcargas.dart';
import '../services/oca.dart';
import '../services/ocasa.dart';
import '../services/renaper.dart';
import '../services/urbano.dart';
import '../services/viacargo.dart';

final Map<String, dynamic> servicesList = {
  "Andreani": Andreani(),
  "ClicOh": ClicOh(),
  "Correo Argentino": CorreoArgentino(),
  "DHL": DHL(),
  "EcaPack": EcaPack(),
  "Enviopack": Enviopack(),
  "FastTrack": FastTrack(),
  "MDCargas": MDCargas(),
  "OCA": OCA(),
  "OCASA": OCASA(),
  "Renaper": Renaper(),
  "Urbano": Urbano(),
  "ViaCargo": ViaCargo(),
};

class Response {
  static ItemResponseData dataHandler(
      String selectedService, dynamic data, bool update) {
    return update
        ? servicesList[selectedService].lastEvent(data)
        : servicesList[selectedService].createResponse(data);
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
