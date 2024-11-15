import 'package:flutter/material.dart';

import '../data/classes.dart';
import '../widgets/ad_native.dart';

class ViewCard {
  Widget widget(
    BuildContext context,
    Image serviceLogo,
    ItemTracking tracking,
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
            splashColor: Theme.of(context).primaryColor,
            child: Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 2),
                borderRadius: const BorderRadius.all(
                  Radius.circular(18.0),
                ),
                color: tracking.selected! ? Colors.black12 : null,
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
                          padding: selectionMode
                              ? const EdgeInsets.only(top: 3, left: 25)
                              : const EdgeInsets.only(top: 3, left: 25),
                          width: tracking.checkError! == false
                              ? isPortrait
                                  ? selectionMode && tracking.archived == true
                                      ? screenWidth - 110
                                      : !selectionMode &&
                                              tracking.archived == false
                                          ? screenWidth - 80
                                          : !selectionMode
                                              ? screenWidth - 110
                                              : screenWidth - 80
                                  : selectionMode && tracking.archived == true
                                      ? screenWidth - 110
                                      : !selectionMode &&
                                              tracking.archived == false
                                          ? screenWidth - 80
                                          : !selectionMode
                                              ? screenWidth - 110
                                              : screenWidth - 80
                              : isPortrait
                                  ? selectionMode && tracking.archived == true
                                      ? screenWidth - 110
                                      : !selectionMode &&
                                              tracking.archived == false
                                          ? screenWidth - 110
                                          : !selectionMode
                                              ? screenWidth - 110
                                              : screenWidth - 110
                                  : screenWidth - 110,
                          alignment: Alignment.center,
                          child: Container(
                            padding: tracking.checkError!
                                ? const EdgeInsets.only(left: 35)
                                : EdgeInsets.zero,
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: fullHD ? 16 : 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (tracking.archived == true)
                          Container(
                            width: 38,
                            child: const Icon(Icons.archive),
                            alignment: Alignment.center,
                          ),
                        if (!tracking.archived! && tracking.checkError!) button,
                        // if (!tracking.checkError!) button,
                        if (selectionMode && tracking.selected!)
                          Padding(
                            padding: const EdgeInsets.only(top: 1, right: 6),
                            child: Icon(
                              Icons.check_box,
                              size: 32,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        if (selectionMode && !tracking.selected!)
                          Padding(
                            padding: const EdgeInsets.only(top: 1, right: 6),
                            child: Icon(
                              Icons.check_box_outline_blank,
                              size: 32,
                              color: Theme.of(context).primaryColor,
                            ),
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
                        width: isPortrait ? screenWidth - 54 : screenWidth - 50,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 2),
                          child: tracking.checkError!
                              ? const Text("Sin datos")
                              : Text(
                                  tracking.lastEvent!,
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
                                        child: tracking.checkError!
                                            ? const Text("Sin datos")
                                            : Text(
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
                              width: isPortrait ? 127 : 224,
                              child: Row(
                                children: [
                                  Container(
                                    width: isPortrait ? 87 : 180,
                                    // alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.zero,
                                    height: 35,
                                    child: serviceLogo,
                                  ),
                                  button,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (expand)
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 12, bottom: 4, right: 15),
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
                                      child: tracking.checkError!
                                          ? const Text("Sin datos")
                                          : Text(
                                              tracking.startCheck!,
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
                                        tracking.code,
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
        ),
        if (!premiumUser)
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: AdNative("medium"),
          ),
      ],
    );
  }
  // Widget funct
}
