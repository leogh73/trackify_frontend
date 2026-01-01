import 'package:flutter/material.dart';

import '../data/classes.dart';
import '../data/tracking_functions.dart';

import '../widgets/ad_native.dart';

class ViewCard {
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
                  Radius.circular(18.0),
                ),
                color: tracking.selected! ? Colors.black12 : backgroundColor,
              ),
              padding: const EdgeInsets.only(left: 14, top: 1, bottom: 8),
              child: Column(
                children: [
                  SizedBox(
                    height: 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: isPortrait ? 75 : 100,
                          padding: const EdgeInsets.only(left: 4),
                          height: 35,
                          child: serviceLogo,
                        ),
                        Container(
                          padding: selectionMode
                              ? const EdgeInsets.only(top: 3)
                              : const EdgeInsets.only(top: 3),
                          width: isPortrait
                              ? screenWidth - 195
                              : screenWidth - 220,
                          alignment: Alignment.center,
                          child: Container(
                            padding: tracking.checkError!
                                ? const EdgeInsets.only(left: 35)
                                : EdgeInsets.zero,
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: fullHD ? 16 : 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 38,
                          alignment: Alignment.center,
                          child: Icon(statusIcon, size: 28),
                        ),
                        if (!tracking.archived! && tracking.checkError!) button,
                        if (selectionMode && tracking.selected!)
                          Padding(
                            padding: const EdgeInsets.only(top: 1, right: 9),
                            child: Icon(
                              Icons.check_box,
                              size: 32,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        if (selectionMode && !tracking.selected!)
                          Padding(
                            padding: const EdgeInsets.only(top: 1, right: 9),
                            child: Icon(
                              Icons.check_box_outline_blank,
                              size: 32,
                              color: Theme.of(context).primaryColor,
                            ),
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
                  Container(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.local_shipping, size: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            texts[252],
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
                        width: isPortrait ? screenWidth - 54 : screenWidth - 50,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 2),
                          child: tracking.checkError!
                              ? const Text("Sin datos")
                              : Text(
                                  TrackingFunctions.formatEventDetail(
                                      tracking.events[0]),
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
                                        // width: 158,
                                        child: tracking.checkError!
                                            ? const Text("Sin datos")
                                            : Text(
                                                TrackingFunctions
                                                    .formatEventDate(
                                                        context,
                                                        tracking.events[0]
                                                            ["date"]!),
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
                                        padding: const EdgeInsets.only(top: 2),
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
                ],
              ),
            ),
          ),
        ),
        if (!premiumUser)
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: AdNative("medium"),
          ),
      ],
    );
  }
  // Widget funct
}
