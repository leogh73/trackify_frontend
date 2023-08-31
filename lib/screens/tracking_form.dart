import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:trackify/widgets/ad_interstitial.dart';

import '../providers/classes.dart';
import '../providers/status.dart';
import '../providers/trackings_active.dart';
import '../providers/trackings_archived.dart';

import '../widgets/ad_native.dart';
import '../widgets/dialog_and_toast.dart';
import '../widgets/ad_banner.dart';

class TrackingForm extends StatefulWidget {
  final bool edit;
  final ItemTracking? tracking;
  final bool mercadoLibre;
  final String? title;
  final String? code;

  const TrackingForm(
      {Key? key,
      required this.edit,
      this.tracking,
      required this.mercadoLibre,
      this.title,
      this.code})
      : super(key: key);

  @override
  _TrackingFormState createState() => _TrackingFormState();
}

final _formKey = GlobalKey<FormState>();

class _TrackingFormState extends State<TrackingForm> {
  AdInterstitial interstitialAd = AdInterstitial();
  ServiceItemModel? loadedService;

  @override
  void initState() {
    super.initState();
    if (widget.edit == true) {
      var widgetTitle = widget.tracking?.title;
      var widgetCode = widget.tracking?.code;
      title.text = widgetTitle!;
      code.text = widgetCode!;
      int serviceIndex = services
          .indexWhere((element) => element.chosen == widget.tracking?.service);
      loadedService = services[serviceIndex];
    } else if (widget.mercadoLibre == true) {
      title.text = widget.title!;
      code.text = widget.code!;
      Provider.of<Status>(context, listen: false).clearStartService();
    } else {
      Provider.of<Status>(context, listen: false).clearStartService();
    }
    interstitialAd.createInterstitialAd();
  }

