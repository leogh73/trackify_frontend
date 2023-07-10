import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'ad_interstitial.dart';
import 'menu_actions.dart';
import 'data_check.dart';
import '../screens/tracking_form.dart';
import '../screens/tracking_detail.dart';

import '../providers/classes.dart';
import '../providers/trackings_active.dart';
import '../providers/trackings_archived.dart';
import '../providers/status.dart';

class ItemRow extends StatefulWidget {
  final ItemTracking tracking;
  final bool selectionMode;
  final AdInterstitial? interstitialAd;
  const ItemRow(this.tracking, this.selectionMode, this.interstitialAd,
      {Key? key})
      : super(key: key);
  @override
  _ItemRowState createState() => _ItemRowState();
}

class _ItemRowState extends State<ItemRow> {
  bool _expand = false;
  bool _retrying = false;

  selectDestiny(String listView) {
    if (listView == "main") {
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

  Widget _widgetFinal(bool error, isPortrait, screenWidth, fullHD, listView,
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
              onTap: () => _clickItem(context, widget.tracking, listView),
              onLongPress: () =>
                  _longClickItem(context, widget.tracking, listView),
              splashColor: Theme.of(context).primaryColor,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                  color: widget.tracking.selected! ? Colors.black12 : null,
                ),
                // margin: EdgeInsets.only(bottom: 2, top: 2),
                padding: isPortrait
                    ? widget.selectionMode
                        ? const EdgeInsets.only(
                            right: 3.4, left: 7, top: 3, bottom: 3)
                        : const EdgeInsets.only(
                            right: 2, left: 7, top: 3, bottom: 3)
                    : widget.selectionMode
                        ? const EdgeInsets.only(
                            right: 7, left: 7, top: 8, bottom: 8)
                        : const EdgeInsets.only(
                            right: 2, left: 7, top: 8, bottom: 8),
                child: Column(
                  children: [
                    Container(
                      padding: isPortrait && widget.selectionMode
                          ? const EdgeInsets.only(right: 4)
                          : !isPortrait && widget.selectionMode
                              ? const EdgeInsets.only(right: 2)
                              : null,
                      // : EdgeInsets.only(right: 2),
                      height: isPortrait ? 55 : 42,
                      // alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            // alignment: Alignment.bottomCenter,
                            width: isPortrait ? 82 : 110,
                            padding: const EdgeInsets.only(right: 8, left: 4),
                            height: 35,
                            child:
                                ServiceData(widget.tracking.service).getImage(),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 6, right: 8),
                            width:
                                // !widget.tracking.checkError!
                                // ?
                                isPortrait
                                    ? widget.selectionMode &&
                                            widget.tracking.archived == true
                                        ? screenWidth - 226
                                        : !widget.selectionMode &&
                                                widget.tracking.archived ==
                                                    false
                                            ? screenWidth - 187
                                            : !widget.selectionMode
                                                ? screenWidth - 226
                                                : screenWidth - 187
                                    : widget.selectionMode &&
                                            widget.tracking.archived == true
                                        ? screenWidth - 256
                                        : !widget.selectionMode &&
                                                widget.tracking.archived ==
                                                    false
                                            ? screenWidth - 219
                                            : !widget.selectionMode
                                                ? screenWidth - 254
                                                : screenWidth - 220,
                            // : widget.tracking.checkError!
                            //     ? isPortrait &&
                            //                 widget.selectionMode &&
                            //                 widget.tracking.archived ==
                            //                     true ||
                            //             widget.tracking.eliminado == true
                            //         ? screenWidth - 187
                            //         : !widget.selectionMode &&
                            //                 widget.tracking.archived ==
                            //                     false &&
                            //                 widget.tracking.eliminado == false
                            //             ? screenWidth - 277
                            //             : !widget.selectionMode
                            //                 ? screenWidth - 250
                            //                 : screenWidth - 278
                            //     : screenWidth - 279,
                            // : !isPortrait &&
                            //             widget.selectionMode &&
                            //             widget.tracking.archived ==
                            //                 true ||
                            //         widget.tracking.eliminado == true
                            //     ? screenWidth - 272
                            //     : !widget.selectionMode &&
                            //             widget.tracking.archived ==
                            //                 false &&
                            //             widget.tracking.eliminado == false
                            //         ? screenWidth - 220
                            //         : !widget.selectionMode
                            //             ? screenWidth - 253
                            //             : screenWidth - 220,
                            alignment: Alignment.center,
                            child: Text(
                              text,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: fullHD ? 16 : 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (widget.tracking.archived == true)
                            const SizedBox(
                              width: 38,
                              child: Icon(Icons.archive),
                            ),
                          if (!widget.tracking.archived! &&
                              widget.tracking.checkError!)
                            button,
                          if (!widget.tracking.checkError!) button,
                          if (widget.selectionMode && widget.tracking.selected!)
                            Icon(
                              Icons.check_box,
                              size: 32,
                              color: Theme.of(context).primaryColor,
                            ),
                          if (widget.selectionMode &&
                              !widget.tracking.selected!)
                            Icon(
                              Icons.check_box_outline_blank,
                              size: 32,
                              color: Theme.of(context).primaryColor,
                            ),
                          if (!widget.selectionMode && listView != "search")
                            SizedBox(
                              // padding: EdgeInsets.only(top: 6),
                              width: 38,
                              child: ActionsMenu(
                                action: '',
                                screen: listView,
                                menu: true,
                                detail: false,
                                icon: 24,
                                tracking: widget.tracking,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (_expand && !widget.tracking.checkError!)
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 4, right: 4, top: 8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.local_shipping, size: 20),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Ultimo movimiento:',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: fullHD ? 16 : 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: isPortrait
                                      ? screenWidth - 54
                                      : screenWidth - 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 2),
                                    child: Text(
                                      widget.tracking.lastEvent!,
                                      style:
                                          TextStyle(fontSize: fullHD ? 16 : 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: isPortrait
                                        ? screenWidth * 0.439
                                        : screenWidth * 0.285,
                                    child: Column(
                                      children: [
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 7),
                                              child: Icon(Icons.check),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'Ultimo chequeo:',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize:
                                                          fullHD ? 16 : 15),
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
                                              child: Text(
                                                widget.tracking.lastCheck!,
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
                                  SizedBox(
                                    width: isPortrait
                                        ? screenWidth * 0.441
                                        : screenWidth * 0.275,
                                    child: Column(
                                      children: [
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 7),
                                              child: Icon(
                                                  Icons.add_circle_outline),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'Inicio:',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize:
                                                          fullHD ? 16 : 15),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: isPortrait
                                                  ? screenWidth * 0.441
                                                  : screenWidth * 0.275,
                                              padding: const EdgeInsets.only(
                                                  top: 2, bottom: 2),
                                              // width: 158,
                                              child: Text(
                                                widget.tracking.startCheck!,
                                                overflow: TextOverflow.clip,
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
                                  if (!isPortrait)
                                    SizedBox(
                                      width: screenWidth * 0.325,
                                      child: Column(
                                        children: [
                                          Row(
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 7),
                                                child: Icon(Icons.short_text),
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    'Código:',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize:
                                                            fullHD ? 16 : 15),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: screenWidth * 0.315,
                                                padding: const EdgeInsets.only(
                                                    top: 2, bottom: 2),
                                                // width: 158,
                                                child: Text(
                                                  widget.tracking.code,
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
                                  //   height: 10,
                                  // ),
                                  // Container(
                                  //   width: isPortrait ? 127 : 224,
                                  //   child: Row(
                                  //     children: [],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            if (isPortrait)
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 2),
                                width: isPortrait
                                    ? screenWidth * 0.965
                                    : screenWidth * 0.325,
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 4, bottom: 4, right: 7),
                                      child: Icon(Icons.short_text),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          padding:
                                              const EdgeInsets.only(right: 7),
                                          // alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Código:',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: fullHD ? 16 : 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 4, bottom: 4),
                                      // width: 158,
                                      child: Text(
                                        widget.tracking.code,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: fullHD ? 16 : 15,
                                        ),
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
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    var listView = "main";
    if (widget.tracking.search!) {
      listView = "search";
    } else if (widget.tracking.archived!) {
      listView = "archived";
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
                listView,
                "ERROR",
                SizedBox(
                  width: 38,
                  child: IconButton(
                    icon: const Icon(Icons.sync),
                    onPressed: () => _retryErrorTracking(widget.tracking),
                  ),
                ),
              )
            : _widgetFinal(
                false,
                isPortrait,
                screenWidth,
                fullHD,
                listView,
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
