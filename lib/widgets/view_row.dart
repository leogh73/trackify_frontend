import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../data/tracking_functions.dart';
import '../data/classes.dart';

import '../widgets/ad_native.dart';

class ViewRow {
  Widget widget(
    BuildContext context,
    Image serviceLogo,
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
                color: tracking.selected! ? Colors.black12 : null,
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
                          right: 2, left: 7, top: 8, bottom: 8),
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
                          width: isPortrait ? 82 : 110,
                          padding: const EdgeInsets.only(right: 8, left: 4),
                          height: 35,
                          child: serviceLogo,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 6, right: 8),
                          width: isPortrait
                              ? selectionMode && tracking.archived == true
                                  ? screenWidth - 226
                                  : !selectionMode && tracking.archived == false
                                      ? screenWidth - 187
                                      : !selectionMode
                                          ? screenWidth - 226
                                          : screenWidth - 187
                              : selectionMode && tracking.archived == true
                                  ? screenWidth - 256
                                  : !selectionMode && tracking.archived == false
                                      ? screenWidth - 219
                                      : !selectionMode
                                          ? screenWidth - 254
                                          : screenWidth - 220,
                          alignment: Alignment.center,
                          child: Text(
                            title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: fullHD ? 16 : 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (tracking.archived == true)
                          const SizedBox(
                            width: 38,
                            child: Icon(Icons.archive),
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
                            width: 38,
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
                                      'Ultimo movimiento:',
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
                                    TrackingFunctions.formatEventDate(
                                        context, tracking.lastEvent!, false),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            child: Text(
                                              tracking.lastCheck!,
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
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 7),
                                            child: Icon(MdiIcons.calendarClock),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Días en tránsito:',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: fullHD ? 16 : 15),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: isPortrait
                                            ? screenWidth * 0.441
                                            : screenWidth * 0.275,
                                        padding: const EdgeInsets.only(
                                            top: 2, bottom: 2),
                                        child: // width: 158,
                                            Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              daysInTransit,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                fontSize: fullHD ? 16 : 15,
                                              ),
                                            ),
                                          ],
                                        ),
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
                                                tracking.code,
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
                          if (isPortrait)
                            Container(
                              padding: const EdgeInsets.only(top: 4, bottom: 2),
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
                                      tracking.code,
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