  final title = TextEditingController();
  final code = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    title.dispose();
    code.dispose();
  }

  void _pagePopMessage(context, edit) {
    Navigator.pop(context);
    if (edit) {
      GlobalToast(context, "Seguimiento editado").displayToast();
    }
    // interstitialAd.showInterstitialAd();
  }

  selectProvider(BuildContext context, String listView) {
    if (listView == "main") {
      return Provider.of<ActiveTrackings>(context, listen: false);
    } else if (listView == "archived") {
      return Provider.of<ArchivedTrackings>(context, listen: false);
    }
  }

  void _addTracking(context, String? service) {
    if (_formKey.currentState?.validate() == false || service == null) {
      ShowDialog(context).formError();
    } else {
      final newTracking = Tracking(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title.text,
        code: code.text,
        service: service,
      );
      Provider.of<ActiveTrackings>(context, listen: false)
          .addTracking(newTracking);
      _pagePopMessage(context, widget.edit);
    }
  }

  void _editTracking(context, service, listView) {
    if (_formKey.currentState?.validate() == false || service == null) {
      ShowDialog(context).formError();
    } else {
      var idSB = widget.tracking?.idSB;
      final editedTracking = ItemTracking(
        idSB: idSB,
        title: title.text,
        code: code.text,
        service: service,
      );
      selectProvider(context, listView).editTracking(editedTracking);
      _pagePopMessage(context, widget.edit);
    }
  }

  @override
  Widget build(BuildContext context) {
    var listView = "main";
    final String? service = Provider.of<Status>(context).chosenService;
    final String exampleCode = Provider.of<Status>(context).chosenServiceCode;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.0,
        title: widget.edit ? const Text('Editar') : const Text('Agregar'),
        actions: [
          IconButton(
            icon: widget.edit ? const Icon(Icons.save) : const Icon(Icons.add),
            iconSize: 26,
            onPressed: widget.edit
                ? () => _editTracking(context, service, listView)
                : () => _addTracking(context, widget.tracking?.service),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AdNative("medium"),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: SelectService(
                            preLoadedService: loadedService,
                            chosen: false,
                            optionWidth: 180,
                          ),
                          // SelectService(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        focusNode: FocusNode(),
                        decoration: InputDecoration(
                          labelText: "Código",
                          hintText: exampleCode,
                          contentPadding: EdgeInsets.only(top: 5),
                        ),
                        controller: code,
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        validator: (value) {
                          if (value == null || value.length < 8) {
                            return 'Ingrese un código de seguimiento válido';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 5),
                          labelText: "Descripción (opcional)",
                          hintText: "Ejemplo: Celular",
                        ),
                        controller: title,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        padding: const EdgeInsets.only(left: 4, right: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 120,
                              child: ElevatedButton(
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(fontSize: 17),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 120,
                              child: ElevatedButton(
                                child: Text(
                                  widget.edit ? 'Guardar' : 'Agregar',
                                  style: const TextStyle(fontSize: 17),
                                ),
                                onPressed: widget.edit
                                    ? () => _editTracking(
                                        context, service, listView)
                                    : () => _addTracking(context, service),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
                child: AdNative("medium"), padding: EdgeInsets.only(top: 20)),
          ],
        ),
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}

class SelectService extends StatefulWidget {
  final ServiceItemModel? preLoadedService;
  final double? optionWidth;
  final bool? chosen;
  const SelectService({
    Key? key,
    this.preLoadedService,
    this.optionWidth,
    this.chosen,
  }) : super(key: key);

  @override
  _SelectServiceState createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectService> {
  ServiceItemModel? loadedService;

  @override
  void initState() {
    super.initState();
    loadedService = widget.preLoadedService;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ServiceItemModel>(
      elevation: 4,
      iconSize: 0,
      hint: Padding(
        padding: const EdgeInsets.only(left: 36),
        child: SizedBox(
            width: 110,
            child: ElevatedButton(
                child: const Text(
                  'SERVICIO',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {})),
      ),
      iconEnabledColor: Theme.of(context).primaryColor,
      value: loadedService,
      underline: Container(),
      onChanged: (ServiceItemModel? service) {
        setState(() {
          loadedService = service!;
        });
        if (widget.chosen == false) {
          Provider.of<Status>(context, listen: false)
              .loadService(service!, context);
        }
      },
      items: services
          .map<DropdownMenuItem<ServiceItemModel>>((ServiceItemModel service) {
        return DropdownMenuItem<ServiceItemModel>(
          value: service,
          child: Container(
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.center,
            constraints:
                BoxConstraints(maxWidth: widget.optionWidth!, maxHeight: 55),
            child: service.image,
          ),
        );
      }).toList(),
    );
  }
}

class ServiceItemModel {
  final Image image;
  final String chosen;
  final String exampleCode;
  ServiceItemModel(this.image, this.chosen, this.exampleCode);
}

final List<ServiceItemModel> services = [
  ServiceItemModel(
    Image.asset('assets/services/andreani.png'),
    "Andreani",
    "360000070068800 ",
  ),
  ServiceItemModel(
    Image.asset('assets/services/clicoh.png'),
    "ClicOh",
    "HWUIN94250",
  ),
  ServiceItemModel(
    Image.asset('assets/services/correoargentino.png'),
    "Correo Argentino",
    "1627633PCMI321E001",
  ),
  ServiceItemModel(
    Image.asset('assets/services/dhl.png'),
    "DHL",
    "2271618790",
  ),
  ServiceItemModel(
    Image.asset('assets/services/ecapack.png'),
    "EcaPack",
    "RI-0044-2505",
  ),
  ServiceItemModel(
    Image.asset('assets/services/enviopack.png'),
    "Enviopack",
    "5079800000001918356",
  ),
  ServiceItemModel(
    Image.asset('assets/services/fasttrack.png'),
    "FastTrack",
    "101440340",
  ),
  ServiceItemModel(
    Image.asset('assets/services/mdcargas.png'),
    "MDCargas",
    "R-0505-00020601",
  ),
  ServiceItemModel(
    Image.asset('assets/services/oca.png'),
    "OCA",
    "3867500000050334468",
  ),
  ServiceItemModel(
    Image.asset('assets/services/ocasa.png'),
    "OCASA",
    "EC2FQ31777987",
  ),
  ServiceItemModel(
    Image.asset('assets/services/renaper.png'),
    "Renaper",
    "682257040",
  ),
  ServiceItemModel(
    Image.asset('assets/services/urbano.png'),
    "Urbano",
    "0000000043168668",
  ),
  ServiceItemModel(
    Image.asset('assets/services/viacargo.png'),
    "ViaCargo",
    "999015276642",
  ),
];

class ServiceData {
  final String serviceImage;
  ServiceData(this.serviceImage);

  Image getImage() {
    int serviceIndex =
        services.indexWhere((service) => service.chosen == serviceImage);
    return services[serviceIndex].image;
  }

  String getExampleCode() {
    int serviceIndex =
        services.indexWhere((service) => service.chosen == serviceImage);
    return services[serviceIndex].exampleCode;
  }
}
