import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'ad_interstitial.dart';
import 'data_check.dart';
// import './seleccionar_servicio.dart';

import '../screens/tracking_detail.dart';
import '../screens/tracking_form.dart';

import 'menu_actions.dart';

import '../providers/classes.dart';
import '../providers/trackings_active.dart';
import '../providers/trackings_archived.dart';
import '../providers/status.dart';

class ItemCard extends StatefulWidget {
  final ItemTracking tracking;
  final bool selectionMode;
  final AdInterstitial? interstitialAd;
  const ItemCard(this.tracking, this.selectionMode, this.interstitialAd,
      {Key? key})
      : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool _expand = false;
  bool _retrying = false;

  selectDestination(String screenLista) {
    if (screenLista == "main") {
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
    selectDestination(screen).toggleSelectionMode();
    if (widget.selectionMode == false) {
      selectDestination(screen).activateStartSelection(tracking);
    }
  }

  void _trackingClick(ItemTracking tracking, String screen) {
    if (tracking.selected == true) {
      selectDestination(screen).removeSelected(tracking.idSB);
      tracking.selected = false;
    } else {
      selectDestination(screen).addSelected(tracking);
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

  Widget _widgetFinal(bool error, isPortrait, screenWidth, fullHD, screen,
      String text, Widget button) {
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
                      fontSize: fullHD ? 16 : 15,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(right: 6, left: 6, bottom: 8),
            child: InkWell(
              onTap: () => _clickItem(context, widget.tracking, screen),
              onLongPress: () =>
                  _longClickItem(context, widget.tracking, screen),
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
                // margin: EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.only(left: 14, top: 1, bottom: 8),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: widget.selectionMode
                                ? const EdgeInsets.only(top: 3, left: 25)
                                : const EdgeInsets.only(top: 3, left: 25),
                            width: widget.tracking.checkError! == false
                                ? isPortrait
                                    ? widget.selectionMode &&
                                            widget.tracking.archived == true
                                        ? screenWidth - 110
                                        : !widget.selectionMode &&
                                                widget.tracking.archived ==
                                                    false
                                            ? screenWidth - 80
                                            : !widget.selectionMode
                                                ? screenWidth - 110
                                                : screenWidth - 80
                                    : widget.selectionMode &&
                                            widget.tracking.archived == true
                                        ? screenWidth - 110
                                        : !widget.selectionMode &&
                                                widget.tracking.archived ==
                                                    false
                                            ? screenWidth - 80
                                            : !widget.selectionMode
                                                ? screenWidth - 110
                                                : screenWidth - 80
                                : isPortrait
                                    ? widget.selectionMode &&
                                            widget.tracking.archived == true
                                        ? screenWidth - 110
                                        : !widget.selectionMode &&
                                                widget.tracking.archived ==
                                                    false
                                            ? screenWidth - 110
                                            : !widget.selectionMode
                                                ? screenWidth - 110
                                                : screenWidth - 110
                                    // : widget.selectionMode &&
                                    //             widget.tracking.archived ==
                                    //                 true ||
                                    //         widget.tracking.eliminado == true
                                    //     ? screenWidth - 148
                                    //     : !widget.selectionMode &&
                                    //             widget.tracking.archived ==
                                    //                 false &&
                                    //             widget.tracking.eliminado == false
                                    //         ? screenWidth - 80
                                    //         : !widget.selectionMode
                                    //             ? screenWidth - 110
                                    : screenWidth - 110,
                            // !widget.selectionMode
                            //     ? screenWidth - 69
                            //     :

                            alignment: Alignment.center,
                            child: Container(
                              padding: widget.tracking.checkError!
                                  ? const EdgeInsets.only(left: 35)
                                  : EdgeInsets.zero,
                              child: Text(
                                text,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: fullHD ? 16 : 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (widget.tracking.archived == true)
                            Container(
                              width: 38,
                              child: const Icon(Icons.archive),
                              alignment: Alignment.center,
                            ),
                          if (!widget.tracking.archived! &&
                              widget.tracking.checkError!)
                            button,
                          // if (!widget.tracking.checkError!) button,
                          if (widget.selectionMode && widget.tracking.selected!)
                            Padding(
                              padding: const EdgeInsets.only(top: 1, right: 6),
                              child: Icon(
                                Icons.check_box,
                                size: 32,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          if (widget.selectionMode &&
                              !widget.tracking.selected!)
                            Padding(
                              padding: const EdgeInsets.only(top: 1, right: 6),
                              child: Icon(
                                Icons.check_box_outline_blank,
                                size: 32,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          if (!widget.selectionMode && screen != "search")
                            SizedBox(
                              // padding: EdgeInsets.only(top: 6),
                              width: 38,
                              child: ActionsMenu(
                                action: '',
                                screen: screen,
                                menu: true,
                                detail: false,
                                icon: 24,
                                tracking: widget.tracking,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.local_shipping, size: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              'Ultimo movimiento:',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: fullHD ? 16 : 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width:
                              isPortrait ? screenWidth - 54 : screenWidth - 50,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 2),
                            child: widget.tracking.checkError!
                                ? const Text("Sin datos")
                                : Text(
                                    widget.tracking.lastEvent!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: fullHD ? 16 : 15,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 4),
                                width: isPortrait
                                    ? fullHD
                                        ? 168
                                        : 157
                                    : 235,
                                child: Column(
                                  children: [
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 7),
                                          child: Icon(Icons.check),
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Ultimo chequeo:',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: fullHD ? 16 : 15),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              top: 2, bottom: 2),
                                          // width: 158,
                                          child: widget.tracking.checkError!
                                              ? const Text("Sin datos")
                                              : Text(
                                                  widget.tracking.lastCheck!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: fullHD ? 16 : 15,
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: 18,
                              // ),
                              SizedBox(
                                width: isPortrait ? 127 : 224,
                                child: Row(
                                  children: [
                                    Container(
                                      width: isPortrait ? 87 : 180,
                                      // alignment: Alignment.bottomCenter,
                                      padding: EdgeInsets.zero,
                                      height: 35,
                                      child:
                                          ServiceData(widget.tracking.service)
                                              .getImage(),
                                    ),
                                    SizedBox(
                                      width: 36,
                                      child: IconButton(
                                        icon: Icon(_expand
                                            ? Icons.expand_less
                                            : Icons.expand_more),
                                        onPressed: () {
                                          setState(() {
                                            _expand = !_expand;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_expand)
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12, bottom: 4, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 4),
                              width: isPortrait
                                  // ? fullHD
                                  ? screenWidth * 0.421
                                  // : 134
                                  : screenWidth * 0.331,
                              child: Column(
                                children: [
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 7),
                                        child: Icon(Icons.add_circle_outline),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'Inicio:',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: fullHD ? 16 : 15),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 2, bottom: 2),
                                        // width: 158,
                                        child: widget.tracking.checkError!
                                            ? const Text("Sin datos")
                                            : Text(
                                                widget.tracking.startCheck!,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: fullHD ? 16 : 15,
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 4, left: 5),
                              width: isPortrait
                                  // ? fullHD
                                  ? screenWidth * 0.421
                                  // : 134
                                  : screenWidth * 0.331,
                              child: Column(
                                children: [
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 7),
                                        child: Icon(Icons.short_text),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'Código:',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: fullHD ? 16 : 15),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 2, bottom: 2),
                                        width: isPortrait
                                            ? screenWidth * 0.404
                                            : screenWidth * 0.318,
                                        child: Text(
                                          widget.tracking.code,
                                          overflow: TextOverflow.ellipsis,
                                          // maxLines: 2,
                                          style: TextStyle(
                                            fontSize: fullHD ? 16 : 15,
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
                      ),
                  ],
                ),
              ),
            ),
          );
  }
  // Widget function

  @override
  Widget build(BuildContext context) {
    var screen = "main";
    if (widget.tracking.search!) {
      screen = "search";
    } else if (widget.tracking.archived!) {
      screen = "archived";
    }
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    var events = widget.tracking.events?.length ?? 0;
    return events == 0 && widget.tracking.checkError == null
        ? ProcessData(widget.tracking, false)
        : events == 0 && widget.tracking.checkError != false
            ? _widgetFinal(
                true,
                isPortrait,
                screenWidth,
                fullHD,
                screen,
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
                fullHD,
                screen,
                widget.tracking.title!,
                SizedBox(
                  width: 38,
                  child: IconButton(
                    icon: Icon(_expand ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        _expand = !_expand;
                      });
                    },
                  ),
                ),
              );
  }
}
