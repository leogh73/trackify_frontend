import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/classes.dart';
import '../providers/status.dart';
import '../providers/trackings_active.dart';
import '../providers/trackings_archived.dart';

import 'ad_interstitial.dart';
import 'dialog_and_toast.dart';

import '../screens/tracking_detail.dart';
import '../screens/tracking_form.dart';

class ActionsMenu extends StatefulWidget {
  final String screen;
  final bool menu;
  final String action;
  final bool detail;
  final ItemTracking tracking;
  final double icon;

  const ActionsMenu({
    Key? key,
    required this.screen,
    required this.menu,
    required this.action,
    required this.detail,
    required this.tracking,
    required this.icon,
  }) : super(key: key);

  @override
  State<ActionsMenu> createState() => _ActionsMenuState();
}

class _ActionsMenuState extends State<ActionsMenu> {
  AdInterstitial interstitialAd = AdInterstitial();

  @override
  void initState() {
    super.initState();
    interstitialAd.createInterstitialAd();
  }

  void _screenPopToast(context, String message) {
    interstitialAd.showInterstitialAd();
    if (widget.detail == true) Navigator.pop(context);
    Provider.of<Status>(context, listen: false).restartListEnd();
    Navigator.pop(context);
    GlobalToast(context, message).displayToast();
  }

  selectProvider(BuildContext context, String screen) {
    if (screen == "main") {
      return Provider.of<ActiveTrackings>(context, listen: false);
    } else {
      return Provider.of<ArchivedTrackings>(context, listen: false);
    }
  }

