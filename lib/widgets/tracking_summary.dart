import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trackify/widgets/ad_native.dart';

import '../data/classes.dart';
import '../data/preferences.dart';
import '../data/tracking_functions.dart';

class TrackingSummary extends StatefulWidget {
  final ItemTracking? tracking;
  const TrackingSummary(this.tracking, {super.key});

  @override
  State<TrackingSummary> createState() => _TrackingSummaryState();
}

class _TrackingSummaryState extends State<TrackingSummary> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final String startDate = widget.tracking!.startCheck!.split(" - ")[0];
    final String startTime = widget.tracking!.startCheck!.split(" - ")[1];
    final String formattedStart =
        TrackingFunctions.formatEventDate(context, startDate);
    final String formattedStartDate = "$formattedStart - $startTime";
    final String checkDate = widget.tracking!.lastCheck!.split(" - ")[0];
    final String checkTime = widget.tracking!.lastCheck!.split(" - ")[1];
    final String formattedCheck =
        TrackingFunctions.formatEventDate(context, checkDate);
    final String formattedCheckDate = "$formattedCheck - $checkTime";
    final String daysInTransit = TrackingFunctions.daysInTransit(
        context,
        widget.tracking!.events[0]["date"]!,
        widget.tracking!.events[widget.tracking!.events.length - 1]["date"]!);
    final Map<String, IconData> statusIcon = {
      "in transit": MdiIcons.truckDeliveryOutline,
      "delayed": MdiIcons.timerAlertOutline,
      "not delivered": MdiIcons.packageVariantRemove,
      "delivered": MdiIcons.packageVariantClosedCheck,
      "error": MdiIcons.alertCircleOutline,
      "": MdiIcons.helpRhombusOutline,
    };
    final List<List<dynamic>> dataList = [
      [
        MdiIcons.truckFast,
        Icons.numbers,
        MdiIcons.calendar,
        MdiIcons.checkNetworkOutline,
        MdiIcons.calendarClock,
        MdiIcons.calendarMultipleCheck,
        statusIcon[widget.tracking?.status]
      ],
      [
        texts[259]!,
        texts[14]!,
        texts[260]!,
        texts[176]!,
        texts[250],
        texts[261]!,
        texts[87]!
      ],
      [
        widget.tracking?.service,
        widget.tracking?.code,
        formattedStartDate,
        formattedCheckDate,
        daysInTransit,
        widget.tracking?.events.length.toString(),
        texts[262][widget.tracking?.status],
      ],
    ];
    const Widget smallAd = Padding(
      padding: EdgeInsets.all(8),
      child: AdNative("small"),
    );
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            width: isPortrait ? screenWidth : screenWidth * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: isPortrait ? screenWidth * 0.3 : screenWidth * 0.2,
                  child: Icon(MdiIcons.informationVariantCircle),
                ),
                Container(
                  alignment: Alignment.center,
                  width: isPortrait ? screenWidth * 0.4 : screenWidth * 0.2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Text(
                      texts[263],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: isPortrait ? screenWidth * 0.3 : screenWidth * 0.2,
                  child: IconButton(
                    onPressed: () => setState(() {
                      expanded = !expanded;
                    }),
                    icon:
                        Icon(expanded ? Icons.expand_less : Icons.expand_more),
                  ),
                )
              ],
            ),
          ),
          if (expanded)
            Divider(
              color: Theme.of(context).primaryColor,
              thickness: 0.5,
              height: 1.5,
            ),
          if (!premiumUser && expanded) smallAd,
          if (expanded)
            Column(
              children: [
                SizedBox(
                  width: isPortrait ? screenWidth : screenWidth * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: dataList[0]
                            .map((d) => SizedBox(
                                height: 45,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Icon(d, size: 24)],
                                )))
                            .toList(),
                      ),
                      Column(
                        children: dataList[1]
                            .map((d) => SizedBox(
                                height: 45,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      d,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    )
                                  ],
                                )))
                            .toList(),
                      ),
                      SizedBox(
                        width:
                            isPortrait ? screenWidth * 0.4 : screenWidth * 0.25,
                        child: Column(
                          children: dataList[2]
                              .map((d) => SizedBox(
                                  height: 45,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        d,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            overflow: TextOverflow.ellipsis),
                                      )
                                    ],
                                  )))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!premiumUser) smallAd,
              ],
            ),
        ],
      ),
    );
  }
}
