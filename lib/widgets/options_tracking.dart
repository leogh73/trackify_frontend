import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/screens/claim.dart';
import 'package:trackify/screens/tracking_more.dart';
import 'package:trackify/data/services.dart';

import '../data/classes.dart';
import '../data/status.dart';
import '../data/trackings_active.dart';
import '../data/trackings_archived.dart';

import '../screens/form_add_edit.dart';

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

  void screenPopToast(String message) {
    Navigator.pop(context);
    Provider.of<Status>(context, listen: false).restartListEnd();
    GlobalToast.displayToast(context, message);
    interstitialAd.showInterstitialAd();
  }

  void seeTrackingDetail() {
    interstitialAd.showInterstitialAd();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrackingDetail(widget.tracking),
      ),
    );
  }

  void seeMoreTrackingData() {
    interstitialAd.showInterstitialAd();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrackingMore(widget.tracking.moreData!),
      ),
    );
  }

  void renameTracking() {
    interstitialAd.showInterstitialAd();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormAddEdit(
          code: '',
          mercadoLibre:
              widget.tracking.service == "Mercado Libre" ? true : false,
          title: '',
          rename: true,
          tracking: widget.tracking,
        ),
      ),
    );
    ServiceItemModel serviceEdit = Provider.of<Services>(context, listen: false)
        .itemModelList(true)
        .firstWhere((element) => element.chosen == widget.tracking.service);
    Provider.of<Status>(context, listen: false)
        .loadService(serviceEdit, context);
  }

  void toggleSelectionMode() {
    provider.toggleSelectionMode();
    provider.addSelected(widget.tracking);
    widget.tracking.selected = true;
    if (widget.detail) Navigator.pop(context);
  }

  void removeTracking() {
    provider
        .removeTracking([widget.tracking], context, widget.tracking.checkError);
    screenPopToast("Seguimiento eliminado");
    if (widget.detail) Navigator.pop(context);
  }

  void removeSelection() {
    provider.removeSelection(context);
    provider.toggleSelectionMode();
    screenPopToast("Selección eliminada");
  }

  void archiveTracking() {
    widget.tracking.archived = true;
    Provider.of<ArchivedTrackings>(context, listen: false)
        .addTracking(widget.tracking);
    provider
        .removeTracking([widget.tracking], context, widget.tracking.checkError);
    screenPopToast("Seguimiento archivado");
    if (widget.detail) Navigator.pop(context);
  }

  void archiveSelection() {
    List<ItemTracking> selection = provider.selectionElements;
    for (var element in selection) {
      element.selected = false;
      element.archived = true;
      Provider.of<ArchivedTrackings>(context, listen: false)
          .addTracking(element);
    }
    provider.removeSelection(context);
    provider.toggleSelectionMode();
    screenPopToast("Selección archivada");
  }

  void seeServiceContact() {
    interstitialAd.showInterstitialAd();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Claim(widget.tracking.service),
      ),
    );
  }

  void displayDialog(String action) {
    VoidCallback dialogFunction;
    String buttonText = action == "archivar" ? "Archivar" : 'Eliminar';
    dialogFunction = action == "archivar"
        ? () => widget.menu ? archiveTracking() : archiveSelection()
        : () => widget.menu ? removeTracking() : removeSelection();
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
                seeTrackingDetail();
                break;
              case 'Más datos':
                seeMoreTrackingData();
                break;
              case 'Renombrar':
                renameTracking();
                break;
              case 'Seleccionar':
                toggleSelectionMode();
                break;
              case 'Archivar':
                displayDialog("archivar");
                break;
              case 'Eliminar':
                displayDialog("eliminar");
                break;
              case 'Reclamar':
                seeServiceContact();
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            if (!widget.detail && widget.tracking.checkError == false)
              optionMenu('Detalles', Icons.info_outline),
            if (!widget.tracking.checkError!)
              optionMenu('Más datos', Icons.info),
            optionMenu('Renombrar', Icons.edit),
            optionMenu('Seleccionar', Icons.select_all_sharp),
            if (!widget.tracking.checkError!)
              optionMenu("Archivar", Icons.archive),
            optionMenu('Eliminar', Icons.delete),
            optionMenu('Reclamar', Icons.warning),
          ],
        ),
        "buttons": {
          "remove": IconButton(
            icon: const Icon(Icons.delete),
            iconSize: 24,
            onPressed: () => displayDialog("eliminar"),
          ),
          "archive": IconButton(
            icon: const Icon(Icons.archive),
            iconSize: 24,
            onPressed: () => displayDialog("archivar"),
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
                seeTrackingDetail();
                break;
              case 'Más datos':
                seeMoreTrackingData();
                break;
              case 'Seleccionar':
                toggleSelectionMode();
                break;
              case 'Eliminar':
                displayDialog("eliminar");
                break;
              case 'Reclamar':
                seeServiceContact();
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
            onPressed: () => displayDialog("eliminar"),
          ),
        }
      }
    };

    return widget.menu
        ? optionsList[trackingType]['menu']
        : optionsList[trackingType]['buttons'][widget.action];
  }
}
