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
import 'correo_argentino.dart';
import 'condor_estrella.dart';
import 'credifinLogistica.dart';
import 'crucero_express.dart';
import 'cruz_del_sur.dart';
import 'dhl.dart';
import 'distribucion_y_logistica.dart';
import 'ecapack.dart';
import 'el_turista_pack.dart';
import 'encotrans_express.dart';
import 'enviopack.dart';
import 'expreso_bibiloni.dart';
import 'expreso_bisonte.dart';
import 'expreso_interprovincial.dart';
import 'expreso_lancioni.dart';
import 'epsa.dart';
import 'expreso_lo_bruno.dart';
import 'expreso_maipu.dart';
import 'expreso_oro_negro.dart';
import 'expreso_rocinante.dart';
import 'fasttrack.dart';
import 'ferrocargas_del_sur.dart';
import 'fono_pack.dart';
import 'integral_pack.dart';
import 'jetmar.dart';
import 'la_veloz_pack.dart';
import 'logistica_salta.dart';
import 'md_cargas.dart';
import 'oca.dart';
import 'ocasa.dart';
import 'plusmar.dart';
import 'pickit.dart';
import 'pulqui_pack.dart';
import 'rodriguez_hermanos_transportes.dart';
import 'ruta_cargo.dart';
import 'sendBox.dart';
import 'serpaq.dart';
import 'south_post.dart';
import 'transporte_pico.dart';
import 'transportes_nandubay.dart';
import 'transportes_tomassini.dart';
import 'trenque_lauquen_expreso.dart';
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
  "Correo Argentino": CorreoArgentino(),
  "Condor Estrella": CondorEstrella(),
  "Credifin Logística": CredifinLogistica(),
  "Crucero Express": CruceroExpress(),
  "Cruz del Sur": CruzDelSur(),
  'Distribución y Logística': DistribucionYLogistica(),
  "DHL": DHL(),
  "EcaPack": EcaPack(),
  "El Turista Pack": ElTuristaPack(),
  "Encotrans Express": EncotransExpress(),
  "Enviopack": Enviopack(),
  "Epsa": Epsa(),
  'Expreso Bibiloni': ExpresoBibiloni(),
  'Expreso Bisonte': ExpresoBisonte(),
  'Expreso Interprovincial': ExpresoInterprovincial(),
  'Expreso Lancioni': ExpresoLancioni(),
  "Expreso Lo Bruno": ExpresoLoBruno(),
  "Expreso Maipú": ExpresoMaipu(),
  "Expreso Oro Negro": ExpresoOroNegro(),
  "Expreso Rocinante": ExpresoRocinante(),
  "FastTrack": FastTrack(),
  "Ferrocargas del Sur": FerrocargasDelSur(),
  "Fono Pack": FonoPack(),
  "Integral Pack": IntegralPack(),
  "Jetmar": Jetmar(),
  "MD Cargas": MDCargas(),
  "La Veloz Pack": LaVelozPack(),
  "Logística Salta": LogisticaSalta(),
  "OCA": OCA(),
  "OCASA": OCASA(),
  "Plusmar": Plusmar(),
  "Pulqui Pack": PulquiPack(),
  "pickit": Pickit(),
  "Rodríguez Hermanos Transportes": RodriguezHermanosTransportes(),
  "Rutacargo": Rutacargo(),
  "SendBox": SendBox(),
  "SerPaq": SerPaq(),
  "South Post": SouthPost(),
  "Transportes Ñandubay": TransportesNandubay(),
  "Transporte Pico": TransportePico(),
  "Transportes Tomassini": TransportesTomassini(),
  "Trenque Lauquen Expreso": TrenqueLauquenExpreso(),
  "Urbano": Urbano(),
  "Via Cargo": ViaCargo(),
};

class Services {
  static dynamic select(String service) => servicesList[service];

  static List<ServiceItemModel> itemModelList() => servicesList.values
      .map((service) => service.itemModel as ServiceItemModel)
      .toList();

  static List<Map<String, dynamic>> transoftEventData(event) {
    return [
      {"icon": Icons.local_shipping, "text": event['detail']!},
    ];
  }
}

class ServiceItemModel {
  final Image logo;
  final String chosen;
  final String exampleCode;
  ServiceItemModel(this.logo, this.chosen, this.exampleCode);
}
