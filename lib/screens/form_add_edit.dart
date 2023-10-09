import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/widgets/dialog_error.dart';

import '../widgets/ad_interstitial.dart';

import '../providers/classes.dart';
import '../providers/status.dart';
import '../providers/preferences.dart';
import '../providers/trackings_active.dart';
import '../providers/trackings_archived.dart';

import '../services/_services.dart';
import '../widgets/ad_native.dart';
import '../widgets/dialog_toast.dart';
import '../widgets/ad_banner.dart';

class FormAddEdit extends StatefulWidget {
  final bool edit;
  final ItemTracking? tracking;
  final bool mercadoLibre;
  final String? title;
  final String? code;

  const FormAddEdit(
      {Key? key,
      required this.edit,
      this.tracking,
      required this.mercadoLibre,
      this.title,
      this.code})
      : super(key: key);

  @override
  _FormAddEditState createState() => _FormAddEditState();
}

final _formKey = GlobalKey<FormState>();

class _FormAddEditState extends State<FormAddEdit> {
  AdInterstitial interstitialAd = AdInterstitial();
  ServiceItemModel? loadedService;

  final List<ServiceItemModel> services = Services.itemModelList();

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
      GlobalToast.displayToast(context, "Seguimiento editado");
    }
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
      DialogError.formError(context);
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
      selectProvider(context, listView).editTracking(editedTracking);
      _pagePopMessage(context, widget.edit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
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
            if (!premiumUser) AdNative("medium"),
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
                            optionWidth: 200,
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
                          labelText: "Descripción (opcional)",
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
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 120,
                              height: 39,
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
            if (!premiumUser)
              Padding(
                  child: AdNative("medium"), padding: EdgeInsets.only(top: 20)),
          ],
        ),
      ),
      bottomNavigationBar: premiumUser ? const SizedBox() : const AdBanner(),
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
    final List<ServiceItemModel> services = Services.itemModelList();
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
            padding: const EdgeInsets.only(top: 1, bottom: 1),
            width: widget.optionWidth,
            child: service.logo,
          ),
        );
      }).toList(),
    );
  }
}
