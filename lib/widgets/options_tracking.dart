import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/screens/tracking_more.dart';

import '../providers/classes.dart';
import '../providers/preferences.dart';
import '../providers/status.dart';
import '../providers/trackings_active.dart';
import '../providers/trackings_archived.dart';

import '../screens/form_add_edit.dart';
import '../services/_services.dart';

import '../widgets/ad_interstitial.dart';
import 'dialog_toast.dart';

import '../screens/tracking_detail.dart';

class OptionsTracking extends StatefulWidget {
  final ItemTracking tracking;
  final bool menu;
  final String action;
  final bool detail;

  const OptionsTracking({
    Key? key,
    required this.tracking,
    required this.menu,
    required this.action,
    required this.detail,
  }) : super(key: key);

  @override
  State<OptionsTracking> createState() => _OptionsTrackingState();
}

class _OptionsTrackingState extends State<OptionsTracking> {
  late dynamic provider;
  AdInterstitial interstitialAd = AdInterstitial();

  @override
  void initState() {
    super.initState();
    provider = widget.tracking.archived!
        ? Provider.of<ArchivedTrackings>(context, listen: false)
        : Provider.of<ActiveTrackings>(context, listen: false);
    interstitialAd.createInterstitialAd();
  }

  void screenPopToast(String message, bool premiumUser) {
    if (!premiumUser) interstitialAd.showInterstitialAd();
    Provider.of<Status>(context, listen: false).restartListEnd();
    Navigator.pop(context);
    GlobalToast.displayToast(context, message);
  }

  void seeTrackingDetail(bool premiumUser) {
    if (!premiumUser) interstitialAd.showInterstitialAd();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrackingDetail(widget.tracking),
      ),
    );
  }

  void seeMoreTrackingData(bool premiumUser) {
    if (!premiumUser) interstitialAd.showInterstitialAd();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrackingMore(widget.tracking.moreData),
      ),
    );
  }

  void _editTracking(bool premiumUser) {
    if (!premiumUser) interstitialAd.showInterstitialAd();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormAddEdit(
          code: '',
          mercadoLibre: false,
          title: '',
          edit: true,
          tracking: widget.tracking,
        ),
      ),
    );
    ServiceItemModel serviceEdit =
        Services.select(widget.tracking.service).itemModel;
    Provider.of<Status>(context, listen: false)
        .loadService(serviceEdit, context);
  }

  void toggleSelectionMode() {
    provider.toggleSelectionMode();
    provider.addSelected(widget.tracking);
    widget.tracking.selected = true;
    if (widget.detail) Navigator.pop(context);
  }

  void removeTracking(bool premiumUser) {
    provider
        .removeTracking([widget.tracking], context, widget.tracking.checkError);
    screenPopToast("Seguimiento eliminado", premiumUser);
    if (widget.detail) Navigator.pop(context);
  }

  void removeSelection(bool premiumUser) {
    provider.removeSelection(context);
    provider.toggleSelectionMode();
    screenPopToast("Selección eliminada", premiumUser);
  }

  void archiveTracking(bool premiumUser) {
    widget.tracking.archived = true;
    Provider.of<ArchivedTrackings>(context, listen: false)
        .addTracking(widget.tracking);
    provider
        .removeTracking([widget.tracking], context, widget.tracking.checkError);
    screenPopToast("Seguimiento archivado", premiumUser);
    if (widget.detail) Navigator.pop(context);
  }

  void archiveSelection(bool premiumUser) {
    List<ItemTracking> selection = provider.selectionElements;
    for (var element in selection) {
      element.selected = false;
      element.archived = true;
      Provider.of<ArchivedTrackings>(context, listen: false)
          .addTracking(element);
    }
    provider.removeSelection(context);
    provider.toggleSelectionMode();
    screenPopToast("Selección archivada", premiumUser);
  }

  void displayDialog(String action, bool premiumUser) {
    VoidCallback dialogFunction;
    String buttonText = action == "archivar" ? "Archivar" : 'Eliminar';
    dialogFunction = action == "archivar"
        ? () => widget.menu
            ? archiveTracking(premiumUser)
            : archiveSelection(premiumUser)
        : () => widget.menu
            ? removeTracking(premiumUser)
            : removeSelection(premiumUser);
    ShowDialog.actionConfirmation(context, action, buttonText, dialogFunction);
  }

  optionMenu(String text, IconData icon) {
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
    final String trackingType = widget.tracking.archived! ? "archived" : "main";
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    final Map<String, dynamic> optionsList = {
      "main": {
        "menu": PopupMenuButton<String>(
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
                seeTrackingDetail(premiumUser);
                break;
              case 'Más datos':
                seeMoreTrackingData(premiumUser);
                break;
              case 'Editar':
                _editTracking(premiumUser);
                break;
              case 'Seleccionar':
                toggleSelectionMode();
                break;
              case 'Archivar':
                displayDialog("archivar", premiumUser);
                break;
              case 'Eliminar':
                displayDialog("eliminar", premiumUser);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            if (!widget.detail && widget.tracking.checkError == false)
              optionMenu('Detalles', Icons.info_outline),
            if (!widget.tracking.checkError!)
              optionMenu('Más datos', Icons.info),
            optionMenu('Editar', Icons.edit),
            optionMenu('Seleccionar', Icons.select_all_sharp),
            if (!widget.tracking.checkError!)
              optionMenu("Archivar", Icons.archive),
            optionMenu('Eliminar', Icons.delete),
          ],
        ),
        "buttons": {
          "remove": IconButton(
            icon: const Icon(Icons.delete),
            iconSize: 24,
            onPressed: () => displayDialog("eliminar", premiumUser),
          ),
          "archive": IconButton(
            icon: const Icon(Icons.archive),
            iconSize: 24,
            onPressed: () => displayDialog("archivar", premiumUser),
          )
        }
      },
      "archived": {
        "menu": PopupMenuButton<String>(
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
                seeTrackingDetail(premiumUser);
                break;
              case 'Más datos':
                seeMoreTrackingData(premiumUser);
                break;
              case 'Seleccionar':
                toggleSelectionMode();
                break;
              case 'Eliminar':
                displayDialog("eliminar", premiumUser);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            if (!widget.detail && !widget.tracking.checkError!)
              optionMenu('Detalles', Icons.info_outline),
            if (!widget.tracking.checkError!)
              optionMenu('Más datos', Icons.info),
            optionMenu('Seleccionar', Icons.select_all_sharp),
            optionMenu('Eliminar', Icons.delete),
          ],
        ),
        "buttons": {
          "remove": IconButton(
            icon: const Icon(Icons.delete),
            iconSize: 24,
            onPressed: () => displayDialog("eliminar", premiumUser),
          ),
        }
      }
    };

    return widget.menu
        ? optionsList[trackingType]['menu']
        : optionsList[trackingType]['buttons'][widget.action];
  }
}
