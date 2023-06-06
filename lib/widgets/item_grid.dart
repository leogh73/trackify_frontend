import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'ad_interstitial.dart';
import 'menu_actions.dart';
import 'data_check.dart';
// import './seleccionar_servicio.dart';

import '../screens/tracking_detail.dart';
import '../screens/tracking_form.dart';

import '../providers/classes.dart';
import '../providers/trackings_active.dart';
import '../providers/trackings_archived.dart';
import '../providers/status.dart';

class ItemGrid extends StatefulWidget {
  final ItemTracking tracking;
  final bool selectionMode;
  final AdInterstitial? interstitialAd;
  const ItemGrid(this.tracking, this.selectionMode, this.interstitialAd,
      {Key? key})
      : super(key: key);

  @override
  _ItemGridState createState() => _ItemGridState();
}

class _ItemGridState extends State<ItemGrid> {
  bool _retrying = false;

  selectDestiny(String screenName) {
    if (screenName == "main") {
      return Provider.of<ActiveTrackings>(context, listen: false);
    } else {
      return Provider.of<ArchivedTrackings>(context, listen: false);
    }
  }

  void _seeTrackingDetail() {
    widget.interstitialAd?.showInterstitialAd();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrackingDetail(widget.tracking),
      ),
    );
    Provider.of<Status>(context, listen: false).resetEndOfEventsStatus();
  }

  void _retryErrorTracking(ItemTracking tracking) async {
    setState(() {
      _retrying = true;
    });
    await DataCheck(context, tracking, true).startCheck();
    setState(() {
      _retrying = false;
    });
  }

  void _changeSelectionMode(ItemTracking tracking, String screen) {
    selectDestiny(screen).toggleSelectionMode();
    if (widget.selectionMode == false) {
      selectDestiny(screen).activateStartSelection(tracking);
    }
  }

  void _trackingClick(ItemTracking tracking, String screen) {
    if (tracking.selected == true) {
      selectDestiny(screen).removeSelected(tracking.idSB);
      tracking.selected = false;
    } else {
      selectDestiny(screen).addSelected(tracking);
      tracking.selected = true;
    }
  }

  void _clickItem(context, tracking, screenName) {
    if (widget.selectionMode && widget.tracking.checkError! ||
        widget.selectionMode &&
            !widget.tracking.checkError! &&
            screenName != "search") {
      _trackingClick(widget.tracking, screenName);
    } else if (!widget.selectionMode && !widget.tracking.checkError! ||
        screenName == "search") {
      _seeTrackingDetail();
    }
  }

  void _longClickItem(context, tracking, screenName) {
    if (widget.selectionMode ||
        !widget.selectionMode ||
        screenName != "search") {
      _changeSelectionMode(tracking, screenName);
    } else {
      return;
    }
  }

  Widget _widgetFinal(
      bool error,
      isPortrait,
      screenWidth,
      screenName,
      context,
      landscapeFullHD,
      portraitFullHD,
      screenHeight,
      String text,
      Widget? boton) {
    return _retrying
        ? Center(
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: const SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  Text(
                    'Verificando...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: portraitFullHD ? 16 : 15,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding:
                const EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 0),
            child: InkWell(
              onTap: () => _clickItem(context, widget.tracking, screenName),
              onLongPress: () =>
                  _longClickItem(context, widget.tracking, screenName),
              splashColor: Theme.of(context).primaryColor,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                  color: widget.tracking.selected! ? Colors.black12 : null,
                ),
                // margin: EdgeInsets.all(4),
                padding: const EdgeInsets.only(
                    top: 6, right: 3, left: 15, bottom: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Wrap(
                      direction: Axis.vertical,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 4),
                          height: isPortrait
                              ? 45
                              : landscapeFullHD
                                  ? 52
                                  : 49,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                // padding: EdgeInsets.zero,
                                constraints: BoxConstraints(
                                  maxWidth: !widget.tracking.checkError!
                                      ? isPortrait
                                          ? screenWidth * 0.312
                                          : screenWidth * 0.232
                                      // : widget.tracking.checkError!
                                      //     ? isPortrait
                                      //         ? screenWidth * 0.312
                                      //         : screenWidth * 0.232
                                      : screenWidth * 0.335,
                                  maxHeight: 38,
                                ),
                                child: Text(
                                  text,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: portraitFullHD ? 16 : 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (widget.tracking.checkError! &&
                                  !widget.tracking.archived!)
                                Container(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 6),
                                    child: boton),
                              if (!widget.selectionMode &&
                                  screenName != "search")
                                Column(
                                  children: [
                                    SizedBox(
                                      // constraints: BoxConstraints(maxWidth: 22),
                                      width: 36,
                                      height: 36,
                                      // padding: EdgeInsets.only(right: 5),
                                      // height: isPortrait ? 30 : 30,
                                      child: ActionsMenu(
                                        action: '',
                                        screen: screenName,
                                        menu: true,
                                        detail: false,
                                        icon: 24,
                                        tracking: widget.tracking,
                                      ),
                                    ),
                                  ],
                                ),
                              if (widget.selectionMode)
                                Column(
                                  children: [
                                    if (widget.tracking.selected!)
                                      SizedBox(
                                        width: 36,
                                        child: Padding(
                                          padding: isPortrait
                                              ? const EdgeInsets.only(
                                                  top: 3, right: 6)
                                              : const EdgeInsets.only(
                                                  top: 5, right: 1, left: 6),
                                          child: Icon(
                                            Icons.check_box,
                                            size: 32,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    if (!widget.tracking.selected!)
                                      SizedBox(
                                        width: 36,
                                        child: Padding(
                                          padding: isPortrait
                                              ? const EdgeInsets.only(
                                                  top: 3, right: 6)
                                              : const EdgeInsets.only(
                                                  top: 5, right: 1, left: 6),
                                          child: Icon(
                                            Icons.check_box_outline_blank,
                                            size: 32,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Wrap(
                          direction: Axis.vertical,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.local_shipping, size: 20),
                                    if (isPortrait &&
                                        !widget.tracking.archived!)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 7),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: screenWidth * 0.247,
                                              child: Text(
                                                'Ultimo movimiento:',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize:
                                                      portraitFullHD ? 16 : 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (!isPortrait &&
                                        !widget.tracking.archived!)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 7),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: screenWidth * 0.232,
                                              child: Text(
                                                'Ultimo movimiento:',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize:
                                                      portraitFullHD ? 16 : 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (isPortrait && widget.tracking.archived!)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 7),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: screenWidth * 0.249,
                                              child: Text(
                                                'Ultimo movimiento:',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize:
                                                      portraitFullHD ? 16 : 15,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 29,
                                              child: const Icon(Icons.archive),
                                              alignment: Alignment.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (!isPortrait &&
                                        widget.tracking.archived!)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 7),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: landscapeFullHD
                                                  ? screenWidth * 0.208
                                                  : screenWidth * 0.189,
                                              child: Text(
                                                'Ultimo movimiento:',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize:
                                                      portraitFullHD ? 16 : 15,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 29,
                                              child: const Icon(Icons.archive),
                                              alignment: Alignment.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 6, bottom: 6),
                                  child: SizedBox(
                                    height: isPortrait
                                        ? portraitFullHD
                                            ? 42
                                            : 38
                                        : landscapeFullHD
                                            ? 44
                                            : 40,
                                    width: isPortrait
                                        ? screenWidth * 0.381
                                        : screenWidth * 0.262,
                                    child: widget.tracking.checkError!
                                        ? const Text("Sin datos")
                                        : Text(
                                            widget.tracking.lastEvent!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize:
                                                  portraitFullHD ? 16 : 15,
                                            ),
                                          ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.check, size: 20),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 7),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: isPortrait
                                                    ? screenWidth * 0.302
                                                    : screenWidth * 0.214,
                                                child: Text(
                                                  'Ultimo chequeo:',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: portraitFullHD
                                                        ? 16
                                                        : 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: isPortrait
                                              ? screenWidth * 0.381
                                              : screenWidth * 0.271,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 6, bottom: 6),
                                            child: widget.tracking.checkError!
                                                ? const Text("Sin datos")
                                                : Text(
                                                    widget.tracking.lastCheck!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: portraitFullHD
                                                          ? 16
                                                          : 15,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // padding: EdgeInsets.only(top: 2),
                          constraints: isPortrait
                              ? BoxConstraints(
                                  maxHeight: screenHeight * 0.0582,
                                  maxWidth: screenWidth * 0.344,
                                )
                              : BoxConstraints(
                                  maxHeight: screenHeight * 0.095,
                                  maxWidth: screenWidth * 0.2,
                                ),
                          child: ServiceImage(widget.tracking.service).load(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    var screenName = "main";
    if (widget.tracking.search!) {
      screenName = "search";
    } else if (widget.tracking.archived!) {
      screenName = "archived";
    }
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool portraitFullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final bool landscapeFullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1919;
    var events = widget.tracking.events?.length ?? 0;
    return events == 0 && widget.tracking.checkError == null
        ? ProcessData(widget.tracking, false)
        : events == 0 && widget.tracking.checkError != false
            ? _widgetFinal(
                true,
                isPortrait,
                screenWidth,
                screenName,
                context,
                landscapeFullHD,
                portraitFullHD,
                screenHeight,
                "ERROR",
                SizedBox(
                  width: 38,
                  child: IconButton(
                    icon: const Icon(Icons.sync),
                    onPressed: () {
                      setState(() {
                        _retryErrorTracking(widget.tracking);
                      });
                    },
                  ),
                ),
              )
            : _widgetFinal(
                false,
                isPortrait,
                screenWidth,
                screenName,
                context,
                landscapeFullHD,
                portraitFullHD,
                screenHeight,
                widget.tracking.title!,
                null,
              );
  }
}
