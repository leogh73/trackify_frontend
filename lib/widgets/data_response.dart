import 'package:trackify/widgets/services/mdcargas.dart';

import '../widgets/services/andreani.dart';
import '../widgets/services/clicoh.dart';
import '../widgets/services/correo_argentino.dart';
import '../widgets/services/dhl.dart';
import '../widgets/services/ecapack.dart';
import '../widgets/services/fasttrack.dart';
import '../widgets/services/oca.dart';
import '../widgets/services/ocasa.dart';
import '../widgets/services/renaper.dart';
import '../widgets/services/urbano.dart';
import '../widgets/services/viacargo.dart';

final Map<String, dynamic> servicesList = {
  "Andreani": Andreani(),
  "ClicOh": ClicOh(),
  "Correo Argentino": CorreoArgentino(),
  "DHL": DHL(),
  "EcaPack": EcaPack(),
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
