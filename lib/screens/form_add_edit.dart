import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/widgets/dialog_error.dart';

import '../widgets/ad_interstitial.dart';

import '../providers/classes.dart';
import '../providers/status.dart';
import '../providers/trackings_active.dart';
import '../providers/trackings_archived.dart';

import '../services/_services.dart';
// import '../widgets/ad_native.dart';
import '../widgets/dialog_toast.dart';
import '../widgets/ad_banner.dart';

class FormAddEdit extends StatefulWidget {
  final bool rename;
  final ItemTracking? tracking;
  final bool mercadoLibre;
  final String? shippingId;
  final String? title;
  final String? code;

  const FormAddEdit({
    Key? key,
    required this.rename,
    this.tracking,
    required this.mercadoLibre,
    this.shippingId,
    this.title,
    this.code,
  }) : super(key: key);

  @override
  _FormAddEditState createState() => _FormAddEditState();
}

class _FormAddEditState extends State<FormAddEdit> {
  final AdInterstitial interstitialAd = AdInterstitial();
  ServiceItemModel? loadedService;
  late List<ServiceItemModel> services;
  late dynamic providerFunctions;

  @override
  void initState() {
    super.initState();
    services = Services.itemModelList(widget.mercadoLibre);
    if (widget.rename == true) {
      String? widgetTitle = widget.tracking?.title;
      String? widgetCode = widget.tracking?.code;
      title.text = widgetTitle!;
      code.text = widgetCode!;
      int serviceIndex = services
          .indexWhere((element) => element.chosen == widget.tracking?.service);
      loadedService = services[serviceIndex];
    } else if (widget.mercadoLibre == true) {
      title.text = widget.title!;
      code.text =
          widget.code!.startsWith("MEL", 0) ? widget.shippingId! : widget.code!;
      if (widget.code!.startsWith("MEL", 0)) {
        loadedService = services[28];
      } else {
        Provider.of<Status>(context, listen: false).clearStartService();
      }
    } else {
      Provider.of<Status>(context, listen: false).clearStartService();
    }
    providerFunctions = widget.tracking?.archived == true
        ? Provider.of<ArchivedTrackings>(context, listen: false)
        : Provider.of<ActiveTrackings>(context, listen: false);
    interstitialAd.createInterstitialAd();
  }

  final formKey = GlobalKey<FormState>();

  final title = TextEditingController();
  final code = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    title.dispose();
    code.dispose();
  }

  void pagePopMessage(context, edit) {
    Navigator.pop(context);
    if (edit) {
      GlobalToast.displayToast(context, "Seguimiento editado");
    }
    if (widget.mercadoLibre && widget.rename == false) {
      Navigator.pop(context);
    }
    // interstitialAd.showInterstitialAd();
  }

  void addTracking(context, service) {
    if (formKey.currentState?.validate() == false || service == null) {
      DialogError.formError(context);
    } else {
      final newTracking = Tracking(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title.text,
        code: code.text.trim(),
        service: service,
      );
      Provider.of<ActiveTrackings>(context, listen: false)
          .addTracking(newTracking);
      pagePopMessage(context, widget.rename);
    }
  }

  void editTracking(context, service, listView) {
    if (formKey.currentState?.validate() == false || service == null) {
      DialogError.formError(context);
    } else {
      int? idSB = widget.tracking?.idSB;
      final editedTracking = ItemTracking(
        idSB: idSB,
        title: title.text,
        code: code.text,
        service: service,
        events: [],
        moreData: [],
        lastEvent: "Sample",
      );
      providerFunctions.editTracking(editedTracking);
      pagePopMessage(context, widget.rename);
    }
  }

  @override
  Widget build(BuildContext context) {
    String listView = "main";
    final String? service =
        loadedService?.chosen ?? Provider.of<Status>(context).chosenService;
    final String exampleCode = Provider.of<Status>(context).chosenServiceCode;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.0,
        title: widget.rename ? const Text('Renombrar') : const Text('Agregar'),
        actions: [
          IconButton(
            icon:
                widget.rename ? const Icon(Icons.save) : const Icon(Icons.add),
            iconSize: 26,
            onPressed: widget.rename
                ? () => editTracking(context, service, listView)
                : () => addTracking(context, widget.tracking?.service),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // AdNative("medium"),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                ),
                child: Form(
                  key: formKey,
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
                              optionWidth: 200,
                              mercadoLibre: widget.mercadoLibre,
                            ),
                            // SelectService(),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          readOnly: widget.rename,
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
                            if (value == null || value.length < 6) {
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
                            labelText: "Título (opcional)",
                            hintText: "Ejemplo: Celular",
                          ),
                          controller: title,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 7),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 120,
                                height: 39,
                                child: ElevatedButton(
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // interstitialAd.showInterstitialAd();
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 120,
                                height: 39,
                                child: ElevatedButton(
                                  child: Text(
                                    widget.rename ? 'Guardar' : 'Agregar',
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                  onPressed: widget.rename
                                      ? () => editTracking(
                                          context, service, listView)
                                      : () => addTracking(context, service),
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
              // Padding(
              //   child: AdNative("medium"),
              //   padding: EdgeInsets.only(top: 20),
              // ),
            ],
          ),
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
  final bool? mercadoLibre;
  const SelectService({
    Key? key,
    this.preLoadedService,
    this.optionWidth,
    this.chosen,
    this.mercadoLibre,
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
    final List<ServiceItemModel> services =
        Services.itemModelList(widget.mercadoLibre!);
    return DropdownButton<ServiceItemModel>(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      elevation: 4,
      iconSize: 0,
      hint: Padding(
        padding: const EdgeInsets.only(left: 26),
        child: SizedBox(
          width: 150,
          height: 80,
          child: ElevatedButton(
            child: const Text(
              'Seleccionar servicio',
              style: TextStyle(fontSize: 17),
              textAlign: TextAlign.center,
            ),
            onPressed: () {},
          ),
        ),
      ),
      iconEnabledColor: Theme.of(context).primaryColor,
      value: loadedService,
      underline: Container(),
      onChanged: widget.preLoadedService != null
          ? null
          : (ServiceItemModel? service) {
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
            padding: const EdgeInsets.only(top: 1, bottom: 1),
            width: widget.optionWidth,
            child: service.logo,
          ),
        );
      }).toList(),
    );
  }
}