  void _seeTrackingDetail(BuildContext context) {
    interstitialAd.showInterstitialAd();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrackingDetail(widget.tracking),
      ),
    );
  }

  void _seeMoreTrackingData(BuildContext context) {
    interstitialAd.showInterstitialAd();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MoreData(
          widget.tracking.otherData!,
          widget.tracking.service,
        ),
      ),
    );
  }

  void _editTracking(BuildContext context) {
    interstitialAd.showInterstitialAd();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrackingForm(
          code: '',
          mercadoLibre: false,
          title: '',
          edit: true,
          tracking: widget.tracking,
        ),
      ),
    );
    ServiceItemModel serviceEdit = ServiceItemModel(
      ServiceData(widget.tracking.service).getImage(),
      widget.tracking.service,
      ServiceData(widget.tracking.service).getExampleCode(),
    );
    Provider.of<Status>(context, listen: false)
        .loadService(serviceEdit, context);
  }

  void _activateSelectionMode(context, ItemTracking tracking, String screen) {
    selectProvider(context, screen).toggleSelectionMode();
    selectProvider(context, screen).activateStartSelection(tracking);
  }

  void _removeTracking(context, ItemTracking tracking, String screen) {
    selectProvider(context, screen).removeTracking([tracking], context);
    _screenPopToast(context, "Seguimiento eliminado");
  }

  void _removeSelection(context, screen) {
    selectProvider(context, screen).removeSelection(context);
    selectProvider(context, screen).toggleSelectionMode();
    _screenPopToast(context, "Selección eliminada");
  }

  void _archiveTracking(context, String screen) {
    widget.tracking.archived = true;
    selectProvider(context, "archived").addTracking(widget.tracking);
    selectProvider(context, screen).removeTracking([widget.tracking], context);
    _screenPopToast(context, "Seguimiento archivado");
  }

  void _archiveSelection(context, screen) {
    List<ItemTracking> selection =
        selectProvider(context, screen).selectionElements;
    for (var element in selection) {
      element.selected = false;
      element.archived = true;
      selectProvider(context, "archived").addTracking(element);
    }
    selectProvider(context, screen).removeTracking(selection);
    selectProvider(context, screen).removeSelection();
    selectProvider(context, screen).toggleSelectionMode();

    _screenPopToast(context, "Selección archivada");
  }

  void _displayDialog(context, String screen, String action, bool selection) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: const RoundedRectangleBorder(
            // ignore: unnecessary_const
            borderRadius: const BorderRadius.all(
              Radius.circular(18.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(right: 5, left: 5),
          content: Column(
            children: [
              Container(
                width: 245,
                padding: const EdgeInsets.only(
                  bottom: 5,
                  top: 16,
                  // right: 8,
                ),
                child: Text(
                  "¿Confirma $action?",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 110,
                      padding: const EdgeInsets.only(bottom: 9, top: 2),
                      child: ElevatedButton(
                        child: const Text(
                          'CANCELAR',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    if (action == "eliminar")
                      Container(
                        width: 110,
                        padding: const EdgeInsets.only(bottom: 9, top: 2),
                        child: ElevatedButton(
                          child: const Text(
                            "ELIMINAR",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () => selection
                              ? _removeSelection(context, screen)
                              : _removeTracking(
                                  context, widget.tracking, screen),
                        ),
                      ),
                    if (action == "archivar")
                      Container(
                        width: 110,
                        padding: const EdgeInsets.only(bottom: 9, top: 2),
                        child: ElevatedButton(
                          child: const Text(
                            "ARCHIVAR",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () => selection
                              ? _archiveSelection(context, screen)
                              : _archiveTracking(context, screen),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  optionMenu(String text, BuildContext context, IconData icon) {
    return PopupMenuItem<String>(
      value: text,
      height: 35,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 15),
            child: Icon(
              icon,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Text(text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, WidgetsScreen> optionsList = {
      "main": WidgetsScreen(
          PopupMenuButton<String>(
            // padding: EdgeInsets.zero,
            tooltip: 'Opciones',
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            elevation: 2,
            // icon: Icon(Icons.more_vert),
            onSelected: (String value) {
              switch (value) {
                case 'Detalles':
                  _seeTrackingDetail(context);
                  break;
                case 'Más datos':
                  _seeMoreTrackingData(context);
                  break;
                case 'Editar':
                  _editTracking(context);
                  break;
                case 'Seleccionar':
                  _activateSelectionMode(
                      context, widget.tracking, widget.screen);
                  break;
                // case 'Compartir':
                //   _editTracking(context);
                //   break;
                case 'Archivar':
                  _displayDialog(context, widget.screen, "archivar", false);
                  break;
                case 'Eliminar':
                  _displayDialog(context, widget.screen, "eliminar", false);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              if (!widget.detail && !widget.tracking.checkError!)
                optionMenu('Detalles', context, Icons.info_outline),
              if (!widget.tracking.checkError!)
                optionMenu('Más datos', context, Icons.info),
              optionMenu('Editar', context, Icons.edit),
              if (!widget.detail)
                optionMenu('Seleccionar', context, Icons.select_all_sharp),
              // if (!tracking.checkError!)
              //   optionMenu('Compartir', context, Icons.share),
              if (!widget.tracking.checkError!)
                optionMenu("Archivar", context, Icons.archive),
              optionMenu('Eliminar', context, Icons.delete),
            ],
          ),
          {
            "remove": IconButton(
              icon: const Icon(Icons.delete),
              iconSize: widget.icon,
              onPressed: () =>
                  _displayDialog(context, widget.screen, "eliminar", true),
            ),
            "archive": IconButton(
              icon: const Icon(Icons.archive),
              iconSize: widget.icon,
              onPressed: () =>
                  _displayDialog(context, widget.screen, "archivar", true),
            )
          }),
      "archived": WidgetsScreen(
          PopupMenuButton<String>(
            // padding: EdgeInsets.zero,
            tooltip: 'Opciones',
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            elevation: 2,
            // icon: Icon(Icons.more_vert),
            onSelected: (String value) {
              switch (value) {
                case 'Detalles':
                  _seeTrackingDetail(context);
                  break;
                case 'Más datos':
                  _seeMoreTrackingData(context);
                  break;
                case 'Restaurar':
                  _displayDialog(context, widget.screen, "restaurar", false);
                  break;
                case 'Seleccionar':
                  _activateSelectionMode(
                      context, widget.tracking, widget.screen);
                  break;

                case 'Eliminar':
                  _displayDialog(context, widget.screen, "eliminar", false);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              if (!widget.detail && !widget.tracking.checkError!)
                optionMenu('Detalles', context, Icons.info_outline),
              if (!widget.tracking.checkError!)
                optionMenu('Más datos', context, Icons.info),
              if (!widget.detail)
                optionMenu('Seleccionar', context, Icons.select_all_sharp),
              // if (!tracking.checkError!)
              //   optionMenu('Compartir', context, Icons.share),
              if (!widget.tracking.checkError!)
                optionMenu('Restaurar', context, Icons.restore),
              optionMenu('Eliminar', context, Icons.delete),
            ],
          ),
          {
            "remove": IconButton(
              icon: const Icon(Icons.delete),
              iconSize: widget.icon,
              onPressed: () =>
                  _displayDialog(context, widget.screen, "eliminar", true),
            ),
          }),
    };

    return widget.menu
        ? optionsList[widget.screen]?.menuItem
        : optionsList[widget.screen]?.buttons[widget.action];
  }
}

class WidgetsScreen {
  dynamic menuItem;
  Map<String, IconButton> buttons;
  WidgetsScreen(this.menuItem, this.buttons);
}
