import 'package:flutter/material.dart';
import '../data/classes.dart';
import '../widgets/ad_native.dart';

class ViewGrid {
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
    final bool portraitFullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final bool landscapeFullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1919;
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            splashColor: Theme.of(context).primaryColor,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(18.0),
                    ),
                    color: tracking.selected! ? Colors.black12 : null,
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
                                ? 40
                                : landscapeFullHD
                                    ? 42
                                    : 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.only(top: isPortrait ? 9 : 7),
                                  width: !tracking.checkError!
                                      ? isPortrait
                                          ? screenWidth * 0.312
                                          : screenWidth * 0.232
                                      : isPortrait
                                          ? screenWidth * 0.182
                                          : landscapeFullHD
                                              ? screenWidth * 0.182
                                              : screenWidth * 0.122,
                                  height: 30,
                                  child: Text(
                                    title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: portraitFullHD ? 16 : 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (tracking.checkError! && !tracking.archived!)
                                  Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: button),
                                if (!selectionMode)
                                  Column(
                                    children: [
                                      SizedBox(
                                        // constraints: BoxConstraints(maxWidth: 22),
                                        width: 36,
                                        height: 36,
                                        // padding: EdgeInsets.only(right: 5),
                                        // height: isPortrait ? 30 : 30,
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
                                            child: Padding(
                                              padding: isPortrait
                                                  ? const EdgeInsets.only(
                                                      top: 3, right: 6)
                                                  : const EdgeInsets.only(
                                                      top: 5,
                                                      right: 1,
                                                      left: 6),
                                              child: Icon(
                                                Icons.check_box,
                                                size: 32,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
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
                                          padding:
                                              const EdgeInsets.only(left: 7),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: screenWidth * 0.247,
                                                child: Text(
                                                  'Ultimo movimiento:',
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
                                      if (!isPortrait && !tracking.archived!)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 7),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: screenWidth * 0.232,
                                                child: Text(
                                                  'Ultimo movimiento:',
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
                                      if (isPortrait && tracking.archived!)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 7),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: screenWidth * 0.249,
                                                child: Text(
                                                  'Ultimo movimiento:',
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
                                              Container(
                                                width: 29,
                                                child:
                                                    const Icon(Icons.archive),
                                                alignment: Alignment.center,
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
                                                  'Ultimo movimiento:',
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
                                              Container(
                                                width: 29,
                                                child:
                                                    const Icon(Icons.archive),
                                                alignment: Alignment.center,
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
                                                    portraitFullHD ? 16 : 15,
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
                                          const Icon(Icons.check, size: 20),
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
                                              child: tracking.checkError!
                                                  ? const Text("Sin datos")
                                                  : Text(
                                                      tracking.lastCheck!,
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
                            padding: EdgeInsets.only(top: 3, bottom: 3),
                            constraints: isPortrait
                                ? BoxConstraints(
                                    maxHeight: screenHeight * 0.0582,
                                    maxWidth: screenWidth * 0.344,
                                  )
                                : BoxConstraints(
                                    maxHeight: screenHeight * 0.095,
                                    maxWidth: screenWidth * 0.2,
                                  ),
                            child: serviceLogo,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!premiumUser) AdNative("medium"),
      ],
    );
  }
}
