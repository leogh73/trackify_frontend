import 'package:flutter/material.dart';
import 'package:trackify/data/tracking_functions.dart';

import '../data/classes.dart';
import '../widgets/ad_native.dart';

class ViewGrid {
  Widget widget(
    BuildContext context,
    Map<int, dynamic> texts,
    Image serviceLogo,
    Color? backgroundColor,
    IconData statusIcon,
    ItemTracking tracking,
    String daysInTransit,
    VoidCallback onTap,
    VoidCallback onLongPress,
    double screenWidth,
    String title,
    Widget button,
    bool expand,
    bool selectionMode,
    bool isPortrait,
    bool premiumUser,
    bool fullHD,
    Widget optionsButton,
  ) {
    final bool portraitFullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final bool landscapeFullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1919;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(18.0),
                    ),
                    color:
                        tracking.selected! ? Colors.black12 : backgroundColor,
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
                            padding: const EdgeInsets.only(bottom: 4, top: 4),
                            height: isPortrait ? 49 : 44,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: !tracking.checkError!
                                      ? isPortrait
                                          ? screenWidth * 0.312
                                          : screenWidth * 0.232
                                      : isPortrait
                                          ? screenWidth * 0.182
                                          : landscapeFullHD
                                              ? screenWidth * 0.182
                                              : screenWidth * 0.122,
                                  child: Text(
                                    title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: portraitFullHD ? 14 : 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (!selectionMode)
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 36,
                                        height: 36,
                                        child: optionsButton,
                                      ),
                                    ],
                                  ),
                                if (selectionMode)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Column(
                                      children: [
                                        if (tracking.selected!)
                                          SizedBox(
                                            width: 36,
                                            height: 36,
                                            child: Icon(
                                              Icons.check_box,
                                              size: 32,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        if (!tracking.selected!)
                                          SizedBox(
                                            width: 36,
                                            child: Padding(
                                              padding: isPortrait
                                                  ? const EdgeInsets.only(
                                                      top: 3, right: 6)
                                                  : const EdgeInsets.only(
                                                      top: 5,
                                                      right: 1,
                                                      left: 6),
                                              child: Icon(
                                                Icons.check_box_outline_blank,
                                                size: 32,
                                                color: Theme.of(context)
                                                    .primaryColor,
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
                                      const Icon(Icons.local_shipping,
                                          size: 20),
                                      if (isPortrait && !tracking.archived!)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, left: 7),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: screenWidth * 0.247,
                                                child: Text(
                                                  texts[252],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: portraitFullHD
                                                        ? 14
                                                        : 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (!isPortrait && !tracking.archived!)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 7),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: screenWidth * 0.232,
                                                child: Text(
                                                  texts[252],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: portraitFullHD
                                                        ? 14
                                                        : 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (isPortrait && tracking.archived!)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 7),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: screenWidth * 0.249,
                                                child: Text(
                                                  texts[252],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: portraitFullHD
                                                        ? 14
                                                        : 15,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 29,
                                                alignment: Alignment.center,
                                                child:
                                                    const Icon(Icons.archive),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (!isPortrait && tracking.archived!)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 7),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: landscapeFullHD
                                                    ? screenWidth * 0.208
                                                    : screenWidth * 0.189,
                                                child: Text(
                                                  texts[252],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: portraitFullHD
                                                        ? 14
                                                        : 15,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 29,
                                                alignment: Alignment.center,
                                                child:
                                                    const Icon(Icons.archive),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 6, bottom: 6),
                                    child: SizedBox(
                                      height: isPortrait
                                          ? portraitFullHD
                                              ? 40
                                              : 36
                                          : landscapeFullHD
                                              ? 42
                                              : 38,
                                      width: isPortrait
                                          ? screenWidth * 0.281
                                          : screenWidth * 0.262,
                                      child: tracking.checkError!
                                          ? const Text("Sin datos")
                                          : Text(
                                              tracking.lastEvent!
                                                  .split(" - ")
                                                  .last,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize:
                                                    portraitFullHD ? 15 : 16,
                                              ),
                                            ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 5, right: 1),
                                            child: Icon(Icons.calendar_month),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 7, bottom: 7),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  width: isPortrait
                                                      ? screenWidth * 0.302
                                                      : screenWidth * 0.214,
                                                  child: Text(
                                                    texts[89],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: portraitFullHD
                                                          ? 14
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
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                maxLines: 2,
                                                TrackingFunctions
                                                    .formatEventDate(
                                                        context,
                                                        tracking.events[0]
                                                            ["date"]!),
                                                style: TextStyle(
                                                    fontSize: fullHD ? 15 : 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 5, right: 1),
                                              child: Icon(Icons.access_time),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 7, bottom: 7),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    width: isPortrait
                                                        ? screenWidth * 0.302
                                                        : screenWidth * 0.214,
                                                    child: Text(
                                                      texts[258],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: portraitFullHD
                                                            ? 14
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
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  maxLines: 2,
                                                  tracking.events[0]["time"]!,
                                                  style: TextStyle(
                                                      fontSize:
                                                          fullHD ? 15 : 16),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: isPortrait
                                    ? SizedBox(
                                        width: screenWidth * 0.275,
                                        child: serviceLogo,
                                      )
                                    : SizedBox(
                                        width: screenWidth * 0.18,
                                        child: serviceLogo,
                                      ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 10),
                                child: Icon(
                                  statusIcon,
                                  size: 28,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!premiumUser)
          const SizedBox(height: 166, child: AdNative("medium")),
      ],
    );
  }
}
