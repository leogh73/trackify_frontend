import 'package:flutter/material.dart';

import 'andesmar_cargas.dart';
import 'andreani.dart';
import 'arg_cargo.dart';
import 'balut_express.dart';
import 'buspack.dart';
import 'cata_cargo.dart';
import 'central_cargas_terrestres.dart';
import 'clicoh.dart';
import 'clicpaq.dart';
import 'cooperativa_sportman.dart';
import 'correo_argentino.dart';
import 'condor_estrella.dart';
import 'credifinLogistica.dart';
import 'crucero_express.dart';
import 'cruz_del_sur.dart';
import 'dhl.dart';
import 'ecapack.dart';
import 'el_practico_pack.dart';
import 'el_turista_pack.dart';
import 'encotrans_express.dart';
import 'enviopack.dart';
import 'expreso_lancioni.dart';
import 'expreso_malargue.dart';
import 'epsa.dart';
import 'fasttrack.dart';
import 'fono_pack.dart';
import 'integral_pack.dart';
import 'jetmar.dart';
import 'mercado_libre.dart';
import 'md_cargas.dart';
import 'nandupack.dart';
import 'oca.dart';
import 'ocasa.dart';
import 'plusmar.dart';
import 'pickit.dart';
import 'pulqui_pack.dart';
import 'rabbione.dart';
import 'renaper.dart';
import 'rodriguez_hermanos_transportes.dart';
import 'ruta_cargo.dart';
import 'sendBox.dart';
import 'south_post.dart';
import 'trans_dan_express.dart';
import 'urbano.dart';
import 'via_cargo.dart';

final Map<String, dynamic> servicesList = {
  "Andesmar Cargas": AndesmarCargas(),
  "Andreani": Andreani(),
  "Arg Cargo": ArgCargo(),
  "Balut Express": BalutExpress(),
  "Buspack": Buspack(),
  "Cata Cargo": CataCargo(),
  "Central de Cargas Terrestres": CentralDeCargasTerrestres(),
  "ClicOh": ClicOh(),
  "Clicpaq": Clicpaq(),
  "Condor Estrella": CondorEstrella(),
  "Cooperativa Sportman": CooperativaSportman(),
  "Correo Argentino": CorreoArgentino(),
  "Credifin Logística": CredifinLogistica(),
  "Crucero Express": CruceroExpress(),
  "Cruz del Sur": CruzDelSur(),
  "DHL": DHL(),
  "EcaPack": EcaPack(),
  "El Práctico Pack": ElPracticoPack(),
  "El Turista Pack": ElTuristaPack(),
  "Encotrans Express": EncotransExpress(),
  "Enviopack": Enviopack(),
  "Epsa": Epsa(),
  'Expreso Lancioni': ExpresoLancioni(),
  "Expreo Malargüe": ExpresoMalargue(),
  "FastTrack": FastTrack(),
  "Fono Pack": FonoPack(),
  "Integral Pack": IntegralPack(),
  "Jetmar": Jetmar(),
  "Mercado Libre": MercadoLibre(),
  "MD Cargas": MDCargas(),
  "ÑanduPack": NanduPack(),
  "OCA": OCA(),
  "OCASA": OCASA(),
  "pickit": Pickit(),
  "Plusmar": Plusmar(),
  "Pulqui Pack": PulquiPack(),
  "Rabbione": Rabbione(),
  "Renaper": Renaper(),
  "Rodríguez Hermanos Transportes": RodriguezHermanosTransportes(),
  "Rutacargo": Rutacargo(),
  "SendBox": SendBox(),
  "South Post": SouthPost(),
  "Trans Dan Express": TransDanExpress(),
  "Urbano": Urbano(),
  "Via Cargo": ViaCargo(),
};

class Services {
  static dynamic select(String service) => servicesList[service];

  static List<ServiceItemModel> itemModelList(bool mercadoLibre) {
    List<ServiceItemModel> servicesItemModels = servicesList.values
        .map((service) => service.itemModel as ServiceItemModel)
        .toList();
    if (!mercadoLibre) servicesItemModels.removeAt(28);
    return servicesItemModels;
  }

  static List<Map<String, dynamic>> eventServiceData(
      String type, dynamic event) {
    Map<String, List<Map<String, dynamic>>> eventList = {
      "plusmar": [
        {"icon": const Icon(Icons.local_shipping), "text": event['status']!},
      ],
      "cristal": [
        {"icon": Icons.location_on, "text": event['location']},
        {"icon": Icons.local_shipping, "text": event['detail']},
      ],
      "sisorg": [
        {"icon": Icons.local_shipping, "text": event['description']},
      ],
    };
    return eventList[type]!;
  }

  static Map<String, dynamic> contactServiceData(String service) {
    Map<String, Map<String, dynamic>> contactList = {
      "Plusmar": {
        "contact": [
          {
            "type": "phone",
            "title": "Teléfono",
            "data": "0810-810-7225",
          },
          {
            "type": "email",
            "title": "Correo electrónico",
            "data": "clientes@integralexpress.com",
          },
        ],
        "source": "https://www.integralpack.com.ar/",
      },
    };
    return contactList[service]!;
  }
}

class ServiceItemModel {
  final Image logo;
  final String chosen;
  final String exampleCode;
  ServiceItemModel(this.logo, this.chosen, this.exampleCode);
}
