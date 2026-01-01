import 'package:flutter/material.dart';

import '../data/tracking_functions.dart';
import '../data/classes.dart';

import '../widgets/ad_native.dart';

class ViewRow {
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 6, left: 6, bottom: 8),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 2),
                borderRadius: const BorderRadius.all(
                  Radius.circular(12.0),
                ),
                color: tracking.selected! ? Colors.black12 : backgroundColor,
              ),
              padding: isPortrait
                  ? selectionMode
                      ? const EdgeInsets.only(
                          right: 3.4, left: 7, top: 3, bottom: 3)
                      : const EdgeInsets.only(
                          right: 2, left: 7, top: 3, bottom: 3)
                  : selectionMode
                      ? const EdgeInsets.only(
                          right: 7, left: 7, top: 8, bottom: 8)
                      : const EdgeInsets.only(
                          right: 1, left: 7, top: 8, bottom: 8),
              child: Column(
                children: [
                  Container(
                    padding: isPortrait && selectionMode
                        ? const EdgeInsets.only(right: 4)
                        : !isPortrait && selectionMode
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
                          width: isPortrait ? 75 : 110,
                          padding: const EdgeInsets.only(right: 8, left: 4),
                          height: 35,
                          child: serviceLogo,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 6, right: 8),
                          width: isPortrait
                              ? selectionMode
                                  ? screenWidth - 226
                                  : screenWidth - 221
                              : selectionMode
                                  ? screenWidth - 256
                                  : screenWidth - 255,
                          alignment: Alignment.center,
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: fullHD ? 16 : 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: 38,
                          alignment: Alignment.center,
                          child: Icon(statusIcon, size: 28),
                        ),
                        if (!tracking.archived! && tracking.checkError!) button,
                        if (!tracking.checkError!) button,
                        if (selectionMode && tracking.selected!)
                          Icon(
                            Icons.check_box,
                            size: 32,
                            color: Theme.of(context).primaryColor,
                          ),
                        if (selectionMode && !tracking.selected!)
                          Icon(
                            Icons.check_box_outline_blank,
                            size: 32,
                            color: Theme.of(context).primaryColor,
                          ),
                        if (!selectionMode)
                          SizedBox(
                            // padding: EdgeInsets.only(top: 6),
                            width: 41,
                            child: optionsButton,
                          ),
                      ],
                    ),
                  ),
                  if (expand && !tracking.checkError!)
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
                                      texts[252],
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
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
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 2),
                                  child: Text(
                                    TrackingFunctions.formatEventDetail(
                                        tracking.events[0]),
                                    style:
                                        TextStyle(fontSize: fullHD ? 16 : 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: isPortrait
                                      ? screenWidth * 0.439
                                      : screenWidth * 0.285,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(right: 7),
                                            child: Icon(Icons.calendar_month),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                texts[89],
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
                                            child: Text(
                                              TrackingFunctions.formatEventDate(
                                                  context,
                                                  tracking.events[0]["date"]!),
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
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(right: 7),
                                            child: Icon(Icons.access_time),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                texts[258],
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
                                            child: Text(
                                              tracking.events[0]["time"]!,
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
        ),
        if (!premiumUser)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: AdNative("small"),
          ),
      ],
    );
  }
}
