import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/widgets/dialog_error.dart';

import '../data/../data/preferences.dart';
import '../widgets/ad_interstitial.dart';

import '../data/classes.dart';
import '../data/status.dart';
import '../data/trackings_active.dart';
import '../data/trackings_archived.dart';

import '../widgets/ad_native.dart';
import '../widgets/dialog_toast.dart';
import '../widgets/ad_banner.dart';
import '../data/services.dart';

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
  late dynamic providerFunctions;
  late List<ServiceItemModel> services;
  ServiceItemModel? loadedService;

  @override
  void initState() {
    super.initState();
    services = Provider.of<Services>(context, listen: false)
        .itemModelList(widget.mercadoLibre);
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
        loadedService =
            services.singleWhere((s) => s.chosen == "Mercado Libre");
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
    title.dispose();
    code.dispose();
    super.dispose();
  }

  void pagePopMessage(
      BuildContext context, bool edit, bool premiumUser, bool rename) {
    Navigator.pop(context);
    if (edit) {
      GlobalToast.displayToast(context, "Seguimiento renombrado");
    }
    if (widget.mercadoLibre && widget.rename == false) {
      Navigator.pop(context);
    }
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    if (rename && !premiumUser && trackingsList.length > 1)
      interstitialAd.showInterstitialAd();
  }

  void addTracking(context, service, premiumUser) {
    if (formKey.currentState?.validate() == false || service == null) {
      DialogError.show(context, 3, "");
    } else {
      final newTracking = Tracking(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title.text,
        code: code.text.trim(),
        service: service,
      );
      Provider.of<ActiveTrackings>(context, listen: false)
          .addTracking(newTracking);
      pagePopMessage(context, widget.rename, premiumUser, false);
    }
  }

  void renameTracking(context, service, listView, premiumUser) async {
    if (formKey.currentState?.validate() == false || service == null) {
      DialogError.show(context, 3, "");
    } else {
      final editedTracking = ItemTracking(
        idSB: widget.tracking?.idSB,
        idMDB: widget.tracking?.idMDB,
        title: title.text,
        code: code.text,
        service: service,
        events: [],
        moreData: [],
        lastEvent: "Sample",
      );
      bool success =
          await providerFunctions.renameTracking(context, editedTracking);
      if (success == false) {
        return;
      }
      pagePopMessage(context, widget.rename, premiumUser, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context).trackings;
    final String? service =
        loadedService?.chosen ?? Provider.of<Status>(context).chosenService;
    final String exampleCode = Provider.of<Status>(context).chosenServiceCode;
    final bool fullHD = MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio >
        1079;
    final String selectionMessage =
        Provider.of<Status>(context, listen: false).messageService;
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
                ? () => renameTracking(context, service, 'main', premiumUser)
                : () =>
                    addTracking(context, widget.tracking?.service, premiumUser),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              child: premiumUser ? null : AdNative("small"),
              padding: EdgeInsets.only(top: 10, bottom: 30),
            ),
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
                            servicesData: services,
                          ),
                        ),
                      ],
                    ),
                    if (selectionMessage.isNotEmpty)
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: Column(
                          children: [
                            Text(
                              selectionMessage,
                              maxLines: 8,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[400],
                                fontSize: fullHD ? 17 : 16,
                              ),
                            ),
                          ],
                        ),
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
                          if (value == null || value.length < 5) {
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
                      padding: const EdgeInsets.only(top: 20, left: 7),
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
                                  if (!premiumUser && trackingsList.isNotEmpty)
                                    interstitialAd.showInterstitialAd();
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
                                onPressed: () => widget.rename
                                    ? renameTracking(
                                        context, service, 'main', premiumUser)
                                    : addTracking(
                                        context, service, premiumUser),
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
            SizedBox(width: 50, height: 120),
          ],
        ),
      ),
      bottomNavigationBar: premiumUser ? null : const AdBanner(),
    );
  }
}

class SelectService extends StatefulWidget {
  final ServiceItemModel? preLoadedService;
  final double? optionWidth;
  final bool? chosen;
  final bool? mercadoLibre;
  final List<ServiceItemModel>? servicesData;
  const SelectService({
    Key? key,
    this.preLoadedService,
    this.optionWidth,
    this.chosen,
    this.mercadoLibre,
    this.servicesData,
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
      items: widget.servicesData
          ?.map<DropdownMenuItem<ServiceItemModel>>((ServiceItemModel service) {
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
