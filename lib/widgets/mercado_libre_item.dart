import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/preferences.dart';
import '../data/services.dart';

import '../screens/form_add.dart';

import '../widgets/ad_native.dart';
import '../widgets/mercado_libre_check.dart';

class MercadoLibreItem extends StatefulWidget {
  final MeLiItemData itemML;
  const MercadoLibreItem(this.itemML, {Key? key}) : super(key: key);

  @override
  MercadoLibreItemState createState() => MercadoLibreItemState();
}

class MercadoLibreItemState extends State<MercadoLibreItem> {
  bool _expand = false;

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(right: 8, left: 6, bottom: 6),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          padding: isPortrait
              ? const EdgeInsets.only(right: 4, left: 7, top: 3, bottom: 3)
              : const EdgeInsets.only(right: 4, left: 7, top: 8, bottom: 8),
          child: Column(
            children: [
              SizedBox(
                height: isPortrait ? 55 : 42,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: screenWidth - 105,
                      padding: const EdgeInsets.only(left: 6, right: 8),
                      alignment: Alignment.center,
                      child: Text(
                        widget.itemML.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: fullHD ? 16 : 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 38,
                      child: IconButton(
                        icon: Icon(
                            _expand ? Icons.expand_less : Icons.expand_more),
                        onPressed: () {
                          setState(() {
                            _expand = !_expand;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 38,
                      child: IconButton(
                        icon: const Icon(
                          Icons.add_circle_outlined,
                          size: 26,
                        ),
                        onPressed: () {
                          if (widget.itemML.code.startsWith("MEL", 0)) {
                            Provider.of<Services>(context, listen: false)
                                .loadService("Mercado Libre", context);
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FormAdd(
                                storeName: "Mercado Libre",
                                shippingId: widget.itemML.shippingId,
                                title: widget.itemML.title,
                                code: widget.itemML.code,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (_expand)
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4, top: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.shopping_bag_outlined, size: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Column(
                              children: [
                                Text(
                                  texts[173]!,
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
                              padding: const EdgeInsets.only(top: 4, bottom: 2),
                              child: Text(
                                widget.itemML.items[0],
                                style: TextStyle(fontSize: fullHD ? 16 : 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_city, size: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 12, top: 8),
                            child: Column(
                              children: [
                                Text(
                                  texts[174]!,
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
                              padding: const EdgeInsets.only(top: 4, bottom: 2),
                              child: Text(
                                widget.itemML.origin,
                                style: TextStyle(fontSize: fullHD ? 16 : 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.person_pin_circle_outlined,
                              size: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 12, top: 8),
                            child: Column(
                              children: [
                                Text(
                                  texts[175]!,
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
                              padding: const EdgeInsets.only(top: 4, bottom: 2),
                              child: Text(
                                "${widget.itemML.destination['name']} - ${widget.itemML.destination['address']}",
                                style: TextStyle(fontSize: fullHD ? 16 : 15),
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
                                            texts[176]!,
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
                                          widget.itemML.lastUpdate,
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
                                        padding: EdgeInsets.only(right: 7),
                                        child: Icon(Icons.add_circle_outline),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            texts[177]!,
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
                                        width: isPortrait
                                            ? screenWidth * 0.404
                                            : screenWidth * 0.275,
                                        padding: const EdgeInsets.only(
                                            top: 2, bottom: 2),
                                        // width: 158,
                                        child: Text(
                                          widget.itemML.creationDate,
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
                            if (!isPortrait)
                              SizedBox(
                                width: screenWidth * 0.325,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 7),
                                          child: Icon(Icons.short_text),
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              texts[178]!,
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
                                          width: screenWidth * 0.315,
                                          padding: const EdgeInsets.only(
                                              top: 2, bottom: 2),
                                          child: Text(
                                            widget.itemML.code,
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
                                    padding: const EdgeInsets.only(right: 7),
                                    // alignment: Alignment.centerLeft,
                                    child: Text(
                                      texts[178]!,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: fullHD ? 16 : 15),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                // width: 158,
                                child: Text(
                                  widget.itemML.code,
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
      if (!premiumUser)
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: AdNative("small"),
        ),
    ]);
  }
}
